defmodule NeoscanCache.Api do
  @moduledoc """
  Interface between server and worker to communicate with external modules
  """
  alias NeoscanCache.Cache

  def get_blocks do
    Cache.get(:blocks)
  end

  def get_transactions do
    Cache.get(:transactions)
  end

  def get_price do
    Cache.get(:price)
  end

  def get_stats do
    Cache.get(:stats)
  end
end
