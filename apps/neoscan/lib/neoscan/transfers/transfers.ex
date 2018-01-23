defmodule Neoscan.Transfers do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Transfers.Transfer
  alias Neoscan.Addresses

  require Logger


  def add_block_transfers({_block, transfers}, time) do

    addresses = get_transfers_addresses(transfers, time)

    {:ok, "Created"}
  end


  def get_transfers_addresses(transfers, time) do
    transfers
    |> Enum.reduce([], fn (%{"address_from" => from, "address_to" => to}, acc) ->  acc ++ [from, to] end)
    |> Addresses.get_transfer_addresses(time)
  end

end
