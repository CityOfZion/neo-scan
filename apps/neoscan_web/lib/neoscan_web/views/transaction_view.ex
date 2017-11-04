defmodule NeoscanWeb.TransactionView do
  use NeoscanWeb, :view
  alias NeoscanMonitor.Api
  alias Neoscan.Vm.Disassembler
  alias Neoscan.Helpers

  def get_type(type) do
    cond do
      type == "MinerTransaction" ->
        'Miner'
      type == "ContractTransaction" ->
        'Contract'
      type == "ClaimTransaction" ->
        'GAS Claim'
      type == "IssueTransaction" ->
        'Asset Issue'
      type == "RegisterTransaction" ->
        'Asset Register'
      type == "InvocationTransaction" ->
        'Contract Invocation'
      type == "PublishTransaction" ->
        'Contract Publish'
    end
  end

  def get_icon(type) do
    cond do
      type == "MinerTransaction" ->
        'fa-user-circle-o'
      type == "ContractTransaction" ->
        'fa-cube'
      type == "ClaimTransaction" ->
        'fa-cubes'
      type == "IssueTransaction" ->
        'fa-handshake-o'
      type == "RegisterTransaction" ->
        'fa-list-alt'
      type == "InvocationTransaction" ->
        'fa-paper-plane'
      type == "PublishTransaction" ->
        'Contract Publish'
    end
  end

  def compare_time_and_get_minutes(time) do

    ecto_time = Ecto.DateTime.from_unix!(time, :second)

    [dt1, dt2] = [ecto_time, Ecto.DateTime.utc]
                   |> Enum.map(&Ecto.DateTime.to_erl/1)
                   |> Enum.map(&NaiveDateTime.from_erl!/1)
                   |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))
                   |> Enum.map(&DateTime.to_unix(&1))

    {int, _str} = (dt2 - dt1) / 60
                  |> Float.floor(0)
                  |> Float.to_string
                  |> Integer.parse

    int
  end

  def parse_invocation([]) do
    "No Invocation Script"
  end
  def parse_invocation(scripts) do
    %{"invocation" => inv} = scripts
                            |> List.first

    Disassembler.parse_script(inv)
  end

  def parse_verification([]) do
    "No Verification Script"
  end
  def parse_verification(scripts) do
    %{"verification" => ver} = scripts
                            |> List.first

    Disassembler.parse_script(ver)
  end

  def get_inv([]) do
    "No Invocation Script"
  end
  def get_inv(scripts) do
    %{"invocation" => inv} = scripts
                            |> List.first
    inv
  end

  def get_ver([]) do
    "No Verification Script"
  end
  def get_ver(scripts) do
    %{"verification" => ver} = scripts
                            |> List.first

    ver
  end

end
