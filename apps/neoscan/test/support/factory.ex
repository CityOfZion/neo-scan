defmodule Neoscan.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Neoscan.Repo
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Vout

  def block_factory do
    %Block{
      hash: :crypto.strong_rand_bytes(32),
      index: sequence(1, & &1),
      merkle_root: :crypto.strong_rand_bytes(32),
      previous_block_hash: :crypto.strong_rand_bytes(32),
      next_block_hash: :crypto.strong_rand_bytes(32),
      next_consensus: :crypto.strong_rand_bytes(32),
      nonce: :crypto.strong_rand_bytes(32),
      script: %{
        sequence("scripthash") => sequence("scripthashinner")
      },
      size: 1526,
      time: DateTime.utc_now(),
      version: 2,
      tx_count: 0,
      total_sys_fee: 0,
      total_net_fee: 0,
      gas_generated: 8.1
    }
  end

  def transaction_factory do
    %Transaction{
      hash: :crypto.strong_rand_bytes(32),
      block_hash: :crypto.strong_rand_bytes(32),
      block_index: sequence(1, & &1),
      block_time: DateTime.utc_now(),
      attributes: [],
      net_fee: 0.0,
      sys_fee: 0.0,
      nonce: 5,
      scripts: [],
      size: 123,
      type: "machin",
      version: 0
    }
  end

  def vout_factory do
    %Vout{
      transaction_hash: :crypto.strong_rand_bytes(32),
      n: sequence(1, & &1),
      address: :crypto.strong_rand_bytes(32),
      asset: :crypto.strong_rand_bytes(32),
      value: 1.23
    }
  end

  #
  #  def transaction_factory do
  #    %Transaction{
  #      attributes: [%{sequence("attributehash") => sequence("attributeinnerhash")}],
  #      net_fee: "0",
  #      scripts: [%{sequence("scripthash") => sequence("scriptinnerhash")}],
  #      size: 5,
  #      sys_fee: "0",
  #      txid: sequence("txhash"),
  #      type: "FactoryTransaction",
  #      version: 1,
  #      vin: [%{"asset" => sequence("vininnerhash")}],
  #      time: 1_548_656,
  #      nonce: 15155,
  #      claims: [%{sequence("claimhash") => sequence("claiminnerhash")}],
  #      pubkey: sequence("pubkeyhash"),
  #      asset: %{
  #        sequence("assethash") => sequence("assetinnerhash")
  #      },
  #      description: sequence("description"),
  #      contract: %{
  #        sequence("contracthash") => sequence("contractinnerhash")
  #      },
  #      block_hash: sequence("block_hash"),
  #      block_height: 0
  #    }
  #  end
  #
  #  def address_factory do
  #    %Address{
  #      address: sequence("hash"),
  #      histories: [insert(:history)],
  #      balance: %{
  #        sequence("assethash") => %{
  #          "asset" => sequence("assethash"),
  #          "amount" => 50
  #        }
  #      },
  #      claimed: [insert(:claim)],
  #      time: 154_856,
  #      vouts: [insert(:vout)],
  #      tx_count: 5
  #    }
  #  end
  #
  #  def transfer_factory do
  #    %Transfer{
  #      address_from: sequence("assethash"),
  #      address_to: sequence("hash"),
  #      amount: 0.1,
  #      block_height: 50,
  #      txid: sequence("txhash"),
  #      contract: sequence("hash"),
  #      time: 123,
  #      check_hash: sequence("txhash")
  #    }
  #  end
  #
  #  def vout_factory do
  #    %Vout{
  #      asset: sequence("assethash"),
  #      address_hash: sequence("hash"),
  #      n: 0,
  #      value: 50,
  #      txid: sequence("txhash"),
  #      start_height: 1,
  #      end_height: 50,
  #      claimed: false,
  #      query: "#{sequence("assethash")}#{0}"
  #    }
  #  end
  #
  #  def history_factory do
  #    %History{
  #      address_hash: sequence("AZvTqMjOGT4AH7DZZRf4t6PRYm2k1CFdJZ"),
  #      txid: sequence("txid"),
  #      balance: %{},
  #      block_height: 1,
  #      time: 1
  #    }
  #  end
  #
  #  def claim_factory do
  #    %Claim{
  #      address_hash: sequence("AZvTqMjOGT4AH7DZZRf4t6PRYm2k1CFdJZ"),
  #      txids: [sequence("txhash")],
  #      asset: sequence("assethash"),
  #      amount: 0.5,
  #      block_height: 5,
  #      time: 154_856
  #    }
  #  end
  #
  #  def asset_factory do
  #    %Asset{
  #      txid: sequence("txhash"),
  #      admin: sequence("AZvTqMjOGT4AH7DZZRf4t6PRYm2k1CFdJZ"),
  #      amount: 100_000.0,
  #      name: [%{}],
  #      owner: sequence("AZvTqMjOGT4AH7DZZRf4t6PRYm2k1CFdJZ"),
  #      precision: 1,
  #      type: sequence("typestring"),
  #      issued: 500.0,
  #      time: 154_856
  #    }
  #  end
end
