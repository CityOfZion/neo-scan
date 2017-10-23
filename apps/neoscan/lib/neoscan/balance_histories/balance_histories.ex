defmodule Neoscan.BalanceHistories do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.BalanceHistories.History
  alias Neoscan.Transactions
  alias Neoscan.Transactions.Transaction

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address history changes.

  ## Examples

      iex> change_history(history)
      %Ecto.Changeset{source: %History{}}

  """
  def change_history(%History{} = history, address, attrs) do
    History.changeset(history, address, attrs)
  end

  #add a transaction history into an address
  def add_tx_id(address, txid, index, time) do
    new_tx = %{
      :txid => txid,
      :balance => address.balance,
      :block_height => index,
      :time => time
    }
    %{address | tx_ids: new_tx}
  end

  @doc """
  Count total history points for an address.

  ## Examples

      iex> count_histories_for_Address(address_hash)
      50

  """
  def count_hist_for_address(address_hash) do
    query = from h in History,
             where: h.address_hash == ^address_hash
    Repo.aggregate(query, :count, :id)
  end

  def paginate_history_transactions(histories, pag) do

    lookups = Enum.map(histories, fn %{:txid => txid} -> txid end)

    transaction_query = from e in Transaction,
                        order_by: [
                          desc: e.block_height
                        ],
                        where: e.txid in ^lookups,
                        select: %{
                         :id => e.id,
                         :type => e.type,
                         :time => e.time,
                         :txid => e.txid,
                         :block_height => e.block_height,
                         :block_hash => e.block_hash,
                         :vin => e.vin,
                         :claims => e.claims,
                         :sys_fee => e.sys_fee,
                         :net_fee => e.net_fee,
                         :size => e.size,
                        },
                        limit: 15

    transactions = Repo.paginate(transaction_query, page: pag, page_size: 15)
    vouts = Enum.map(transactions, fn tx -> tx.id end)
              |> Transactions.get_transactions_vouts

    transactions
    |> Enum.map(fn tx ->
         Map.put(tx, :vouts, Enum.filter(vouts, fn vout ->
           vout.transaction_id == tx.id
         end))
       end)
  end

end
