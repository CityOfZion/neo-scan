defmodule NeoscanWeb.BlocksView do
  use NeoscanWeb, :view
  import Number.Delimit
  import NeoscanWeb.CommonView

  def get_block_time(block, blocks) do
    previous_block = Enum.find(blocks, fn %{:index => index} -> index == block.index - 1 end)

    if is_nil(previous_block) do
      "not data"
    else
      "#{DateTime.diff(block.time, previous_block.time)} seconds"
    end
  end
end
