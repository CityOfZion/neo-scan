defmodule Neoscan.Claims.Unclaimed do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Repair
  alias Neoscan.Vouts.Vout
  alias NeoscanMonitor.Api
  alias Neoscan.Blocks.Block
  alias Neoscan.Blocks
  alias Neoscan.BlockGasGeneration

  require Logger

  # total amount of available NEO
  def total_neo, do: 100_000_000

  # calculate unclaimed gas bonus
  def calculate_bonus(address_id) do
    get_unclaimed_vouts(address_id)
    |> add_end_height
    |> route_if_there_is_unclaimed
  end

  # calculate unclaimed gas bonus
  def calculate_vouts_bonus(address_id) do
    get_unclaimed_vouts(address_id)
    |> filter_end_height
    |> route_if_there_is_unclaimed_but_dont_add
  end

  # proceed calculus if there are unclaimed results, otherwise return 0
  def route_if_there_is_unclaimed([]) do
    0
  end

  def route_if_there_is_unclaimed(unclaimed) do
    blocks_with_gas =
      get_unclaimed_block_range(unclaimed)
      |> get_blocks_gas

    Enum.reduce(unclaimed, 0, fn vout, acc ->
      %{:claim => c, :sys_fee => s} = compute_vout_bonus(vout, blocks_with_gas)
      acc + c + s
    end)
  end

  # proceed calculus if there are unclaimed results, otherwise return 0
  def route_if_there_is_unclaimed_but_dont_add([]) do
    []
  end

  def route_if_there_is_unclaimed_but_dont_add(unclaimed) do
    blocks =
      get_unclaimed_block_range(unclaimed)
      |> verified_blocks()

    Enum.map(unclaimed, fn %{:value => value} = vout ->
      %{:claim => claim, :sys_fee => sys} = compute_vout_bonus(vout, blocks)
      Map.merge(vout, %{
        :unclaimed => claim + sys,
        :generated => claim,
        :sys_fee => sys,
        :value => round(value)
      })
    end)
  end

  # compute bonus for a singel vout
  def compute_vout_bonus(
        %{
          :value => value,
          :start_height => start_height,
          :end_height => end_height
        },
        blocks_with_gas
      ) do
    total_gas =
      Enum.filter(blocks_with_gas, fn %{:index => index} ->
        index >= start_height && index <= end_height
      end)
      |> Enum.reduce(%{:claimable => 0, :sys_fee => 0}, fn %{:index => index, :claim => claim, :sys => sys}, acc ->
           cond do
             index == start_height ->
               %{:claimable => acc.claimable, :sys_fee => sys + acc.sys_fee}
             index == end_height ->
               %{:claimable => claim + acc.claimable, :sys_fee => sys}
             true ->
               %{:claimable => claim + acc.claimable, :sys_fee => sys + acc.sys_fee}
           end
         end)

    %{:claim => round(value) * total_gas.claimable / total_neo(),
      :sys_fee => round(value) * total_gas.sys_fee / total_neo(),
     }
  end

  # get all unclaimed transaction vouts
  def get_unclaimed_vouts(address_id) do
    query =
      from(
        v in Vout,
        where:
          v.address_id == ^address_id and v.claimed == false and
            v.asset == "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
        select: map(v, [:value, :start_height, :end_height, :n, :txid])
      )

    Repo.all(query)
  end

  def add_end_height(unclaimed_vouts) do
    Enum.map(unclaimed_vouts, fn %{:end_height => height} = vout ->
      Map.put(vout, :end_height, check_end_height(height))
    end)
  end

  def filter_end_height(unclaimed_vouts) do
    Enum.filter(unclaimed_vouts, fn %{:end_height => height} ->
      height != nil
    end)
  end

  # get block range of unclaimed transaction vouts
  def get_unclaimed_block_range(unclaimed_vouts) do
    end_height_list =
      Enum.map(unclaimed_vouts, fn %{:end_height => end_height} ->
        check_end_height(end_height)
      end)

    max =
      end_height_list
      |> Enum.max()

    min =
      Enum.map(unclaimed_vouts, fn %{:start_height => start_height} -> start_height end)
      |> Enum.min()

    {min, max}
  end

  # check end_height and use current height when transaction vout wasn't used
  def check_end_height(nil) do
    {:ok, height} = Api.get_height()
    height
  end

  def check_end_height(number) do
    number
  end

  # get total gas distribution amount for all blocks in a given range tuple
  def get_blocks_gas({min, max}) do
    query =
      from(
        b in Block,
        where: b.index >= ^min and b.index <= ^max,
        select: map(b, [:index, :total_sys_fee])
      )

    Repo.all(query)
    |> Enum.map(fn %{:index => index, :total_sys_fee => sys} ->
      %{:index => index, :claim => BlockGasGeneration.get_amount_generate_in_block(index), :sys => sys}
    end)
  end

  def check_blocks(blocks, {min, max}) do
    count = max - min + 1

    cond do
      Enum.count(blocks) == count ->
        blocks

      true ->
        get_missing_block(blocks, {min, max})
    end
  end

  def repair_blocks() do
    {:ok, index} = Blocks.get_highest_block_in_db()
    range = {0, index}

    blocks_with_gas =
      get_blocks_gas(range)
      |> Enum.sort_by(fn %{:index => index} -> index end)
      |> check_blocks(range)

    case blocks_with_gas do
      false ->
        repair_blocks()

      _ ->
        Logger.info("Blocks Repaired")
        "Ok"
    end
  end

  def verified_blocks(range) do
    blocks_with_gas =
      get_blocks_gas(range)
      |> Enum.sort_by(fn %{:index => index} -> index end)
      |> check_blocks(range)

    case blocks_with_gas do
      false ->
        verified_blocks(range)

      _ ->
        blocks_with_gas
    end
  end

  def get_missing_block(blocks, {min, _max}) do
    blocks
    |> Enum.reduce_while(min, fn %{:index => index}, acc ->
      cond do
        index == acc ->
          {:cont, index + 1}

        true ->
          Logger.info("Block #{acc} missing")
          Repair.get_and_add_missing_block_from_height(acc)
          {:halt, false}
      end
    end)
  end
end
