defmodule NeoscanWeb.TransactionView do
  use NeoscanWeb, :view

  def get_type(type) do
    cond do
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
end
