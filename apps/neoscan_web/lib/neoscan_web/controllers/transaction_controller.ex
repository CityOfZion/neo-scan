defmodule NeoscanWeb.TransactionController do
  use NeoscanWeb, :controller

  alias Neoscan.Transactions

  def index(conn, %{"txid" => transaction_hash}) do
    tran = Transactions.get_transaction_by_hash_for_view(transaction_hash)

    new_vin = clean_list(tran.vin)

    new_claim = clean_list(tran.claims)

    new_asset = clean_map(tran.asset)

    Map.merge(tran, %{
      :vin => new_vin,
      :claims => new_claim,
      :asset => new_asset,
      })
    |> route(conn)
  end

  def route(nil, conn) do
    conn
    |> put_flash(:info, "Not Found in DB!")
    |> redirect(to: home_path(conn, :index))
  end
  def route(transaction, conn) do
    render(conn, "transaction.html", transaction: transaction)
  end

  defp clean_list(nil) do
    nil
  end
  defp clean_list(list) do
    Enum.map(list, fn l ->
      {:ok, new_l} = Morphix.atomorphiform(l)
      new_l
    end)
  end

  defp clean_map(nil) do
    nil
  end
  defp clean_map(map) do
    {:ok, new_map} = Morphix.atomorphiform(map)
    new_map
  end

  def round_or_not(value) do
    float = case Kernel.is_float(value) do
      true ->
        value
      false ->
        case Kernel.is_integer(value) do
          true ->
            value
          false ->
            {num, _} = Float.parse(value)
            num
        end
    end
    if Kernel.round(float) == float do
      Kernel.round(float)
    else
      value
    end
  end
end
