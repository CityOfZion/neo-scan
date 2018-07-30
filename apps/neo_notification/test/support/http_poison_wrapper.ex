defmodule NeoNotification.HTTPPoisonWrapper do
  @moduledoc false

  @notification_url "http://fake-notification-server"

  @tokens %{
    "current_height" => 2_326_419,
    "message" => "",
    "page" => 0,
    "page_len" => 500,
    "results" => [
      %{
        "block" => 2_120_069,
        "contract" => %{
          "author" => "Loopring",
          "code" => %{
            "hash" => "0xcb9f3b7c6fb1cf2c13a40637c189bdd066a272b4",
            "parameters" => "0710",
            "returntype" => 5,
            "script" => ""
          },
          "code_version" => "1",
          "description" => "LrnToken",
          "email" => "@",
          "name" => "lrnToken",
          "properties" => %{
            "dynamic_invoke" => false,
            "storage" => true
          },
          "version" => 0
        },
        "token" => %{
          "contract_address" => "AQV236N8gvwsPpNkMeVFK5T8gSTriU1gri",
          "decimals" => 8,
          "name" => "Loopring Neo Token",
          "script_hash" => "0x06fa8be9b6609d963e8fc63977b9f8dc5f10895f",
          "symbol" => "LRN"
        },
        "tx" => "0xe708a3e7697d89b9d3775399dcee22ffffed9602c4077968a66e059a4cccbe25",
        "type" => "SmartContract.Contract.Create"
      }
    ],
    "total" => 1,
    "total_pages" => 1
  }

  def get("#{@notification_url}/notifications/block/0?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_337_751,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [],
            "total" => 0,
            "total_pages" => 1
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/notifications/block/1444843?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_337_751,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [
              %{
                "addr_from" => "",
                "addr_to" => "ATuT3d1cM4gtg6HezpFrgMppAV3wC5Pjd9",
                "amount" => "5065200000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "",
                "addr_to" => "AHWaJejUjvez5R6SW5kbWrMoLA9vSzTpW9",
                "amount" => "9096780000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              },
              %{
                "addr_from" => "",
                "addr_to" => "AN8cLUwpv7UEWTVxXgGKeuWvwoT2psMygA",
                "amount" => "3500000000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "transfer",
                "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                "type" => "SmartContract.Runtime.Notify"
              }
            ],
            "total" => 3,
            "total_pages" => 1
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/notifications/block/1444902?page=" <> page, _, _) do
    page = String.to_integer(page)

    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_473,
            "message" => "",
            "page" => page,
            "page_len" => 500,
            "results" =>
              List.duplicate(
                %{
                  "addr_from" => "",
                  "addr_to" => "AN8cLUwpv7UEWTVxXgGKeuWvwoT2psMygA",
                  "amount" => "3500000000000000",
                  "block" => 1_444_843,
                  "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                  "notify_type" => "transfer",
                  "tx" => "0xc920b2192e74eda4ca6140510813aa40fef1767d00c152aa6f8027c24bdf14f2",
                  "type" => "SmartContract.Runtime.Notify"
                },
                if(page < 6, do: 500, else: 271)
              ),
            "total" => 2771,
            "total_pages" => 6
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/notifications/block/1444801?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_473,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [],
            "total" => 0,
            "total_pages" => 0
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/notifications/block/1?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_326_467,
            "message" => "",
            "page" => 0,
            "page_len" => 500,
            "results" => [],
            "total" => 0,
            "total_pages" => 0
          }),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/tokens?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body: Poison.encode!(@tokens),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("error", _, _), do: {:error, :error}

  def get(url, headers, opts) do
    IO.inspect({url, headers, opts})
    result = HTTPoison.get(url, headers, opts)
    IO.inspect(result)
    IO.inspect(Poison.decode!(elem(result, 1).body), limit: :infinity)
    result
  end
end
