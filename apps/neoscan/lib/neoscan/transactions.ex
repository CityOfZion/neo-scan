defmodule Neoscan.Transactions do
  @moduledoc false

  @moduledoc """
  The boundary for the Transactions system.
  """

  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Transaction

  @doc """
  Returns the list of transactions in the home page.

  ## Examples

      iex> home_transactions()
      [%Transaction{}, ...]

  """
  def home_transactions do
    transaction_query =
      from(
        e in Transaction,
        order_by: [
          desc: e.block_time
        ],
        where: e.type != "miner_transaction",
        limit: 15,
        preload: [:vouts]
      )

    Repo.all(transaction_query)
  end
end
