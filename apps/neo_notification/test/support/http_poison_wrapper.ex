defmodule NeoNotification.HTTPPoisonWrapper do
  @moduledoc false

  @notification_url Application.fetch_env!(:neo_notification, :notification_url_test)

  @tokens_page_1 %{
    "current_height" => 2_326_419,
    "message" => "Results for tokens",
    "page" => 1,
    "page_len" => 1,
    "results" => [
      %{
        "block" => 2_120_075,
        "tx" => "0xd7d97c3fc600ee22170f2a66a9b5c83a2122e8c02c6517d81c99d3efedf886d3",
        "token" => %{
          "name" => "Loopring Neo Token",
          "symbol" => "LRN",
          "decimals" => 8,
          "script_hash" => "0x06fa8be9b6609d963e8fc63977b9f8dc5f10895f",
          "contract_address" => "AQV236N8gvwsPpNkMeVFK5T8gSTriU1gri"
        },
        "contract" => %{
          "version" => 0,
          "hash" => "0x06fa8be9b6609d963e8fc63977b9f8dc5f10895f",
          "script" => nil,
          "parameters" => [
            "String",
            "Array"
          ],
          "returntype" => "ByteArray",
          "name" => "lrnToken",
          "code_version" => "1",
          "author" => "Loopring",
          "email" => "@",
          "description" => "LrnToken",
          "properties" => %{
            "storage" => true,
            "dynamic_invoke" => false
          }
        },
        "key" => "0x065f89105fdcf8b97739c68f3e969d60b6e98bfa06"
      }
    ],
    "total" => 2,
    "total_pages" => 2
  }

  @tokens_page_2 %{
    "current_height" => 2_326_419,
    "message" => "Results for tokens",
    "page" => 2,
    "page_len" => 1,
    "results" => [
      %{
        "block" => 1_982_259,
        "tx" => "0x449b6f8e305ea79bc9c10cdc096cff0a2b5d7ab94fe42b8c85ccb24a500baeeb",
        "token" => %{
          "name" => "Orbis",
          "symbol" => "OBT",
          "decimals" => 8,
          "script_hash" => "0x0e86a40588f715fcaf7acd1812d50af478e6e917",
          "contract_address" => "AHxKPazwxuL1rDBEbodogyf24zzASxwRRz"
        },
        "contract" => %{
          "code" => %{},
          "version" => 0,
          "hash" => "0x0e86a40588f715fcaf7acd1812d50af478e6e917",
          "script" => "0x12",
          "parameters" => [
            "String",
            "Array"
          ],
          "returntype" => "ByteArray",
          "name" => "Orbis",
          "code_version" => "2.00",
          "author" => "The Orbis Team",
          "email" => "admin@orbismesh.com",
          "description" => "Orbis Token (OBT)",
          "properties" => %{
            "storage" => true,
            "dynamic_invoke" => false
          }
        },
        "key" => "0x0617e9e678f40ad51218cd7aaffc15f78805a4860e"
      }
    ],
    "total" => 2,
    "total_pages" => 2
  }

  def get("#{@notification_url}/notifications/block/0?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_400_000,
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
              },
              %{
                "addr_from" => "",
                "addr_to" => "AHWaJejUjvez5R6SW5kbWrMoLA9vSzTpW9",
                "amount" => "9096780000000000",
                "block" => 1_444_843,
                "contract" => "0xecc6b20d3ccac1ee9ef109af5a7cdb85706b1df9",
                "notify_type" => "random",
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

  def get("#{@notification_url}/notifications/block/2006033?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body:
          Poison.encode!(%{
            "current_height" => 2_006_734,
            "message" => "Results for a block",
            "results" => [
              %{
                "contract" => "0x1d5b6767af6e05dd6ab7e5e4d4894bb5e0fd06ae",
                "block" => 2_006_033,
                "tx" => "0x41383bdacaa89c81289542eb276c5ef126ef5438ee16db91e1050cd932ca3a1f",
                "index" => 0,
                "notify_type" => "transfer",
                "state" => %{
                  "type" => "Array",
                  "value" => [
                    %{
                      "type" => "ByteArray",
                      "value" => "7472616e73666572"
                    },
                    %{
                      "type" => "ByteArray",
                      "value" => ""
                    },
                    %{
                      "type" => "ByteArray",
                      "value" => "117a672273cbd0b876046151d2034715e2ce95bcb8"
                    },
                    %{
                      "type" => "Integer",
                      "value" => "480000000"
                    }
                  ]
                },
                "key" => "0x03119c1e0001000000"
              },
              %{
                "contract" => "0x1d5b6767af6e05dd6ab7e5e4d4894bb5e0fd06ae",
                "block" => 2_006_033,
                "tx" => "0x41383bdacaa89c81289542eb276c5ef126ef5438ee16db91e1050cd932ca3a1f",
                "index" => 1,
                "notify_type" => "mine",
                "state" => %{
                  "type" => "Array",
                  "value" => [
                    %{
                      "type" => "ByteArray",
                      "value" => "6d696e65"
                    },
                    %{
                      "type" => "ByteArray",
                      "value" => "9ac400"
                    },
                    %{
                      "type" => "Integer",
                      "value" => "480000000"
                    }
                  ]
                },
                "key" => "0x03119c1e0002000000"
              }
            ],
            "page" => 1,
            "page_len" => 500,
            "total" => 2,
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

  def get("#{@notification_url}/notifications/block/123457?page=1", _, _) do
    {:error, :timeout}
  end

  def get("#{@notification_url}/tokens?page=1", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body: Poison.encode!(@tokens_page_1),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("#{@notification_url}/tokens?page=2", _, _) do
    {
      :ok,
      %HTTPoison.Response{
        body: Poison.encode!(@tokens_page_2),
        headers: [],
        status_code: 200
      }
    }
  end

  def get("error" <> _, _, _), do: {:error, :error}

  def get(url, headers, opts) do
    IO.inspect({url, headers, opts})
    result = HTTPoison.get(url, headers, opts)
    IO.inspect(result)
    IO.inspect(elem(result, 1), limit: :infinity)
    result
  end
end
