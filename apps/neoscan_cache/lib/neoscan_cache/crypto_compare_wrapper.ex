defmodule NeoscanCache.CryptoCompareWrapper do
  def pricemultifull(list1, list2) do
    CryptoCompare.pricemultifull(list1, list2)
  end

  def histo_day(from, to, opts), do: CryptoCompare.histo_day(from, to, opts)
  def histo_hour(from, to, opts), do: CryptoCompare.histo_hour(from, to, opts)
  def histo_minute(from, to, opts), do: CryptoCompare.histo_minute(from, to, opts)
end
