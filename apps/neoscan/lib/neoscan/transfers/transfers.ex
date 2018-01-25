defmodule Neoscan.Transfers do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Transfers.Transfer
  alias Neoscan.Addresses

  require Logger


  @doc """
  Creates a transfer

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(transfer, time, block) do
    attrs = transfer
            |> Map.merge(%{
                            "txid" => transfer["tx"],
                            "block_height" => transfer["block"],
                            "address_from" => transfer["addr_from"],
                            "address_to" => transfer["addr_to"],
                            "time" => time,
                          })

    Transfer.changeset(block, attrs)
    |> Repo.insert!()
  end


  def add_block_transfers({_block, []}, _time) do
    {:ok, "all operations were succesfull"}
  end
  def add_block_transfers({block, transfers}, time) do
    get_transfers_addresses(transfers, time)
    |> Addresses.update_all_addresses(transfers, time, block)
    |> Addresses.update_multiple_addresses()
  end


  def get_transfers_addresses(transfers, time) do
    transfers
    |> Enum.reduce([], fn (%{"address_from" => from, "address_to" => to}, acc) ->  acc ++ [from, to] end)
    |> Addresses.get_transfer_addresses(time)
  end

end
