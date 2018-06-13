defmodule NeoscanWeb.HomeController do
  @moduledoc false
  use NeoscanWeb, :controller

  alias Neoscan.Blocks
  alias Neoscan.Block
  alias Neoscan.Address
  alias Neoscan.Transaction
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
    result =
      case Integer.parse(value) do
        {integer, ""} ->
          Blocks.get_block_by_height(integer)

        _ ->
          Blocks.get_block_by_hash(safe_decode_16(value)) ||
            Transactions.get_transaction_by_hash(safe_decode_16(value)) ||
            Addresses.get_address_by_hash(safe_decode_58(value))
      end

    redirect_search_result(conn, result)
  end

  def safe_decode_16(value) do
    case Base.decode16(value) do
      :error ->
        <<0>>

      {:ok, value} ->
        value
    end
  end

  def safe_decode_58(value) do
    try do
      Base58.decode(value)
    rescue
      _ -> <<0>>
    catch
      _ -> <<0>>
    end
  end

  # redirect search results to correct page
  def redirect_search_result(conn, nil) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end

  def redirect_search_result(conn, %Block{hash: hash}) do
    redirect(conn, to: block_path(conn, :index, Base.encode16(hash)))
  end

  def redirect_search_result(conn, %Transaction{hash: hash}) do
    redirect(conn, to: transaction_path(conn, :index, Base.encode16(hash)))
  end

  def redirect_search_result(conn, %Address{hash: hash}) do
    redirect(conn, to: address_path(conn, :index, Base58.encode(hash)))
  end
end
