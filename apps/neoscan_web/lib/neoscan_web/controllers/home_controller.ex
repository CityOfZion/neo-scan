defmodule NeoscanWeb.HomeController do
  @moduledoc false
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Transactions
  alias Neoscan.Addresses

  # load last blocks and transactions from db
  def index(conn, _params) do
    render(conn, "index.html")
  end

  # searches the database for the input value
  def search(conn, %{
        "search" => %{
          "for" => value
        }
      }) do
    value = String.slice(value, -64..-1)

    result =
      try do
        String.to_integer(value)
      rescue
        ArgumentError ->
          Blocks.get_block_by_hash(value) || Transactions.get_transaction_by_hash(value) ||
            Addresses.get_address_by_hash(value)
      else
        value ->
          Blocks.get_block_by_height(value)
      end

    redirect_search_result(conn, result)
  end

  # redirect search results to correct page
  def redirect_search_result(conn, result) do
    cond do
      nil == result ->
        no_result(conn, [])

      Map.has_key?(result, :hash) ->
        redirect(conn, to: block_path(conn, :index, result.hash))

      Map.has_key?(result, :txid) ->
        redirect(conn, to: transaction_path(conn, :index, result.txid))

      Map.has_key?(result, :address) ->
        redirect(conn, to: address_path(conn, :index, result.address))
    end
  end

  def no_result(conn, _params) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
end
