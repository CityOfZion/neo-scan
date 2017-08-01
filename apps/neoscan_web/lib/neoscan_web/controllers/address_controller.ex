defmodule NeoscanWeb.AddressController do
  use NeoscanWeb, :controller

  alias Neoscan.Addresses

  def show_address(conn, %{"address" => address_hash}) do
    address = Addresses.get_address_by_hash_for_view(address_hash)
    render(conn, "address.html", address: address)
  end

  def round_or_not(value) do
    cond do
      Kernel.round(value) == value ->
        Kernel.round(value)
      Kernel.round(value) != value ->
        value
    end
  end

  def get_amount_claimed(claimed_map, tx) do
    %{"amount" => amount, "asset" => asset} = Enum.find(claimed_map, fn %{"txid" => txid} -> txid == tx end)
    "#{amount} #{Neoscan.Transactions.get_asset_name_by_hash(asset)}"
  end


end
