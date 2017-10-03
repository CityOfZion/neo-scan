defmodule Neoscan.BalanceHistories do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.BalanceHistories.History

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
  def count_histories_for_address(address_hash) do
    query = from h in History,
             where: h.address_hash == ^address_hash
    Repo.aggregate(query, :count, :id)
  end

end
