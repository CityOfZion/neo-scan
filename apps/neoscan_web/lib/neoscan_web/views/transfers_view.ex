defmodule NeoscanWeb.TransfersView do
  use NeoscanWeb, :view
  import Number.Delimit
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers

  def get_current_min_qtd(page) do
    %{:total_transfers => total} = Api.get_stats()

    if total == 0 do
      1
    else
      (String.to_integer(page) - 1) * 15 + 1
    end
  end

  def get_current_max_qtd(page) do
    %{:total_transfers => total} = Api.get_stats()

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
    int =
      page
      |> String.to_integer()

    num =
      (int - 1)
      |> Integer.to_string()

    raw(
      '<a href="#{transfers_path(conn, :go_to_page, num)}" class="button btn btn-primary"><i class="fa fa-angle-left"></i></a>'
    )
  end

  def get_next_page(conn, page) do
    int =
      page
      |> String.to_integer()

    num =
      (int + 1)
      |> Integer.to_string()

    raw(
      '<a href="#{transfers_path(conn, :go_to_page, num)}" class="button btn btn-primary"><i class="fa fa-angle-right"></i></a>'
    )
  end

  def check_last(page) do
    int =
      page
      |> String.to_integer()

    %{:total_transfers => total} = Api.get_stats()

    if int * 15 < total do
      true
    else
      false
    end
  end

  def get_total() do
    %{:total_transfers => total} = Api.get_stats()

    total
  end
end
