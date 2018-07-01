defmodule Neoscan.BlocksCache do
  @moduledoc """
  Provide a cache for the block fees, it uses a binary structure stored in a file for efficiency reason.
  """

  use GenServer
  alias Neoscan.Blocks

  @filename "./block_cache"
  @integer_byte_size 4
  @integer_bit_size 8 * @integer_byte_size
  @nb_cached_blocks 10_000_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    init_file_cache()
    init_ets_table()
    set(:min, nil)
    set(:max, nil)
    {:ok, %{}}
  end

  defp init_file_cache do
    {:ok, file} = :file.open(@filename, [:write])
    total_size = @integer_byte_size * @nb_cached_blocks
    :ok = :file.write(file, <<0::size(total_size)>>)
    :ok = :file.sync(file)
    :ok = :file.close(file)
  end

  defp init_ets_table do
    :ets.new(__MODULE__, [
      :set,
      :named_table,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ])
  end

  defp set_cached_response(min, response) do
    binary = response_to_binary(response)
    {:ok, file} = :file.open(@filename, [:write, :read])
    {:ok, _} = :file.position(file, {:bof, @integer_byte_size * min})
    :ok = :file.write(file, binary)
    :ok = :file.sync(file)
    :ok = :file.close(file)
    Enum.count(response)
  end

  defp response_to_binary(response), do: response_to_binary(response, <<>>)
  defp response_to_binary([], acc), do: acc

  defp response_to_binary([%{total_sys_fee: fee} | t], acc) do
    response_to_binary(t, <<acc::binary, round(fee)::size(@integer_bit_size)>>)
  end

  defp get_cached_response(min, max) do
    {:ok, file} = :file.open(@filename, [:read, :binary])
    {:ok, _} = :file.position(file, {:bof, @integer_byte_size * min})
    {:ok, binary} = :file.read(file, @integer_byte_size * (max - min + 1))
    :ok = :file.close(file)
    binary_to_response(binary, min)
  end

  defp binary_to_response(binary, index), do: binary_to_response(binary, index, [])
  defp binary_to_response(<<>>, _, acc), do: Enum.reverse(acc)

  defp binary_to_response(<<fee::size(@integer_bit_size), rest::binary>>, index, acc) do
    binary_to_response(rest, index + 1, [%{index: index, total_sys_fee: fee * 1.0} | acc])
  end

  defp get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, result}] -> result
      _ -> nil
    end
  end

  defp set(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  def get_total_sys_fee(_, -1), do: []

  def get_total_sys_fee(min, max) do
    cache_min = get(:min)
    cache_max = get(:max)

    {is_cached, new_cache_max} =
      if is_nil(cache_max) or is_nil(cache_min) do
        blocks = Blocks.get_total_sys_fee(min, max)

        if Enum.count(blocks) == max - min + 1 do
          {true, min + set_cached_response(min, blocks) - 1}
        else
          {false, blocks}
        end
      else
        blocks1 = Blocks.get_total_sys_fee(min, cache_min)
        blocks2 = Blocks.get_total_sys_fee(cache_max, max)

        if Enum.count(blocks1) == cache_min - min + 1 and
             Enum.count(blocks2) == max - cache_max + 1 do
          set_cached_response(min, blocks1)
          {true, cache_max + set_cached_response(cache_max, blocks2) - 1}
        else
          {false, Blocks.get_total_sys_fee(min, max)}
        end
      end

    if is_cached do
      # it is possible override will occur here, for example another process stores a smaller value of min
      # or a higher value of max, however if data is queried again, it is not a serious problem, it would be better
      # to update it atomically if and only if the value is lower or higher. But there is no easy way to do it wiht ets
      new_cache_min = if min < cache_min, do: min, else: cache_min
      set(:min, new_cache_min)

      # current logic check the highest block so max can be ahead of the current database state, we need to put max to the
      # real block number in the database
      set(:max, new_cache_max)

      real_max = if new_cache_max > max, do: max, else: new_cache_max

      get_cached_response(min, real_max)
    else
      new_cache_max
    end
  end

  def get_sys_fees_in_range(min, max) do
    result = get_total_sys_fee(min, max)

    result
    |> Enum.map(& &1.total_sys_fee)
    |> Enum.sum()
  end
end
