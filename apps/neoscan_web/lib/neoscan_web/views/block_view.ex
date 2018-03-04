defmodule NeoscanWeb.BlockView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias Neoscan.Vm.Disassembler
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers
  alias Neoscan.Explanations
  alias NeoscanWeb.ViewHelper

  def compare_time_and_get_minutes(unix_time) do
    ViewHelper.compare_time_and_get_minutes(unix_time)
  end

  def check_if_invocation({"invocation", _hash}) do
    true
  end

  def check_if_invocation({"verification", _hash}) do
    false
  end

  def check_if_invocation(nil) do
    true
  end

  def check_if_verification({"verification", _hash}) do
    true
  end

  def check_if_verification({"invocation", _hash}) do
    false
  end

  def check_if_verification(nil) do
    true
  end

  def parse_invocation(nil) do
    "No Invocation Script"
  end

  def parse_invocation({"invocation", inv}) do
    Disassembler.parse_script(inv)
  end

  def parse_verification(nil) do
    "No Verification Script"
  end

  def parse_verification({"verification", ver}) do
    Disassembler.parse_script(ver)
  end

  def get_inv(nil) do
    "No Invocation Script"
  end

  def get_inv({"invocation", inv}) do
    inv
  end

  def get_ver(nil) do
    "No Verification Script"
  end

  def get_ver({"verification", ver}) do
    ver
  end

  def get_current_min_qtd(page, total) do
    if total < 15 do
      1
    else
      (String.to_integer(page) - 1) * 15 + 1
    end
  end

  def get_current_max_qtd(page, total) do
    cond do
      total < 15 -> total
      String.to_integer(page) * 15 > total -> total
      true -> String.to_integer(page) * 15
    end
  end

  def get_previous_page(conn, hash, page) do
    int =
      page
      |> String.to_integer()

    num =
      (int - 1)
      |> Integer.to_string()

    raw(
      '<a href="#{block_path(conn, :go_to_page, hash, num)}" class="button btn btn-primary"><i class="fa fa-angle-left"></i></a>'
    )
  end

  def get_next_page(conn, hash, page) do
    int =
      page
      |> String.to_integer()

    num =
      (int + 1)
      |> Integer.to_string()

    raw(
      '<a href="#{block_path(conn, :go_to_page, hash, num)}" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
    )
  end

  def check_last(page, total) do
    int =
      page
      |> String.to_integer()

    if int * 15 < total do
      true
    else
      false
    end
  end

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

      type == "StateTransaction" ->
        'invocation-transaction'

      type == "PublishTransaction" ->
        'publish-transaction'

      type == "MinerTransaction" ->
        'miner-transaction'
    end
  end

  def get_explanation(topic) do
    Explanations.get(topic)
  end

  def get_tooltips(conn) do
    ViewHelper.get_tooltips(conn)
  end
end
