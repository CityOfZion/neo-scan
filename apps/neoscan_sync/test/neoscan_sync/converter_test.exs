defmodule NeoscanSync.ConverterTest do
  use NeoscanSync.DataCase

  alias NeoscanSync.Converter

  test "get_transaction_hash/2" do
    assert <<1>> ==
             Converter.get_transaction_hash(%{type: :miner_transaction, hash: <<0>>}, %{
               index: 2_000_357
             })
  end
end
