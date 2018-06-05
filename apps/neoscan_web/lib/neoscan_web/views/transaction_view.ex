defmodule NeoscanWeb.TransactionView do
  use NeoscanWeb, :view
  use Timex
  import Number.Delimit
  alias Neoscan.Vm.Disassembler
  alias Neoscan.Helpers
  alias Neoscan.Explanations
  alias NeoscanWeb.ViewHelper
  alias Neoscan.ChainAssets
  alias NeoscanCache.Api, as: CacheApi

  def get_type("MinerTransaction"), do: 'Miner'
  def get_type("ContractTransaction"), do: 'Contract'
  def get_type("ClaimTransaction"), do: 'GAS Claim'
  def get_type("IssueTransaction"), do: 'Asset Issue'
  def get_type("RegisterTransaction"), do: 'Asset Register'
  def get_type("InvocationTransaction"), do: 'Contract Invocation'
  def get_type("PublishTransaction"), do: 'Contract Publish'
  def get_type("EnrollmentTransaction"), do: 'Enrollment'
  def get_type("StateTransaction"), do: 'State'

  def get_icon("MinerTransaction"), do: 'fa-user-circle-o'
  def get_icon("ContractTransaction"), do: 'fa-cube'
  def get_icon("ClaimTransaction"), do: 'fa-cubes'
  def get_icon("IssueTransaction"), do: 'fa-handshake-o'
  def get_icon("RegisterTransaction"), do: 'fa-list-alt'
  def get_icon("InvocationTransaction"), do: 'fa-paper-plane'
  def get_icon("EnrollmentTransaction"), do: 'fa-paper-plane'
  def get_icon("StateTransaction"), do: 'fa-list-alt'
  def get_icon("PublishTransaction"), do: 'Contract Publish'

  def compare_time_and_get_minutes(time) do
    ViewHelper.compare_time_and_get_minutes(time)
  end

  def parse_invocation(nil) do
    "No Invocation Script"
  end

  def parse_invocation(script) do
    %{"invocation" => inv} = script

    Disassembler.parse_script(inv)
  end

  def parse_verification(nil) do
    "No Verification Script"
  end

  def parse_verification(script) do
    %{"verification" => ver} = script

    Disassembler.parse_script(ver)
  end

  def get_inv(nil) do
    "No Invocation Script"
  end

  def get_inv(%{"invocation" => inv}) do
    inv
  end

  def get_ver(nil) do
    "No Verification Script"
  end

  def get_ver(%{"verification" => ver}) do
    ver
  end

  def get_explanation(topic) do
    Explanations.get(topic)
  end

  def get_tooltips(conn) do
    ViewHelper.get_tooltips(conn)
  end

  def apply_precision(asset, amount) do
    precision = ChainAssets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
