defmodule NeoscanWeb.Helper do
  def safe_decode_16(value) do
    case Base.decode16(value, case: :mixed) do
      :error ->
        <<0>>

      {:ok, value} ->
        value
    end
  end

  def safe_decode_58(value) do
    try do
      Base58.decode(value)
      # {:ok, value} = Base.decode64(value, padding: false)
    rescue
      _ -> <<0>>
    catch
      _ -> <<0>>
    end
  end

  def render_transactions(transactions) do
    Enum.map(transactions, &render_transaction/1)
  end

  def render_transaction(transaction) do
    transfer_from =
      Enum.map(
        transaction.transfers,
        &%{address_hash: &1.address_from, asset: &1.asset, value: &1.amount}
      )

    transfer_to =
      Enum.map(
        transaction.transfers,
        &%{address_hash: &1.address_to, asset: &1.asset, value: &1.amount}
      )

    transfer_from_minted = Enum.filter(transfer_from, &(&1.address_hash == <<0>>))
    transfer_from_non_minted = Enum.filter(transfer_from, &(&1.address_hash != <<0>>))

    transfer_from_minted =
      transfer_from_minted
      |> Enum.group_by(& &1.asset, & &1.value)
      |> Enum.map(fn {asset, values} ->
        %{address_hash: <<0>>, asset: asset, value: Enum.reduce(values, 0, &Decimal.add/2)}
      end)

    registered =
      if transaction.type == "register_transaction" do
        [
          %{
            address_hash: transaction.asset.admin,
            value: transaction.asset.amount,
            asset: transaction.asset
          }
        ]
      else
        []
      end

    transaction
    |> Map.put(:sent_from, transaction.vins ++ transfer_from_non_minted)
    |> Map.put(:minted, transfer_from_minted)
    |> Map.put(:claimed, transaction.claims)
    |> Map.put(:sent_to, transaction.vouts ++ transfer_to)
    |> Map.put(:registered, registered)
  end
end
