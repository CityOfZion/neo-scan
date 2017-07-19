defmodule NEOScanSync.AddressSync do
  @moduledoc """

    External process to sync address and transactions in the database

  """
  alias Neoscan.Blocks
  alias Neoscan.Address
  alias Neoscan.Repo

  @me __MODULE__

  #Starts the application
  def start_link() do
    Agent.start_link(fn -> start() end , name: @me)
  end

  #check if main endpoint is alive, otherwise shutdown process
  def start() do
    monitor()
    receive do
      {:id , id} -> block_worker(id)
    end
  end

  defp monitor() do
    alive = Process.whereis(Neoscan.Supervisor)
    |> Process.alive?
    case alive do
      true ->
        monitor()
      false ->
        Process.exit(self(), :shutdown)
    end
  end

  defp block_worker(id) do
    block = Blocks.get_block!(id)
    |> Repo.preload(:transactions)
    for transaction <- block.transactions do
      cond do
        Kernel.length(transaction.vout) != 0 ->
          save_outputs(transaction.id, transaction.vouts)
        true ->
          {:ok , "No Outputs"}
      end
    end
  end

  defp save_outputs(transaction_id, [h | t]), do: [save_output(transaction_id, h) | save_outputs(transaction_id, t)]
  defp save_outputs(_, []), do: {:ok, "Saved"}

  defp save_output(transaction_id, vout) do
    address_worker(transaction_id, vout)
  end

  defp address_worker(transaction_id, %{"address" => address} = vout) do
    case Address.create_or_update(address , transaction_id, vout) do
      {:ok, "done"} ->
        {:ok, "done"}
      {:error, reason} ->
        IO.inspect(reason)
        Process.exit(self(), :error)
    end
  end

end
