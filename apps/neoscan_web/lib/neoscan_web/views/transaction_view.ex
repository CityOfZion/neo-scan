defmodule NeoscanWeb.TransactionView do
  use NeoscanWeb, :view
  use Timex
  import Number.Delimit
  alias Neoscan.Vm.Disassembler
  alias Neoscan.Helpers
  alias Neoscan.Explanations
  alias NeoscanWeb.ViewHelper
  alias Neoscan.Assets
  import NeoscanWeb.CommonView

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
    precision = Assets.get_asset_precision_by_hash(asset)

    amount
    |> Helpers.apply_precision(asset, precision)
  end
end
