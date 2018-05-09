defmodule NeoscanNode do
  @moduledoc false
  alias NeoscanNode.Worker

  def get_nodes do
    Worker.get_nodes()
  end

  def get_height do
    Worker.get_height()
  end
end
