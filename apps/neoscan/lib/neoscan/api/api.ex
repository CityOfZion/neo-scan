defmodule Neoscan.Api do
  @moduledoc """
    Main API for accessing data from the explorer.
    All data is provided through GET requests in `/api/main_net/v1`.
    Testnet isn't currently available.
  """

  import Ecto.Query, warn: true

  alias Neoscan.Repo
  alias Neoscan.Addresses.Address
  alias Neoscan.BalanceHistories.History
  alias Neoscan.Transactions
  alias Neoscan.Transfers.Transfer
  alias Neoscan.Transactions.Transaction
  alias Neoscan.ChainAssets
  alias Neoscan.ChainAssets.Asset
  alias Neoscan.Blocks.Block
  alias Neoscan.Blocks
  alias Neoscan.Vouts
  alias Neoscan.Vouts.Vout
  alias NeoscanMonitor.Api
  alias Neoscan.Helpers
  alias Neoscan.Claims.Claim
  alias Neoscan.Claims.Unclaimed
  alias Neoscan.Stats

  # sanitize struct
  defimpl Poison.Encoder, for: Any do
    def encode(%{__struct__: _} = struct, options) do
      struct
      |> Map.from_struct()
      |> sanitize_map
      |> Poison.Encoder.Map.encode(options)
    end

    defp sanitize_map(map) do
      Map.drop(map, [:__meta__, :__struct__])
    end
  end

  @doc """
  Returns the balance for an address from its `hash_string`

  ## Examples

      /api/main_net/v1/get_balance/{hash_string}
      {
        "balance": [
          {
            "asset": "name_string",
            "amount": float,
            "unspent": [
              {
                "txid": "tx_id_string",
                "value": float,
                "n": integer
              },
              ...
            ]
          }
          ...
        ],
        "address": "hash_string"
      }

  """
  def get_balance(hash) do
    query =
      from(
        e in Address,
        where: e.address == ^hash,
        select: %{
          :id => e.id,
          :address => e.address,
          :balance => e.balance
        }
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{:address => "not found", :balance => nil, :unclaimed => 0}

        %{} = address ->
          new_balance = filter_balance(address.address, address.balance)

          Map.merge(address, %{
            :balance => new_balance
            # :unclaimed => Unclaimed.calculate_bonus(address.id),
          })
          |> Map.delete(:id)
      end

    result
  end

  @doc """
  Returns the unclaimed gas for an address from its `hash_string`

  ## Examples

      /api/main_net/v1/get_unclaimed/{hash_string}
      {
        "unclaimed": float,
        "address": "hash_string"
      }

  """
  def get_unclaimed(hash) do
    query =
      from(
        e in Address,
        where: e.address == ^hash,
        select: %{
          :id => e.id
        }
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{:address => "not found", :unclaimed => 0}

        %{} = address ->
          %{:address => hash, :unclaimed => Unclaimed.calculate_bonus(address.id)}
      end

    result
  end

  @doc """
  Returns the claimed transactions for an address, from its `hash_string`.

  ## Examples

      /api/main_net/v1/get_claimed/{hash_string}
      {
        "claimed": [
          {
            "txids": [
              "tx_id_string",
              "tx_id_string",
              "tx_id_string",
              ...
            ],
            "asset": "name_string",
            "amount": "float",
          },
          ...
        ],
        "address": "hash_string"
      }

  """
  def get_claimed(hash) do

    claim_query =
      from(
        h in Claim,
        select: %{
          txids: h.txids
        }
      )

    query =
      from(
        e in Address,
        where: e.address == ^hash,
        preload: [
          claimed: ^claim_query
        ],
        select: e
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{:address => "not found", :claimed => nil}

        %{:address => hash, :claimed => claimed} ->
          %{:address => hash, :claimed => claimed}
      end

    result
  end

  @doc """
  Returns the AVAILABLE claimable transactions for an address, from its `hash_string`.

  ## Examples

      /api/main_net/v1/get_claimable/{hash_string}
      {
        "unclaimed": float,
        "claimable": [
          {
            "txid": "tx_id_string",
            "n": integer,
            "value": float,
            "unclaimed": float,
            "start_height": integer,
            "end_height": integer
          },
          ...
        ],
        "address": "hash_string"
      }

  """
  def get_claimable(hash) do
    query =
      from(
        e in Address,
        where: e.address == ^hash,
        select: %{
          :address => e.address,
          :id => e.id
        }
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{:address => "not found", :claimable => nil}

        %{} = address ->
          Map.merge(address, %{
            claimable: Unclaimed.calculate_vouts_bonus(address.id),
            unclaimed: Unclaimed.calculate_bonus(address.id)
          })
          |> Map.delete(:id)
      end

    result
  end

  @doc """
  Returns the address model from its `hash_string`

  ## Examples
      /api/main_net/v1/get_address/{hash_string}
      {
        "txids": [
          {
            "txid": "tx_id_string",
            "balance": "balance_object_snapshot"
          },
          ...
        ],
        "claimed": [
          {
            "txids": [
              "tx_id_string",
              "tx_id_string",
              "tx_id_string",
              ...
            ],
            "asset": "name_string",
            "amount": "float",
          },
          ...
        ],
        "balance": [
          {
            "asset": "name_string",
            "amount": float,
            "unspent": [
              {
                "txid": "tx_id_string",
                "value": float,
                "n": integer
              },
              ..
            ]
          }
          ...
        ],
        "address": "hash_string"
      }
  """
  def get_address(hash) do
    his_query =
      from(
        h in History,
        select: %{
          txid: h.txid,
          balance: h.balance,
          block_height: h.block_height
        }
      )

    claim_query =
      from(
        h in Claim,
        select: %{
          txids: h.txids
        }
      )

    query =
      from(
        e in Address,
        where: e.address == ^hash,
        preload: [
          histories: ^his_query,
          claimed: ^claim_query
        ],
        select: e
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{
            :address => "not found",
            :balance => nil,
            :txids => nil,
            :claimed => nil
          }

        %{} = address ->
          new_balance = filter_balance(address.address, address.balance)

          new_tx =
            Enum.map(address.histories, fn %{
                                             :txid => txid,
                                             :balance => balance,
                                             :block_height => block_height
                                           } ->
              %{
                :txid => txid,
                :balance => filter_balance(balance),
                :block_height => block_height
              }
            end)

          Map.merge(address, %{
            :balance => new_balance,
            :txids => new_tx,
            :unclaimed => Unclaimed.calculate_bonus(address.id)
          })
          |> Map.delete(:inserted_at)
          |> Map.delete(:histories)
          |> Map.delete(:updated_at)
          |> Map.delete(:vouts)
          |> Map.delete(:id)
      end

    result
  end

  @doc """
  Returns the address model from its `hash_string`

  ## Examples

      /api/main_net/v1/get_address_neon/{hash_string}
      {
        "txids": [
          {
            "txid": "tx_id_string",
            "balance": "balance_object_snapshot"
          },
          ...
        ],
        "claimed": [
          {
            "txids": [
              "tx_id_string",
              "tx_id_string",
              "tx_id_string",
              ...
            ],
            "asset": "name_string",
            "amount": "float",
          },
          ...
        ],
        "balance": [
          {
            "asset": "name_string",
            "amount": float,
            "unspent": [
              {
                "txid": "tx_id_string",
                "value": float,
                "n": integer
              },
              ..
            ]
          }
          ...
        ],
        "address": "hash_string"
      }

  """
  def get_address_neon(hash) do
    his_query =
      from(
        h in History,
        select: %{
          txid: h.txid,
          balance: h.balance,
          block_height: h.block_height
        }
      )

    claim_query =
      from(
        h in Claim,
        select: %{
          txids: h.txids
        }
      )

    query =
      from(
        e in Address,
        where: e.address == ^hash,
        preload: [
          histories: ^his_query,
          claimed: ^claim_query
        ],
        select: e
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{
            :address => "not found",
            :balance => nil,
            :txids => nil,
            :claimed => nil
          }

        %{} = address ->
          new_balance = filter_balance(address.address, address.balance)

          new_tx =
            address.histories
            |> Stream.with_index()
            |> Enum.map(fn {
                             %{
                               :txid => txid,
                               :balance => balance,
                               :block_height => block_height
                             },
                             index
                           } ->
              prev_tx =
                case Enum.at(address.histories, index + 1) do
                  nil -> %{balance: nil}
                  map -> map
                end

              {:ok, prev_balance} = Map.fetch(prev_tx, :balance)
              current_tx = Transactions.get_transaction_by_hash(txid)
              asset_moved = Map.get(current_tx, :asset_moved)

              %{
                :txid => txid,
                :balance => filter_balance(balance),
                :block_height => block_height,
                :asset_moved => asset_moved,
                :amount_moved => calculate_amount_moved(asset_moved, balance, prev_balance)
              }
            end)

          Map.merge(address, %{
            :balance => new_balance,
            :txids => new_tx
          })
          |> Map.delete(:inserted_at)
          |> Map.delete(:histories)
          |> Map.delete(:updated_at)
          |> Map.delete(:vouts)
          |> Map.delete(:id)
      end

    result
  end

  defp filter_balance(address, balance) do
    Map.to_list(balance)
    |> Enum.map(fn {_as, %{"asset" => asset, "amount" => amount}} ->
      %{
        "asset" => ChainAssets.get_asset_name_by_hash(asset),
        "amount" => Helpers.round_or_not(amount),
        "unspent" => Vouts.get_unspent_vouts_for_address_by_asset(address, asset)
      }
    end)
  end

  defp filter_balance(balance) do
    Map.to_list(balance)
    |> Enum.map(fn {_as, %{"asset" => asset, "amount" => amount}} ->
      %{
        "asset" => ChainAssets.get_asset_name_by_hash(asset),
        "amount" => Helpers.round_or_not(amount)
      }
    end)
  end

  defp calculate_amount_moved(asset_moved, balance, prev_balance) do
    current_amount = get_sent_amounts(balance, asset_moved)
    prev_amount = get_sent_amounts(prev_balance, asset_moved)
    current_amount - prev_amount
  end

  defp get_sent_amounts(nil, _asset_moved) do
    0
  end

  defp get_sent_amounts(balance, asset_moved) do
    sent_amount =
      Map.to_list(balance)
      |> Enum.filter(fn {_as, %{"asset" => asset}} ->
        asset == asset_moved
      end)

    case sent_amount do
      [] -> 0
      [{_, %{"amount" => amount}}] -> amount
    end
  end

  @doc """
  Returns registered assets in the chain

  ## Examples

      /api/main_net/v1/get_assets
      [
        {
          "type": "type_string",
          "txid": "tx_id_string",
          "precision": integer,
          "owner": "hash_string",
          "name": [
            {
              "name": "name_string",
              "lang": "language_code_string"
            },
            ...
          ],
          "issued": float,
          "amount": float,
          "admin": "hash_string"
        },
        ...
      ]

  """
  def get_assets do
    Api.get_assets()
    |> Enum.map(fn x ->
      Map.delete(x, :inserted_at)
      |> Map.delete(:updated_at)
      |> Map.delete(:id)
    end)
  end

  @doc """
  Returns asset model from its `hash_string`

  ## Examples

      /api/main_net/v1/get_asset/{hash_string}
      {
        "type": "type_string",
        "txid": "tx_id_string",
        "precision": integer,
        "owner": "hash_string",
        "name": [
          {
            "name": "name_string",
            "lang": "language_code_string"
          },
          ...
        ],
        "issued": float,
        "amount": float,
        "admin": "hash_string"
      }

  """
  def get_asset(hash) do
    query = from(e in Asset, where: e.txid == ^hash)

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{
            :txid => "not found",
            :admin => nil,
            :amount => nil,
            :name => nil,
            :owner => nil,
            :precision => nil,
            :type => nil
          }

        %{} = asset ->
          asset
      end

    Map.delete(result, :inserted_at)
    |> Map.delete(:updated_at)
    |> Map.delete(:id)
  end

  @doc """
  Returns the block model from its `hash_string` or `height`

  ## Examples

      /api/main_net/v1/get_block/{hash_string}
      /api/main_net/v1/get_block/{height}
      {
        "version": integer,
        "tx_count": integer,
        "transactions": [
          "tx_id_string",
          ...
        ],
        "time": unix_time,
        "size": integer,
        "script": {
          "verification": "hash_string",
          "invocation": "hash_string"
        },
        "previousblockhash": "hash_string",
        "nonce": "hash_string",
        "nextconsensus": "hash_string",
        "nextblockhash": "hash_string",
        "merkleroot": "hash_string",
        "index": integer,
        "hash": "hash_string",
        "confirmations": integer
      }

  """
  def get_block(hash_or_integer) do
    tran_query = from(t in Transaction, select: t.txid)
    trans_query = from(t in Transfer, select: t.txid)

    query =
      try do
        String.to_integer(hash_or_integer)
      rescue
        ArgumentError ->
          from(
            e in Block,
            where: e.hash == ^hash_or_integer,
            preload: [
              transactions: ^tran_query,
              transfers: ^trans_query
            ]
          )
      else
        hash_or_integer ->
          from(
            e in Block,
            where: e.index == ^hash_or_integer,
            preload: [
              transactions: ^tran_query,
              transfers: ^trans_query
            ]
          )
      end

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{
            :hash => "not found",
            :confirmations => nil,
            :index => nil,
            :merkleroot => nil,
            :nextblockhash => nil,
            :nextconcensus => nil,
            :nonce => nil,
            :previousblockhash => nil,
            :scrip => nil,
            :size => nil,
            :time => nil,
            :version => nil,
            :tx_count => nil,
            :transactions => nil
          }

        %{} = block ->
          block
      end

    Map.delete(result, :inserted_at)
    |> Map.delete(:updated_at)
    |> Map.delete(:id)
  end

  @doc """
  Returns the last 20 block models

  ## Examples

      /api/main_net/v1/get_last_blocks
     [
        {
          "version": integer,
          "tx_count": integer,
          "transactions": [
            "tx_id_string",
            ...
          ],
          "time": unix_time,
          "size": integer,
          "script": {
            "verification": "hash_string",
            "invocation": "hash_string"
          },
          "previousblockhash": "hash_string",
          "nonce": "hash_string",
          "nextconsensus": "hash_string",
          "nextblockhash": "hash_string",
          "merkleroot": "hash_string",
          "index": integer,
          "hash": "hash_string",
          "confirmations": integer
        },
        ...
      ]

  """
  def get_last_blocks do
    tran_query = from(t in Transaction, select: t.txid)
    trans_query = from(t in Transfer, select: t.txid)

    query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        preload: [
          transactions: ^tran_query,
          transfers: ^trans_query
        ],
        limit: 20
      )

    Repo.all(query)
    |> Enum.map(fn x ->
      Map.delete(x, :inserted_at)
      |> Map.delete(:updated_at)
      |> Map.delete(:id)
    end)
  end

  @doc """
  Returns the highest block model in the chain

  ## Examples

      /api/main_net/v1/get_highest_block
      {
        "version": integer,
        "tx_count": integer,
        "transactions": [
          "tx_id_string",
          ...
        ],
        "time": unix_time,
        "size": integer,
        "script": {
          "verification": "hash_string",
          "invocation": "hash_string"
        },
        "previousblockhash": "hash_string",
        "nonce": "hash_string",
        "nextconsensus": "hash_string",
        "nextblockhash": "hash_string",
        "merkleroot": "hash_string",
        "index": integer,
        "hash": "hash_string",
        "confirmations": integer
      }

  """
  def get_highest_block do
    tran_query = from(t in Transaction, select: t.txid)
    trans_query = from(t in Transfer, select: t.txid)

    query =
      from(
        e in Block,
        order_by: [
          desc: e.index
        ],
        preload: [
          transactions: ^tran_query,
          transfers: ^trans_query
        ],
        limit: 1
      )

    Repo.all(query)
    |> List.first()
    |> Map.delete(:inserted_at)
    |> Map.delete(:updated_at)
    |> Map.delete(:id)
  end

  @doc """
  Returns the transaction model through its `hash_string`

  ## Examples

      /api/main_net/v1/get_transaction/{hash_string}
      {
        "vouts": [
          {
            "value": float,
            "n": integer,
            "asset": "name_string",
            "address": "hash_string"
          },
          ...
        ],
        "vin": [
          {
            "value": float,
            "txid": "tx_id_string",
            "n": integer,
            "asset": "name_string",
            "address_hash": "hash_string"
          },
          ...
        ],
        "version": integer,
        "type": "type_string",
        "txid": "tx_id_string",
        "time": unix_time,
        "sys_fee": "string",
        "size": integer,
        "scripts": [
          {
            "verification": "hash_string",
            "invocation": "hash_string"
          }
        ],
        "pubkey": hash_string,
        "nonce": integer,
        "net_fee": "string",
        "description": string,
        "contract": array,
        "claims": array,
        "block_height": integer,
        "block_hash": "hash_string",
        "attributes": array,
        "asset": array
      }

  """
  def get_transaction(hash) do
    vout_query =
      from(
        v in Vout,
        select: %{
          :asset => v.asset,
          :address => v.address_hash,
          :n => v.n,
          :value => v.value
        }
      )

    query =
      from(
        t in Transaction,
        where: t.txid == ^hash,
        preload: [
          vouts: ^vout_query
        ]
      )

    result =
      case Repo.all(query)
           |> List.first() do
        nil ->
          %{
            :txid => "not found",
            :attributes => nil,
            :net_fee => nil,
            :scripts => nil,
            :size => nil,
            :sys_fee => nil,
            :type => nil,
            :version => nil,
            :vin => nil,
            :vouts => nil,
            :time => nil,
            :block_hash => nil,
            :block_height => nil,
            :nonce => nil,
            :claims => nil,
            :pubkey => nil,
            :asset => nil,
            :description => nil,
            :contract => nil
          }

        %{} = transaction ->
          new_vouts =
            Enum.map(transaction.vouts, fn %{:asset => asset} = x ->
              Map.put(x, :asset, ChainAssets.get_asset_name_by_hash(asset))
            end)

          new_vins =
            Enum.map(transaction.vin, fn %{"asset" => asset} = x ->
              Map.put(x, "asset", ChainAssets.get_asset_name_by_hash(asset))
            end)

          Map.delete(transaction, :block)
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)
          |> Map.delete(:block_id)
          |> Map.delete(:id)
          |> Map.put(:vouts, new_vouts)
          |> Map.put(:vin, new_vins)
      end

    result
  end

  @doc """
  Returns the last 20 transaction models in the chain for the selected `type`.
  If no `type` is provided, returns all types

  ## Examples

      /api/main_net/v1/get_last_transactions/{type}
      /api/main_net/v1/get_last_transactions
      [{
          "vouts": [
            {
              "value": float,
              "n": integer,
              "asset": "name_string",
              "address": "hash_string"
            },
            ...
          ],
          "vin": [
            {
              "value": float,
              "txid": "tx_id_string",
              "n": integer,
              "asset": "name_string",
              "address_hash": "hash_string"
            },
            ...
          ],
          "version": integer,
          "type": "type_string",
          "txid": "tx_id_string",
          "time": unix_time,
          "sys_fee": "string",
          "size": integer,
          "scripts": [
            {
              "verification": "hash_string",
              "invocation": "hash_string"
            }
          ],
          "pubkey": hash_string,
          "nonce": integer,
          "net_fee": "string",
          "description": string,
          "contract": array,
          "claims": array,
          "block_height": integer,
          "block_hash": "hash_string",
          "attributes": array,
          "asset": array
        },
        ...
      ]

  """
  def get_last_transactions(type) do
    vout_query =
      from(
        v in Vout,
        select: %{
          :asset => v.asset,
          :address => v.address_hash,
          :n => v.n,
          :value => v.value
        }
      )

    query =
      if type == nil do
        from(
          t in Transaction,
          where: t.inserted_at > ago(1, "hour"),
          order_by: [
            desc: t.inserted_at
          ],
          preload: [
            vouts: ^vout_query
          ],
          limit: 20
        )
      else
        from(
          t in Transaction,
          order_by: [
            desc: t.inserted_at
          ],
          where: t.type == ^type and t.inserted_at > ago(1, "hour"),
          preload: [
            vouts: ^vout_query
          ],
          limit: 20
        )
      end

    Repo.all(query)
    |> Enum.map(fn %{:vouts => vouts, :vin => vin} = x ->
      new_vouts =
        Enum.map(vouts, fn x = %{:asset => asset} ->
          Map.put(x, :asset, ChainAssets.get_asset_name_by_hash(asset))
        end)

      new_vins =
        Enum.map(vin, fn x = %{"asset" => asset} ->
          Map.put(x, "asset", ChainAssets.get_asset_name_by_hash(asset))
        end)

      Map.delete(x, :block)
      |> Map.delete(:inserted_at)
      |> Map.delete(:updated_at)
      |> Map.delete(:block_id)
      |> Map.delete(:id)
      |> Map.put(:vouts, new_vouts)
      |> Map.put(:vin, new_vins)
    end)
  end

  @doc """
  Returns all working nodes and their respective heights.
  Information is updated each 5 minutes.

  Currrent tested nodes are:

  http://seed1.cityofzion.io:8080
  http://seed2.cityofzion.io:8080
  http://seed3.cityofzion.io:8080
  http://seed4.cityofzion.io:8080
  http://seed5.cityofzion.io:8080
  http://api.otcgo.cn:10332
  http://seed1.neo.org:10332
    http://seed2.neo.org:10332
    http://seed3.neo.org:10332
    http://seed4.neo.org:10332
  http://seed5.neo.org:10332

  ## Examples

      /api/main_net/v1/get_all_nodes
            [
              {
                "url": "http://seed1.cityofzion.io:8080",
          "height": 1239778
        },
        ...
      ]

  """
  def get_all_nodes do
    Api.get_data()
    |> Enum.map(fn {url, height} -> %{url: url, height: height} end)
  end

  @doc """
  Returns nodes with the majority of block heigh value.

  ## Examples

      /api/main_net/v1/get_nodes
      {
        "urls": [
          "http://seed1.cityofzion.io: 8080",
          ....
        ]
      }

  """
  def get_nodes do
    %{urls: Api.get_nodes()}
  end

  @doc """
  Returns the blockchain current height, as determined by the majority of
  working nodes.

  ## Examples

      /api/main_net/v1/get_height
      {
        "height": 1239809
      }

  """
  def get_height do
    {:ok, height} = Api.get_height()
    %{:height => height}
  end

  @doc """
  Returns the the total of spent fees in the network between a height range

  ## Examples

      /api/main_net/v1/get_fees_in_range/500-1000
      {
        "total_sys_fee": 0,
        "total_net_fee": 0
      }

  """
  def get_fees_in_range(height_string) do
    range = String.split(height_string, "-")

    if Enum.count(range) != 2 do
      "wrong input"
    else
      [height1, height2] = range
      Blocks.get_fees_in_range(height1, height2)
    end
  end

  def repair_blocks do
    Unclaimed.repair_blocks()
  end

  def repair_block_counter do
    Blocks.count_blocks()
    |> Stats.set_blocks()
  end
end
