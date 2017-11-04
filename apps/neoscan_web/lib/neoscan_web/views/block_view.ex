defmodule NeoscanWeb.BlockView do
  use NeoscanWeb, :view
  alias Neoscan.Vm.Disassembler
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers

  def compare_time_and_get_minutes(unix_time) do

    ecto_time = Ecto.DateTime.from_unix!(unix_time, :second)

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
  def parse_invocation(%{"invocation" => inv}) do
    Disassembler.parse_script(inv)
  end

  def parse_verification([]) do
    "No Verification Script"
  end
  def parse_verification(%{"verification" => ver}) do
    Disassembler.parse_script(ver)
  end

  def get_inv([]) do
    "No Invocation Script"
  end
  def get_inv(%{"invocation" => inv}) do
    inv
  end

  def get_ver([]) do
    "No Verification Script"
  end
  def get_ver(%{"verification" => ver}) do
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

  def get_previous_page(conn, page) do
    int = page
          |> String.to_integer

    num = int - 1
          |> Integer.to_string

    raw(
      '<a href="#{
        block_path(conn, :go_to_page, num)
      }" class="button btn btn-primary"><i class="fa fa-angle-left"></i></a>'
    )
  end

  def get_next_page(conn, page) do
    int = page
          |> String.to_integer

    num = int + 1
          |> Integer.to_string

    raw(
      '<a href="#{
        block_path(conn, :go_to_page, num)
      }" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
    )
  end

  def check_last(page, total) do
    int = page
          |> String.to_integer

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
      type == "PublishTransaction" ->
        'publish-transaction'
      type == "MinerTransaction" ->
        'miner-transaction'
    end
  end

end
