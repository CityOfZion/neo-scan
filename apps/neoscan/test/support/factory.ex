defmodule Neoscan.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Neoscan.Repo
  alias Neoscan.Addresses.Address
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Blocks.Block
  alias Neoscan.Transactions.Vout
  alias Neoscan.Addresses.History

  #TODO: Sequence creating strings bigger than 64 should be sliced
  def block_factory do
    %Block{
      confirmations: 50,
      hash: sequence("blockhash"),
      index: 05,
      merkleroot: sequence("b33f6f3dfead7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6faP"),
      nextblockhash: sequence("b33f6f3dfead7ddde999846bf5dda8aibbbc92cb57f161b5030ae608317c6fa8"),
      nextconsensus: sequence("b33f6f3dfead7ddde999846kf5dda8a6bbbc92cb57f161b5030ae608317c6fa8"),
      nonce: sequence("nonce"),
      previousblockhash: sequence("b30f6f3dfead7ddde999846kf5dda8a6bbbc92cb57f161b5030ae608317c6fa8"),
      script: %{
        sequence("scripthash") => sequence("scripthashinner")
      },
      size: 1526,
      time: 15154813,
      version: 2,
      tx_count: 5,
      total_sys_fee: 0,
      total_net_fee: 0
    }
  end

  def transaction_factory do
    %Transaction{
      attributes: [%{sequence("attributehash") => sequence("attributeinnerhash")}],
      net_fee: "0",
      scripts: [%{sequence("scripthash") => sequence("scriptinnerhash")}],
      size: 5,
      sys_fee: "0",
      txid: sequence("txhash"),
      type: "FactoryTransaction",
      version: 1,
      vin: [%{sequence("vinhash") => sequence("vininnerhash")}],
      time: 1548656,
      nonce: 15155,
      claims: [%{sequence("claimhash") => sequence("claiminnerhash")}],
      pubkey: sequence("pubkeyhash"),
      asset: %{
        sequence("assethash") => sequence("assetinnerhash")
      },
      description: sequence("description"),
      contract: %{
        sequence("contracthash") => sequence("contractinnerhash")
      },
      block_hash: sequence("block_hash"),
      block_height: 0
    }
  end

  def address_factory do
    %Address{
      address: sequence("hash"),
      histories: [insert(:history)],
      balance: %{
        sequence("assethash") => %{
          "asset" => sequence("assethash"),
          "amount" => 50
        }
      },
      claimed: [%{
        "txids" => [sequence("txhash")],
        "amount" => 50,
        "asset" => sequence("assethash"),
      }],
    }
  end

  def vout_factory do
    %Vout{
      asset: sequence("assethash"),
      address_hash: sequence("hash"),
      n: 0,
      value: 50,
      txid: sequence("txhash"),
    }
  end

  def history_factory do
    %History{
      address_hash: sequence("AZvTqMjOGT4AH7DZZRf4t6PRYm2k1CFdJZ"),
      txid: sequence("txid"),
      balance: %{},
      block_height: 1,
      time: 1
    }
  end


end
