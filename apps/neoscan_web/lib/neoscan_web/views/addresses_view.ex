defmodule NeoscanWeb.AddressesView do
  use NeoscanWeb, :view
  alias NeoscanMonitor.Api
  alias NeoscanWeb.ViewHelper

  def compare_time_and_get_minutes(nil), do: nil
  def compare_time_and_get_minutes(balance) do
    unix_time = Map.to_list(balance)
                |> Enum.reduce(
                     [],
                     fn ({_asset, %{"time" => time}}, acc) ->
                       [time | acc]
                     end
                   )
                |> Enum.max

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

  def get_NEO_balance(balance) do
    ViewHelper.get_NEO_balance(balance)
  end
  def get_GAS_balance(balance) do
    ViewHelper.get_GAS_balance(balance)
  end

  def get_current_min_qtd(page) do
    %{:total_addresses => total} = Api.get_stats
    if total < 15 do
      0
    else
      (String.to_integer(page) - 1) * 15 + 1
    end
  end

  def get_current_max_qtd(page) do
    %{:total_addresses => total} = Api.get_stats

    cond do
      total < 15 ->
        total
      String.to_integer(page) * 15 > total ->
        total
      true ->
        String.to_integer(page) * 15
    end
  end

  def get_previous_page(conn, page) do
    int = page
          |> String.to_integer

    num = int - 1
          |> Integer.to_string

    raw(
      '<a href="#{
        addresses_path(conn, :go_to_page, num)
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
        addresses_path(conn, :go_to_page, num)
      }" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
    )
  end

  def check_last(page) do
    %{:total_addresses => total} = Api.get_stats

    int = page
          |> String.to_integer

    if int * 15 < total do
      true
    else
      false
    end
  end

  def get_total do
    %{:total_addresses => total} = Api.get_stats
    total
  end

end
