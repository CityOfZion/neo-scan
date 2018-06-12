defmodule Neoscan.Transfers do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Transfer

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
          desc: transfer.block_time
        ],
        limit: 15
      )

    Repo.all(transfer_query)
  end
end
