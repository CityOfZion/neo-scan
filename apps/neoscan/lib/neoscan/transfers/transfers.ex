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
  def home_transfers, do: paginate_transfers(1)

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
          desc: transfer.block_time
        ],
        limit: 15
      )

    Repo.paginate(transfer_query, page: pag, page_size: 15)
  end

  def get_transaction_transfers(_), do: []
  def get_transactions_transfers(_), do: []
end
