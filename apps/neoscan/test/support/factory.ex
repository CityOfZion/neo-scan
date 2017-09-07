defmodule Neoscan.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Neoscan.Repo
  alias Neoscan.Addresses
  alias Neoscan.Transactions


  def block_factory do
    %Blocks.Block{
      confirmations: 50,
      hash: sequence("blockhash"),
      index: 05,
      merkleroot: sequence("merklehash"),
      nextblockhash: sequence("nexthash"),
      nextconsensus: sequence("consensushash"),
      nonce: sequence("nonce"),
      previousblockhash: sequence("previoushash"),
      script: %{sequence("scripthash") => sequence("scripthashinner")},
      size: 1526,
      time: 15154813,
      version: 2,
      tx_count: 5,
    }
  end

  def transaction_factory do
    %Transactions.Transaction{
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
      asset: %{sequence("assethash") => sequence("assetinnerhash")},
      description: sequence("description"),
      contract:  %{sequence("contracthash") => sequence("contractinnerhash")},
    }
  end

  def address_factory do
    %Addresses.Address{
      address: sequence("hash"),
      tx_ids: %{ sequence("txhash") => %{
        "txid" => sequence("txhash"),
        "balance" => %{
          sequence("assethash") => %{
            "asset" => sequence("assethash"),
            "amount" => 50
          }
        }
        }},
      balance: %{
        sequence("assethash") => %{
          "asset" => sequence("assethash"),
          "amount" => 50
      }},
      claimed: [%{
        "txids" => [ sequence("txhash")],
        "amount" => 50,
        "asset" => sequence("assethash"),
      }],
    }
  end

  def vout_factory do
    %Transactions.Vout{
      asset: sequence("assethash"),
      address_hash: sequence("hash"),
      n: 0,
      value: 50,
      txid: sequence("txhash"),
    }
  end


end
