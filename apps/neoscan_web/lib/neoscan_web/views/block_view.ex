defmodule NeoscanWeb.BlockView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias Neoscan.Vm.Disassembler
  alias Neoscan.Helpers
  alias Neoscan.Explanations
  alias NeoscanWeb.ViewHelper
  alias Neoscan.Assets
  alias NeoscanCache.Api, as: CacheApi

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

  def get_current_min_qtd(_page, total) when total < 15, do: 0
  def get_current_min_qtd(page, _total), do: (page - 1) * 15 + 1

  def get_current_max_qtd(_page, total) when total < 15, do: total
  def get_current_max_qtd(page, total) when page * 15 > total, do: total
  def get_current_max_qtd(page, _total), do: page * 15

  def check_last(page, total), do: page * 15 < total

  def get_class("ContractTransaction"), do: 'neo-transaction'
  def get_class("ClaimTransaction"), do: 'gas-transaction'
  def get_class("IssueTransaction"), do: 'issue-transaction'
  def get_class("RegisterTransaction"), do: 'register-transaction'
  def get_class("InvocationTransaction"), do: 'invocation-transaction'
  def get_class("EnrollmentTransaction"), do: 'invocation-transaction'
  def get_class("StateTransaction"), do: 'invocation-transaction'
  def get_class("PublishTransaction"), do: 'publish-transaction'
  def get_class("MinerTransaction"), do: 'miner-transaction'

  def get_explanation(topic) do
    Explanations.get(topic)
  end

  def get_tooltips(conn) do
    ViewHelper.get_tooltips(conn)
  end

  def apply_precision(asset, amount) do
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
