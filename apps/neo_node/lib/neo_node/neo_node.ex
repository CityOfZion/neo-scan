defmodule NeoNode do
  @moduledoc """
  The boundary for the Blockchain requests.
  """

  require Logger
  alias NeoNode.Parser
  alias NeoNode.HTTPPoisonWrapper

  @timeout 2_000

  @opts [ssl: [{:versions, [:"tlsv1.2"]}], timeout: @timeout, recv_timeout: @timeout]
  @headers [{"Content-Type", "application/json"}, {"Accept-Encoding", "gzip"}]

  @gzip_header {"Content-Encoding", "gzip"}
  @xgzip_header {"Content-Encoding", "x-gzip"}

  @doc """
   Get the current block by height through seed 'index'
  """

  def get_block_by_height(url, height) do
    case post(url, "getblock", [height, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_block_by_hash(url, hash) do
    case post(url, "getblock", [hash, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_block(response)}

      error ->
        error
    end
  end

  def get_application_log(url, hash) do
    case post(url, "getapplicationlog", [hash]) do
      {:ok, response} ->
        {:ok, Parser.parse_application_log(response)}

      {:error, %{"code" => -2_146_233_033}} ->
        {:error, :invalid_format}
 
      {:error, %{"code" => -32602}} ->
        {:error, :invalid_format}

      error ->
        error
    end
  end

  def get_version(url, timeout \\ @timeout) do
    opts = [ssl: [{:versions, [:"tlsv1.2"]}], timeout: timeout, recv_timeout: timeout]

    case post(url, "getversion", [], opts) do
      {:ok, response} ->
        {:ok, Parser.parse_version(response)}

      error ->
        error
    end
  end

  def get_block_count(url), do: post(url, "getblockcount", [])

  def get_transaction(url, txid) do
    case post(url, "getrawtransaction", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_transaction(response)}

      error ->
        error
    end
  end

  def get_asset(url, txid) do
    case post(url, "getassetstate", [txid, 1]) do
      {:ok, response} ->
        {:ok, Parser.parse_asset(response)}

      error ->
        error
    end
  end

  def get_contract(url, hash) do
    case post(url, "getcontractstate", [hash]) do
      {:ok, response} ->
        {:ok, Parser.parse_contract(response)}

      error ->
        error
    end
  end

  def invoke_contract_function(url, hash, function, params) do
    case post(url, "invokefunction", [hash, function, params]) do
      {:ok, response} ->
        {:ok, Parser.parse_invoke(response)}

      error ->
        error
    end
  end

  def get_nep5_contract(url, hash) do
    with {:ok, [name]} <- invoke_contract_function(url, hash, "name", []),
         {:ok, [symbol]} <- invoke_contract_function(url, hash, "symbol", []),
         {:ok, [decimals]} <- invoke_contract_function(url, hash, "decimals", []) do
      {:ok,
       %{
         name: name,
         symbol: symbol,
         decimals: if(is_integer(decimals), do: decimals, else: 0),
         hash: hash
       }}
    else
      _ ->
        {:error, :no_contract}
    end
  end

  def post(url, method, params, opts \\ @opts) do
    data =
      Poison.encode!(%{
        "jsonrpc" => "2.0",
        "method" => method,
        "params" => params,
        "id" => 5
      })

    result = HTTPPoisonWrapper.post(url, data, @headers, opts)
    handle_response(result, url)
  end

  defp has_gzip_headers?(headers), do: @gzip_header in headers or @xgzip_header in headers

  # Handles the response of an HTTP call
  defp handle_response(
         {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}},
         _
       ) do
    body
    |> (&if(has_gzip_headers?(headers), do: :zlib.gunzip(&1), else: &1)).()
    |> Poison.decode()
    |> handle_body()
  end

  defp handle_response({_, result}, url) do
    message = "#{inspect(result)} #{url}"
    Logger.debug(message)
    {:error, message}
  end

  # handles a sucessful response
  defp handle_body({:ok, %{"result" => result}}), do: {:ok, result}
  defp handle_body({:ok, %{"error" => error}}), do: {:error, error}
  defp handle_body(error), do: {:error, "body error: #{inspect(error)}"}
end
