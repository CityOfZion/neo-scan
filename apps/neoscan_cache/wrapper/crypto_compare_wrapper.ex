defmodule NeoscanCache.CryptoCompareWrapper do
  defdelegate pricemultifull(list1, list2), to: CryptoCompare
  defdelegate histo_day(from, to, opts), to: CryptoCompare
  defdelegate histo_hour(from, to, opts), to: CryptoCompare
  defdelegate histo_minute(from, to, opts), to: CryptoCompare
end
