defmodule NeoscanWeb.Resolvers.Block do
  @moduledoc false
  alias Neoscan.Blocks

  @default_paginator %{page_size: 20, page: 1}

  def all(_, params, _) do
    %{page_size: page_size, page: page} = Map.get(params, :paginator, @default_paginator)

    all = Blocks.paginate(page, page_size)

    resp = %{
      block_rows: all.entries,
      pagination: %{
        page: all.page_number,
        page_size: all.page_size,
        total_count: all.total_entries,
        total_pages: all.total_pages
      }
    }

    {:ok, resp}
  end

  def get(_, %{params: %{hash: hash}}, _) do
    hash = Base.decode16!(hash, case: :mixed)
    block = Blocks.get(hash)
    if is_nil(block), do: {:error, "block not found"}, else: {:ok, block}
  end

  def get(_, %{params: %{index: index}}, _) do
    block = Blocks.get(index)
    if is_nil(block), do: {:error, "block not found"}, else: {:ok, block}
  end

  def get(_, _, _), do: {:error, "missing search parameter index or hash"}
end
