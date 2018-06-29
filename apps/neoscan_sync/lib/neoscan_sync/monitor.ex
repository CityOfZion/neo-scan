defmodule Monitor do
  @moduledoc """
  This module is used to monitor the state of the messenger (how many message
  sent), etc...
  """
  use Buffer.Write.Count, interval: 5_000
  require Logger

  @spec write(list(term)) :: :ok
  def write(counter_list) do
    display_stats(counter_list)
    :ok
  end

  defp display_stats(
         download_blocks_count: download_blocks_count,
         download_blocks_time: download_blocks_time,
         insert_blocks_time: insert_blocks_time,
         insert_blocks_count: insert_blocks_count
       ) do
    download_block_avg_time = download_blocks_time / download_blocks_count
    insert_block_avg_time = insert_blocks_time / insert_blocks_count
    insert_block_rate = insert_blocks_count / 5

    Logger.info(
      "#{insert_block_rate} blocks/s, #{download_block_avg_time} download avg time, #{
        insert_block_avg_time
      } insert avg time"
    )
  end

  defp display_stats(_), do: nil
end
