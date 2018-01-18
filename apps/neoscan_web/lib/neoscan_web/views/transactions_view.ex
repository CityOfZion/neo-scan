defmodule NeoscanWeb.TransactionsView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers

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

      type == "EnrollmentTransaction" ->
        'invocation-transaction'

      type == "PublishTransaction" ->
        'publish-transaction'

      type == "MinerTransaction" ->
        'miner-transaction'
    end
  end

  def get_current_min_qtd(page, type) do
    %{:total_transactions => [filtered_totals, total]} = Api.get_stats()

    total =
      case type do
        nil -> total
        txType -> Map.get(filtered_totals, String.capitalize(txType) <> "Transaction")
      end

    if total == 0 do
      1
    else
      (String.to_integer(page) - 1) * 15 + 1
    end
  end

  def get_current_max_qtd(page, type) do
    %{:total_transactions => [filtered_totals, total]} = Api.get_stats()

    total =
      case type do
        nil -> total
        txType -> Map.get(filtered_totals, String.capitalize(txType) <> "Transaction")
      end

    cond do
      total < 15 ->
        total

      String.to_integer(page) * 15 > total ->
        total

      true ->
        String.to_integer(page) * 15
    end
  end

  def get_previous_page(conn, page, type) do
    int =
      page
      |> String.to_integer()

    num =
      (int - 1)
      |> Integer.to_string()

    if type do
      raw(
        '<a href="#{transactions_path(conn, :filtered_transactions, type, num)}" class="button btn btn-primary"><i class="fa fa-angle-left"></i></a>'
      )
    else
      raw(
        '<a href="#{transactions_path(conn, :go_to_page, num)}" class="button btn btn-primary"><i class="fa fa-angle-left"></i></a>'
      )
    end
  end

  def get_next_page(conn, page, type) do
    int =
      page
      |> String.to_integer()

    num =
      (int + 1)
      |> Integer.to_string()

    if type do
      raw(
        '<a href="#{transactions_path(conn, :filtered_transactions, type, num)}" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
      )
    else
      raw(
        '<a href="#{transactions_path(conn, :go_to_page, num)}" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
      )
    end
  end

  def check_last(page, type) do
    int =
      page
      |> String.to_integer()

    %{:total_transactions => [filtered_totals, total]} = Api.get_stats()

    total =
      case type do
        nil -> total
        txType -> Map.get(filtered_totals, String.capitalize(txType) <> "Transaction")
      end

    if int * 15 < total do
      true
    else
      false
    end
  end

  def get_total(type) do
    %{:total_transactions => [filtered_totals, total]} = Api.get_stats()

    if type do
      Map.get(filtered_totals, String.capitalize(type) <> "Transaction")
    else
      total
    end
  end
end
