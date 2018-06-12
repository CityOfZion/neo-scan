defmodule Neoscan.Addresses do
  @moduledoc """
  The boundary for the Addresses system.
  """

  import Ecto.Query, warn: false

  require Logger

  alias Neoscan.Repo
  alias Neoscan.Address

  @doc """
  Returns a list of the latest updated addresses.

  ## Examples

      iex> list_latest()
      [%Address{}, ...]

  """
  def list_latest do
    query =
      from(
        a in Address,
        order_by: [
          desc: a.last_transaction_time
        ],
        limit: 15
      )

    Repo.all(query)
  end
end
