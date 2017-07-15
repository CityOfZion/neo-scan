defmodule NEOScanSync do
  defdelegate change_seed(seed), to: NEOScanSync.BlockSync
end
