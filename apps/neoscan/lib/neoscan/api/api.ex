defmodule Neoscan.Api do
  @moduledoc """
    Main API for accessing data from the explorer.
    All data is provided through GET requests in `/api/main_net/v1`.
    Testnet isn't currently available.
  """

  alias Neoscan.AddressBalance
  alias Neoscan.Repo
  alias Neoscan.Blocks
  alias Neoscan.Counters
  import Ecto.Query

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
    query = from(e in AddressBalance, where: e.address_hash == ^hash)
    balances = Repo.all(query)

    if balances == [] do
      %{:address => "not found", :balance => nil, :unclaimed => 0}
    else
      %{:address => Base.encode16(hash), :balance => 0, :unclaimed => 0}
    end
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
    query = from(e in AddressBalance, where: e.address_hash == ^hash)
    balances = Repo.all(query)

    if balances == [] do
      %{:address => "not found", :unclaimed => 0}
    else
      %{:address => Base.encode16(hash), :unclaimed => 0}
    end
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
  def get_claimed(_hash) do
    %{:address => "not found", :claimed => nil}
    #    claim_query = from(h in Claim, select: %{txids: h.txids})
    #
    #    query =
    #      from(
    #        e in Address,
    #        where: e.address == ^hash,
    #        preload: [
    #          claimed: ^claim_query
    #        ],
    #        select: e
    #      )
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{:address => "not found", :claimed => nil}
    #
    #        %{:address => hash, :claimed => claimed} ->
    #          %{:address => hash, :claimed => claimed}
    #      end
    #
    #    result
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
  def get_claimable(_hash) do
    %{:address => "not found", :claimable => nil}
    #    query =
    #      from(
    #        e in Address,
    #        where: e.address == ^hash,
    #        select: %{
    #          :address => e.address,
    #          :id => e.id
    #        }
    #      )
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{:address => "not found", :claimable => nil}
    #
    #        %{} = address ->
    #          claimable = Unclaimed.calculate_vouts_bonus(address.id)
    #
    #          Map.merge(address, %{
    #            claimable: claimable,
    #            unclaimed:
    #              Enum.reduce(claimable, 0, fn %{:unclaimed => amount}, acc -> amount + acc end)
    #          })
    #          |> Map.delete(:id)
    #      end
    #
    #    result
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
  def get_address(_hash) do
    %{
      :address => "not found",
      :balance => nil,
      :txids => nil,
      :claimed => nil
    }

    #    his_query =
    #      from(
    #        h in History,
    #        select: %{
    #          txid: h.txid,
    #          balance: h.balance,
    #          block_height: h.block_height
    #        }
    #      )
    #
    #    claim_query =
    #      from(
    #        h in Claim,
    #        select: %{
    #          txids: h.txids
    #        }
    #      )
    #
    #    query =
    #      from(
    #        e in Address,
    #        where: e.address == ^hash,
    #        preload: [
    #          histories: ^his_query,
    #          claimed: ^claim_query
    #        ],
    #        select: e
    #      )
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{
    #            :address => "not found",
    #            :balance => nil,
    #            :txids => nil,
    #            :claimed => nil
    #          }
    #
    #        %{} = address ->
    #          new_balance = filter_balance(address.address, address.balance)
    #
    #          new_tx =
    #            Enum.map(address.histories, fn %{
    #                                             :txid => txid,
    #                                             :balance => balance,
    #                                             :block_height => block_height
    #                                           } ->
    #              %{
    #                :txid => txid,
    #                :balance => filter_balance(balance),
    #                :block_height => block_height
    #              }
    #            end)
    #
    #          Map.merge(address, %{
    #            :balance => new_balance,
    #            :txids => new_tx,
    #            :unclaimed => Unclaimed.calculate_bonus(address.id)
    #          })
    #          |> Map.drop([:inserted_at, :histories, :updated_at, :vouts, :id, :__meta__, :__struct__])
    #      end
    #
    #    result
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
  def get_address_neon(_hash) do
    %{
      :address => "not found",
      :balance => nil,
      :txids => nil,
      :claimed => nil
    }

    #    his_query =
    #      from(
    #        h in History,
    #        select: %{
    #          txid: h.txid,
    #          balance: h.balance,
    #          block_height: h.block_height
    #        }
    #      )
    #
    #    claim_query =
    #      from(
    #        h in Claim,
    #        select: %{
    #          txids: h.txids
    #        }
    #      )
    #
    #    query =
    #      from(
    #        e in Address,
    #        where: e.address == ^hash,
    #        preload: [
    #          histories: ^his_query,
    #          claimed: ^claim_query
    #        ],
    #        select: e
    #      )
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{
    #            :address => "not found",
    #            :balance => nil,
    #            :txids => nil,
    #            :claimed => nil
    #          }
    #
    #        %{} = address ->
    #          new_balance = filter_balance(address.address, address.balance)
    #
    #          new_tx =
    #            address.histories
    #            |> Stream.with_index()
    #            |> Enum.map(fn {
    #                             %{
    #                               :txid => txid,
    #                               :balance => balance,
    #                               :block_height => block_height
    #                             },
    #                             index
    #                           } ->
    #              prev_tx =
    #                case Enum.at(address.histories, index + 1) do
    #                  nil -> %{balance: nil}
    #                  map -> map
    #                end
    #
    #              {:ok, prev_balance} = Map.fetch(prev_tx, :balance)
    #              current_tx = Transactions.get_transaction_by_hash(txid)
    #              asset_moved = Map.get(current_tx, :asset_moved)
    #
    #              %{
    #                :txid => txid,
    #                :balance => filter_balance(balance),
    #                :block_height => block_height,
    #                :asset_moved => asset_moved,
    #                :amount_moved => calculate_amount_moved(asset_moved, balance, prev_balance)
    #              }
    #            end)
    #
    #          Map.merge(address, %{
    #            :balance => new_balance,
    #            :txids => new_tx
    #          })
    #          |> Map.drop([:inserted_at, :histories, :updated_at, :vouts, :id, :__meta__, :__struct__])
    #      end
    #
    #    result
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
  def get_asset(_hash) do
    %{
      :txid => "not found",
      :admin => nil,
      :amount => nil,
      :name => nil,
      :owner => nil,
      :precision => nil,
      :type => nil
    }

    #    query = from(e in Asset, where: e.txid == ^hash)
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{
    #            :txid => "not found",
    #            :admin => nil,
    #            :amount => nil,
    #            :name => nil,
    #            :owner => nil,
    #            :precision => nil,
    #            :type => nil
    #          }
    #
    #        %{} = asset ->
    #          asset
    #      end
    #
    #    Map.drop(result, [:inserted_at, :updated_at, :id, :__meta__, :__struct__])
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
    block = Blocks.get(hash_or_integer)
    render_block(block)
  end

  defp render_block(block) do
    %{
      :hash => Base.encode16(block.hash, case: :lower),
      :confirmations => 1,
      :index => block.index,
      :merkleroot => Base.encode16(block.merkle_root, case: :lower),
      :nextblockhash => "",
      :nextconsensus => Base.encode16(block.next_consensus, case: :lower),
      :nonce => Base.encode16(block.nonce, case: :lower),
      :previousblockhash => "",
      :script => block.script,
      :size => block.size,
      :time => DateTime.to_unix(block.time),
      :version => block.version,
      :tx_count => block.tx_count,
      :transactions => Enum.map(block.transactions, &Base.encode16(&1, case: :lower)),
      :transfers => Enum.map(block.transfers, &Base.encode16(&1, case: :lower))
    }
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
    blocks = Blocks.get_last_blocks(20)
    Enum.map(blocks, &render_block/1)
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
    block = Blocks.get_highest_block()
    render_block(block)
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
  def get_transaction(_hash) do
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

    #    vout_query =
    #      from(
    #        v in Vout,
    #        select: %{
    #          :asset => v.asset,
    #          :address => v.address_hash,
    #          :n => v.n,
    #          :value => v.value
    #        }
    #      )
    #
    #    query =
    #      from(
    #        t in Transaction,
    #        where: t.txid == ^hash,
    #        preload: [
    #          vouts: ^vout_query
    #        ]
    #      )
    #
    #    result =
    #      case Repo.all(query)
    #           |> List.first() do
    #        nil ->
    #          %{
    #            :txid => "not found",
    #            :attributes => nil,
    #            :net_fee => nil,
    #            :scripts => nil,
    #            :size => nil,
    #            :sys_fee => nil,
    #            :type => nil,
    #            :version => nil,
    #            :vin => nil,
    #            :vouts => nil,
    #            :time => nil,
    #            :block_hash => nil,
    #            :block_height => nil,
    #            :nonce => nil,
    #            :claims => nil,
    #            :pubkey => nil,
    #            :asset => nil,
    #            :description => nil,
    #            :contract => nil
    #          }
    #
    #        %{} = transaction ->
    #          new_vouts =
    #            Enum.map(transaction.vouts, fn %{:asset => asset} = x ->
    #              Map.put(x, :asset, ChainAssets.get_asset_name_by_hash(asset))
    #            end)
    #
    #          new_vins =
    #            Enum.map(transaction.vin, fn %{"asset" => asset} = x ->
    #              Map.put(x, "asset", ChainAssets.get_asset_name_by_hash(asset))
    #            end)
    #
    #          Map.delete(transaction, :block)
    #          |> Map.drop([:inserted_at, :updated_at, :id, :block_id, :__meta__, :__struct__])
    #          |> Map.put(:vouts, new_vouts)
    #          |> Map.put(:vin, new_vins)
    #      end
    #
    #    result
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
  def get_last_transactions(_type) do
    []
    #    vout_query =
    #      from(
    #        v in Vout,
    #        select: %{
    #          :asset => v.asset,
    #          :address => v.address_hash,
    #          :n => v.n,
    #          :value => v.value
    #        }
    #      )
    #
    #    query =
    #      if type == nil do
    #        from(
    #          t in Transaction,
    #          where: t.inserted_at > ago(1, "hour"),
    #          order_by: [
    #            desc: t.inserted_at
    #          ],
    #          preload: [
    #            vouts: ^vout_query
    #          ],
    #          limit: 20
    #        )
    #      else
    #        from(
    #          t in Transaction,
    #          order_by: [
    #            desc: t.inserted_at
    #          ],
    #          where: t.type == ^type and t.inserted_at > ago(1, "hour"),
    #          preload: [
    #            vouts: ^vout_query
    #          ],
    #          limit: 20
    #        )
    #      end
    #
    #    Repo.all(query)
    #    |> Enum.map(fn %{:vouts => vouts, :vin => vin} = x ->
    #      new_vouts =
    #        Enum.map(vouts, fn x = %{:asset => asset} ->
    #          Map.put(x, :asset, ChainAssets.get_asset_name_by_hash(asset))
    #        end)
    #
    #      new_vins =
    #        Enum.map(vin, fn x = %{"asset" => asset} ->
    #          Map.put(x, "asset", ChainAssets.get_asset_name_by_hash(asset))
    #        end)
    #
    #      x
    #      |> Map.drop([:block, :inserted_at, :updated_at, :id, :block_id, :__meta__, :__struct__])
    #      |> Map.put(:vouts, new_vouts)
    #      |> Map.put(:vin, new_vins)
    #    end)
  end

  @doc """
  Returns the last 15 transaction models in the chain for the selected address
  from its hash_string, paginated.
  ## Examples
      /api/main_net/v1/get_last_transactions_by_address/{hash_string}/{page}
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
          "transfers": [
            {
              "address_from": "hash_string",
              "address_to": "hash_string",
              "amount": "integer",
              "block_height": "integer",
              "txid": "tx_id_string",
              "contract": "token_contract_string",
              "time": "integer",
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
  def get_last_transactions_by_address(_hash_string, _page) do
    []
    #    transactions =
    #      BalanceHistories.paginate_history_transactions(
    #        hash_string,
    #        page || 1
    #      )
    #
    #    transactions
  end

  @doc """
  Returns all working nodes and their respective heights.
  Information is updated each minute.
  Currrent tested nodes are:
  "http://seed1.cityofzion.io:8080",
  "http://seed2.cityofzion.io:8080",
  "http://seed3.cityofzion.io:8080",
  "http://seed4.cityofzion.io:8080",
  "http://seed5.cityofzion.io:8080",
  "http://api.otcgo.cn:10332",
  "https://seed1.neo.org:10331",
  "http://seed2.neo.org:10332",
  "http://seed3.neo.org:10332",
  "http://seed4.neo.org:10332",
  "http://seed5.neo.org:10332",
  "http://seed0.bridgeprotocol.io:10332",
  "http://seed1.bridgeprotocol.io:10332",
  "http://seed2.bridgeprotocol.io:10332",
  "http://seed3.bridgeprotocol.io:10332",
  "http://seed4.bridgeprotocol.io:10332",
  "http://seed5.bridgeprotocol.io:10332",
  "http://seed6.bridgeprotocol.io:10332",
  "http://seed7.bridgeprotocol.io:10332",
  "http://seed8.bridgeprotocol.io:10332",
  "http://seed9.bridgeprotocol.io:10332",
  "http://seed1.redpulse.com:10332",
  "http://seed2.redpulse.com:10332",
  "https://seed1.redpulse.com:10331",
  "https://seed2.redpulse.com:10331",
  "http://seed1.treatail.com:10332",
  "http://seed2.treatail.com:10332",
  "http://seed3.treatail.com:10332",
  "http://seed4.treatail.com:10332",
  "http://seed1.o3node.org:10332",
  "http://seed2.o3node.org:10332",
  "http://54.66.154.140:10332",
  "http://seed1.eu-central-1.fiatpeg.com:10332",
  "http://seed1.eu-west-2.fiatpeg.com:10332",
  "http://seed1.aphelion.org:10332",
  "http://seed2.aphelion.org:10332",
  "http://seed3.aphelion.org:10332",
  "http://seed4.aphelion.org:10332",
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
    NeoscanNode.get_data()
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
    %{urls: NeoscanNode.get_nodes()}
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
    %{:height => Counters.count_blocks() - 1}
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
      [min, max] =
        range
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort()

      Blocks.get_fees_in_range(min, max)
    end
  end

  @doc """
  Returns abstract models for an address from its `hash_string`, paginated
  ## Examples
      /api/main_net/v1/get_address_abstracts/{hash_string}/{page}
      [
        {
          "address_from": "hash_string",
          "address_to": "hash_string",
          "amount": string,
          "block_height": integer,
          "txid": "tx_id_string",
          "asset": "asset_id_string",
          "time": integer,
        },
        ...
      ]
  """
  def get_address_abstracts(_hash, _page) do
    %{entries: []}
    # TxAbstracts.get_address_abstracts(hash, page)
  end

  @doc """
  Returns abstract models for an address, to an address from their `hash_string`, paginated
  ## Examples
      /api/main_net/v1/get_address_to_address_abstracts/{hash_string}/{hash_string}/{page}
      [
        {
          "address_from": "hash_string",
          "address_to": "hash_string",
          "amount": string,
          "block_height": integer,
          "txid": "tx_id_string",
          "asset": "asset_id_string",
          "time": integer,
        },
        ...
      ]
  """
  def get_address_to_address_abstracts(_hash1, _hash2, _page) do
    %{entries: []}
    # TxAbstracts.get_address_to_address_abstracts(hash1, hash2, page)
  end
end
