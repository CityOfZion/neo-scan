defmodule NeoscanWeb.BlockView do
  use NeoscanWeb, :view
  alias Neoscan.Vm.Disassembler
  alias NeoscanMonitor.Api

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
end
