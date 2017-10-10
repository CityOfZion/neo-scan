defmodule Neoprice.Cryptocompare.Socket do
  @moduledoc "socket part of the Cryptocompare api"
  # @exchange CCCAGG
  require Logger
  use GenServer
  @url "streamer.cryptocompare.com"
  @web_path "/socket.io/?EIO=3&transport=polling"
  @socket_path "/socket.io/?EIO=3&transport=websocket&t=Ly6bPsZ"
  @keep_alive_interval 25_000

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    sid = get_sid()
    path = @socket_path <> "&sid=#{sid}"
    {:ok, socket} = Socket.Web.connect(@url, secure: true, path: path)
    state = %{
      last_message_at: DateTime.utc_now(),
      socket: socket
    }
    Process.send_after(self(), :keep_alive, 1_000)
    Process.send_after(self(), :sync, 10)
    {:ok, state}
  end

  def handle_info(:sync, state), do: {:noreply, sync(state)}

  def handle_info(:keep_alive, state) do
    Process.send_after(self(), :keep_alive, 1_000)
    state = if DateTime.diff(
                 DateTime.utc_now(),
                 state.last_message_at,
                 :millisecond
               ) > @keep_alive_interval do
      keep_alive(state)
    else
      state
    end
    {:noreply, state}
  end

  def handle_call({:send_message, message}, _, state) do
    resp = send_message(state.socket, message)
    {:reply, resp, update_last_message(state)}
  end

  def handle_call({:send_json_message, message}, _, state) do
    resp = send_json_message(state.socket, message)
    {:reply, resp, update_last_message(state)}
  end

  def handle_call({:send_event, event, message}, _, state) do
    resp = send_event(state.socket, event, message)
    {:reply, resp, update_last_message(state)}
  end

  def recieve(state = %{socket: socket}) do
    {:text, text} = case Socket.Web.recv(socket, timeout: 200) do
      {:ok, tuple} -> tuple
      {:error, :timeout} ->
        {:text, ""}
      error ->
        Logger.warn fn ->
          "#{inspect(error)}"
        end
        {:text, ""}
    end
    case decode_socket(text) do
      {:config, %{"sid" => sid}} ->
        socket = %{socket | path: socket.path <> "&sid=" <> sid}
        %{state | socket: socket}
      nil -> state
      _ -> state
    end
  end

  def message(message) do
    GenServer.call(__MODULE__, {:send_message, message})
  end

  def json_message(message) do
    GenServer.call(__MODULE__, {:send_json_message, message})
  end

  def event(event, message) do
    GenServer.call(__MODULE__, {:send_event, event, message})
  end

  defp get_sid() do
    %HTTPoison.Response{body: "97:0" <> resp} = HTTPoison.get!(
      "https://" <> @url <> @web_path
    )
    {resp, _} = String.split_at(resp, -4)
    IO.inspect(resp)
    Poison.decode!(resp)
    |> Map.get("sid")
  end

  defp sync(state) do
    Process.send(self(), :sync, [])
    recieve(state)
  end

  defp keep_alive(state) do
    Logger.info("keep alive")
    send_heartbeat(state.socket)
    update_last_message(state)
  end

  defp send_heartbeat(socket) do
    Socket.Web.send!(socket, {:text, "2::"})
  end

  defp send_message(socket, string) do
    Socket.Web.send!(socket, {:text, "3::#{string}"})
  end

  defp send_json_message(socket, map) do
    string = Poison.encode!(map)
    Socket.Web.send!(socket, {:text, "4::#{string}"})
  end

  defp send_event(socket, event, map) do
    string = Poison.encode!([event, map])
    Socket.Web.send!(socket, {:text, "5::#{string}"})
  end

  defp update_last_message(state) do
    %{state | last_message_at: DateTime.utc_now()}
  end

  defp decode_socket("0" <> text) do
    {:config, Poison.decode!(text)}
  end

  defp decode_socket("40"), do: nil
  defp decode_socket("3"), do: :pong
  defp decode_socket(""), do: nil
  defp decode_socket(other) do
    Logger.warn(other)
  end
end
