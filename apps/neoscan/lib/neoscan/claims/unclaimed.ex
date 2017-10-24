defmodule Neoscan.Claims.Unclaimed do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Vouts.Vout
  alias NeoscanMonitor.Api
  alias Neoscan.Blocks.Block
  alias Neoscan.Helpers

  #total amount of available NEO
  def total_neo, do: 100_000_000

  #calculate unclaimed gas bonus
  def calculate_bonus(address_id) do
    get_unclaimed_vouts(address_id)
    |> add_end_height
    |> route_if_there_is_unclaimed
    |> Helpers.round_or_not
  end

  #proceed calculus if there are unclaimed results, otherwise return 0
  def route_if_there_is_unclaimed([]) do
    0
  end
  def route_if_there_is_unclaimed(unclaimed) do
    blocks_with_gas = get_unclaimed_block_range(unclaimed)
                      |> get_blocks_gas

    Enum.reduce(
      unclaimed,
      0,
      fn (vout, acc) -> acc + compute_vout_bonus(vout, blocks_with_gas) end
    )
  end

  #compute bonus for a singel vout
  def compute_vout_bonus(
        %{
          :value => value,
          :start_height => start_height,
          :end_height => end_height
        },
        blocks_with_gas
      ) do
    total_gas = Enum.filter(
                  blocks_with_gas,
                  fn %{:index => index} ->
                    index >= start_height && index <= end_height end
                )
                |> Enum.reduce(0, fn (%{:gas => gas}, acc) -> acc + gas end)

    total_gas * value / total_neo()
  end

  #get all unclaimed transaction vouts
  def get_unclaimed_vouts(address_id) do
    query = from v in Vout,
                 where: v.address_id == ^address_id
                        and v.claimed == false
                        and v.asset == "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
                 select: map(v, [:value, :start_height, :end_height])

    Repo.all(query)
  end

  def add_end_height(unclaimed_vouts) do
    Enum.map(
      unclaimed_vouts,
      fn %{:end_height => height} = vout ->
        Map.put(vout, :end_height, check_end_height(height)) end
    )
  end

  #get block range of unclaimed transaction vouts
  def get_unclaimed_block_range(unclaimed_vouts) do
    end_height_list = Enum.map(
      unclaimed_vouts,
      fn %{:end_height => end_height} -> check_end_height(end_height) end
    )

    max = end_height_list
          |> Enum.max

    min = Enum.map(
            unclaimed_vouts,
            fn %{:start_height => start_height} -> start_height end
          )
          |> Enum.min

    {min, max}
  end

  #check end_height and use current height when transaction vout wasn't used
  def check_end_height(nil) do
    {:ok, height} = Api.get_height
    height
  end
  def check_end_height(number) do
    number
  end

  #get total gas distribution amount for all blocks in a given range tuple
  def get_blocks_gas({min, max}) do
    query = from b in Block,
                 where: b.index >= ^min and b.index <= ^max,
                 select: map(b, [:index, :total_sys_fee, :gas_generated])

    Repo.all(query)
    |> Enum.map(
         fn %{:index => index, :total_sys_fee => sys, :gas_generated => gen} ->
           %{:index => index, :gas => sys + gen}
         end
       )
  end

end
