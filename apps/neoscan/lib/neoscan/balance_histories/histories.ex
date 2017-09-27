defmodule Neoscan.BalanceHistories do
  import Ecto.Query, warn: false
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




end
