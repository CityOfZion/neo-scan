defmodule NeoscanWeb.TransactionsView do
  use NeoscanWeb, :view
  alias Neoscan.Transactions

  def get_class(type) do
    cond do
      type == "ContractTransaction" ->
        'neo-transaction'
      type == "ClaimTransaction" ->
        'gas-transaction'
      type == "IssueTransaction" ->
        'issue-transaction'
      type == "RegisterTransaction" ->
        'register-transaction'
      type == "InvocationTransaction" ->
        'invocation-transaction'
      type == "PublishTransaction" ->
        'publish-transaction'
    end
  end

  def get_transaction_vouts(id, vouts) do
    Enum.filter(vouts, fn vout -> vout.transaction_id == id end)
  end
end
