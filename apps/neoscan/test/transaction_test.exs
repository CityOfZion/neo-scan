defmodule Neoscan.TransactionTest do
  use Neoscan.DataCase
  import Neoscan.Factory
  #  alias Neoscan.Block

  test "create transaction" do
    _transaction = insert(:transaction)
  end
end
