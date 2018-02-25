defmodule Neoscan.Transfers do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Transfers.Transfer
  alias Neoscan.Addresses
  alias Neoscan.Stats
  alias NeoscanMonitor.Api

  require Logger

  @doc """
  Returns the list of transfers in the home page.

  ## Examples

      iex> home_transfers()
      [%Transfer{}, ...]

  """
  def home_transfers do
    transfer_query =
      from(
        transfer in Transfer,
        order_by: [
          desc: transfer.id
        ],
        select: %{
          :id => transfer.id,
          :address_from => transfer.address_from,
          :address_to => transfer.address_to,
          :amount => transfer.amount,
          :block_height => transfer.block_height,
          :txid => transfer.txid,
          :contract => transfer.contract,
          :time => transfer.time
        },
        limit: 15
      )

    Repo.all(transfer_query)
  end

  @doc """
  Returns the list of paginated transfers.

  ## Examples

      iex> paginate_transfers(page)
      [%Transfer{}, ...]

  """
  def paginate_transfers(pag) do
    transfer_query =
      from(
        transfer in Transfer,
        order_by: [
          desc: transfer.id
        ],
        select: %{
          :id => transfer.id,
          :address_from => transfer.address_from,
          :address_to => transfer.address_to,
          :amount => transfer.amount,
          :block_height => transfer.block_height,
          :txid => transfer.txid,
          :contract => transfer.contract,
          :time => transfer.time
        },
        limit: 15
      )

    Repo.paginate(transfer_query, page: pag, page_size: 15)
  end

  @doc """
  Creates a transfer

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(transfer, time, block) do
    attrs =
      transfer
      |> Map.merge(%{
        "txid" => String.slice(to_string(transfer["tx"]), -64..-1),
        "block_height" => transfer["block"],
        "address_from" => transfer["addr_from"],
        "address_to" => transfer["addr_to"],
        "time" => time,
        "contract" => String.slice(to_string(transfer["contract"]), -40..-1),
      })

    Transfer.changeset(block, attrs)
    |> Repo.insert!()
    |> update_transfer_state
  end

  def update_transfer_state(transfer) do
    Api.add_transfer(transfer)
    Stats.add_transfer_to_table(transfer)
    transfer
  end

  @doc """
  Count total transfers in DB.

  ## Examples

      iex> count_transfers()
      50

  """
  def count_transfers do
    Repo.aggregate(Transfer, :count, :id)
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
    |> Enum.reduce([], fn %{"addr_from" => from, "addr_to" => to}, acc ->
      acc ++ [from, to]
    end)
    |> Enum.uniq
    |> Addresses.get_transfer_addresses(time)
  end
end
