defmodule Neoscan.Blocks do
  @moduledoc """
  The boundary for the Blocks system.
  """

  import Ecto.Query, warn: true
  alias Neoscan.Repo
  alias Neoscan.Block
  require Logger

  @doc """
  Returns the list of blocks in the home page.

  ## Examples

      iex> home_blocks()
      [%Block{}, ...]

  """
  def home_blocks do
    block_query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        limit: 15
      )

    Repo.all(block_query)
  end
end
