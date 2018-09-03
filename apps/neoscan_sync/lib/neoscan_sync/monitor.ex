defmodule Monitor do
  @moduledoc """
  This module is used to monitor the state of the messenger (how many message
  sent), etc...
  """
  use Buffer.Write.Count, interval: 5_000
  require Logger

  @parallelism 16

  @spec write(list(term)) :: :ok
  def write(counter_list) do
    display_stats(counter_list)
    :ok
  end

  defp display_stats(counters) when length(counters) == 5 do
    download_block_avg_time = counters[:download_blocks_time] / counters[:download_blocks_count]
    insert_block_avg_time = counters[:insert_blocks_time] / counters[:insert_blocks_count]
    insert_block_rate = counters[:insert_blocks_count] / 5
    insert_transaction_rate = counters[:insert_transactions_count] / 5

    ratio_insert =
      round(counters[:insert_blocks_time] * 100 / 5_000_000 / System.schedulers_online())

    ratio_download =
      round(
        counters[:download_blocks_time] * 100 / 5_000_000 /
          (System.schedulers_online() * @parallelism)
      )

    Logger.info(
      "#{insert_block_rate} blocks/s, #{insert_transaction_rate} transactions/s, #{
        download_block_avg_time
      } download avg time, #{insert_block_avg_time} insert avg time"
    )

    Logger.info("#{ratio_insert} ratio_insert, #{ratio_download} ratio_download")
  end

  defp display_stats(_), do: nil
end
