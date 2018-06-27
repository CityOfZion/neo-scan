defmodule NeoscanWeb.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Neoscan.Repo
  alias Neoscan.Block
  alias Neoscan.Transaction
  alias Neoscan.Vout
  alias Neoscan.Vin
  alias Neoscan.Claim
  alias Neoscan.AddressHistory
  alias Neoscan.AddressBalance
  alias Neoscan.AddressTransaction
  alias Neoscan.Address
  alias Neoscan.Transfer
  alias Neoscan.Asset
  alias Neoscan.Counter

  @transaction_type [
    "contract_transaction",
    "claim_transaction",
    "invocation_transaction",
    "enrollment_transaction",
    "state_transaction",
    "issue_transaction",
    # "register_transaction",
    "publish_transaction",
    "miner_transaction"
  ]

  def block_factory do
    %Block{
      hash: :crypto.strong_rand_bytes(32),
      index: sequence(1, & &1),
      merkle_root: :crypto.strong_rand_bytes(32),
      next_consensus: :crypto.strong_rand_bytes(32),
      nonce: :crypto.strong_rand_bytes(32),
      script: %{
        "invocation" => Base.encode16(:crypto.strong_rand_bytes(32))
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
      type: Enum.random(@transaction_type),
      version: 0
    }
  end

  def vout_factory do
    %Vout{
      transaction_hash: :crypto.strong_rand_bytes(32),
      n: sequence(1, & &1),
      address_hash: :crypto.strong_rand_bytes(32),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: 1.23,
      claimed: false,
      spent: false,
      start_block_index: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def vin_factory do
    %Vin{
      transaction_hash: :crypto.strong_rand_bytes(32),
      vout_transaction_hash: :crypto.strong_rand_bytes(32),
      vout_n: sequence(1, & &1),
      block_index: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def claim_factory do
    %Claim{
      transaction_hash: :crypto.strong_rand_bytes(32),
      vout_transaction_hash: :crypto.strong_rand_bytes(32),
      vout_n: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def address_history_factory do
    %AddressHistory{
      address_hash: :crypto.strong_rand_bytes(32),
      transaction_hash: :crypto.strong_rand_bytes(32),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: 5.0,
      block_time: DateTime.utc_now()
    }
  end

  def address_balance_factory do
    %AddressBalance{
      address_hash: :crypto.strong_rand_bytes(32),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: 5.0
    }
  end

  def address_transaction_factory do
    %AddressTransaction{
      address_hash: :crypto.strong_rand_bytes(32),
      transaction_hash: :crypto.strong_rand_bytes(32),
      block_time: DateTime.utc_now()
    }
  end

  def address_factory do
    %Address{
      hash: :crypto.strong_rand_bytes(32),
      first_transaction_time: DateTime.utc_now(),
      last_transaction_time: DateTime.utc_now(),
      tx_count: 12
    }
  end

  def transfer_factory do
    %Transfer{
      transaction_hash: :crypto.strong_rand_bytes(32),
      address_from: :crypto.strong_rand_bytes(32),
      address_to: :crypto.strong_rand_bytes(32),
      amount: 5.0,
      contract: :crypto.strong_rand_bytes(32),
      block_index: 12,
      block_time: DateTime.utc_now()
    }
  end

  def asset_factory do
    %Asset{
      transaction_hash: :crypto.strong_rand_bytes(32),
      admin: :crypto.strong_rand_bytes(32),
      amount: 5.0,
      name: [%{"lang" => "en", "name" => "truc"}],
      owner: :crypto.strong_rand_bytes(32),
      precision: 12,
      type: "token",
      issued: 1.0,
      contract: :crypto.strong_rand_bytes(32),
      block_time: DateTime.utc_now()
    }
  end

  def counter_factory do
    %Counter{
      name: sequence("name"),
      value: sequence(1, & &1)
    }
  end
end
