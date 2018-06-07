defmodule NeoscanWeb.Helper do
  @moduledoc false

  def parse_hash(string) do
    string
    |> String.upcase()
    |> Base.decode16!()
  end

  def format_blocks(blocks), do: Enum.map(blocks, &format_block/1)

  def format_block(block) do
    %{block | hash: Base.encode16(block.hash)}
  end

  def format_transactions(transactions), do: Enum.map(transactions, &format_transaction/1)

  def format_transaction(transaction) do
    %{transaction | block_hash: Base.encode16(transaction.block_hash)}
  end
end
