defmodule Neoscan.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Neoscan.Repo
  alias Neoscan.Addresses
  alias Neoscan.Transactions

  def address_factory do
    %Addresses.Address{
      address: "sequence("hash")",
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
      vouts: [build(:vout)],
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
