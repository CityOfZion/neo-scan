defmodule NeoscanSync.TokenSyncer do
  alias Neoscan.Repo
  alias NeoscanNode.Notifications
  alias Neoscan.Asset

  use GenServer

  require Logger

  @update_interval 30_000

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Process.send_after(self(), :sync, 0)
    {:ok, nil}
  end

  @impl true
  def handle_info(:sync, state) do
    Process.send_after(self(), :sync, @update_interval)
    sync_tokens()
    {:noreply, state}
  end

  def sync_tokens do
    tokens = Notifications.get_token_notifications()
    tokens = Enum.map(tokens, &convert_token_to_asset/1)
    Repo.insert_all(Asset, tokens, on_conflict: :nothing)
  end

  def convert_token_to_asset(token) do
    %{
      admin: <<0>>,
      amount: 0.0,
      name: [%{"lang" => "en", "name" => token.token.name}],
      owner: <<0>>,
      precision: token.token.decimals,
      type: "NEP5",
      issued: 0.0,
      block_time: DateTime.utc_now(),
      contract: <<0>>,
      transaction_hash: token.contract.hash,
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }
  end
end
