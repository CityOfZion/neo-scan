defmodule NeoscanWeb.BlocksView do
  use NeoscanWeb, :view
  import Number.Delimit

  def get_current_min_qtd(_page, total) when total < 15, do: 0
  def get_current_min_qtd(page, _total), do: (page - 1) * 15 + 1

  def get_current_max_qtd(_page, total) when total < 15, do: total
  def get_current_max_qtd(page, total) when page * 15 > total, do: total
  def get_current_max_qtd(page, _total), do: page * 15

  def check_last(page, total), do: page * 15 < total

  def get_block_time(block, blocks) do
    previous_block = Enum.find(blocks, fn %{:index => index} -> index == block.index - 1 end)

    if is_nil(previous_block) do
      "not data"
    else
      "#{DateTime.diff(block.time, previous_block.time)} seconds"
    end
  end
end
