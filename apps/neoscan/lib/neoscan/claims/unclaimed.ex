defmodule Neoscan.Claims.Unclaimed do
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Vouts.Vout
  alias NeoscanMonitor.Api
  alias Neoscan.Blocks.Block



  #get all unclaimed transaction vouts
  def get_unclaimed_vouts(address_id) do
    query= from v in Vout,
     where: v.address_id == ^address_id and v.claimed == false and v.asset == "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
     select: map(v, [:value, :start_height, :end_height])

    Repo.all(query)
  end

  #get block range of unclaimed transaction vouts
  def get_unclaimed_block_range(unclaimed_vouts) do
    end_height_list = Enum.map(unclaimed_vouts, fn %{:end_height => end_height} -> end_height end)

    max = end_height_list
          |> Enum.member?(nil)
          |> check_end_height(end_height_list)

    min = Enum.map(unclaimed_vouts, fn %{:start_height => start_height} -> start_height end)
          |> Enum.min

    {min, max}
  end

  #check end_height and use current height when transaction vout wasn't used
  def check_end_height(true, _list) do
    Api.get_height
  end
  def check_end_height(false, list) do
    Enum.max(list)
  end

  #get total gas distribution amount for all blocks in a given range tuple 
  def get_blocks_gas({min,max}) do
    query = from b in Block,
     where: b.index >= ^min and b.index <= ^max,
     select: map(b, [:index, :total_sys_fee, :total_net_fee, :gas_generated])

    Repo.all(query)
    |> Enum.map(fn %{:index => index, :total_sys_fee => sys, :total_net_fee => net, :gas_generated => gen} -> %{:index => index, :gas => sys+net+gen} end)
  end


end
