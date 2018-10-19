defmodule NeoscanCache.Factory do
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
  alias Neoscan.CounterQueue

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
        invocation: Base.encode16(:crypto.strong_rand_bytes(32))
      },
      size: 1526,
      time: DateTime.utc_now(),
      version: 2,
      tx_count: 0,
      total_sys_fee: Decimal.new(0),
      total_net_fee: Decimal.new(0),
      cumulative_sys_fee: Decimal.new(0),
      gas_generated: Decimal.new("8.1")
    }
  end

  def transaction_factory do
    %Transaction{
      id: sequence(1, & &1),
      hash: :crypto.strong_rand_bytes(32),
      block_hash: :crypto.strong_rand_bytes(32),
      block_index: sequence(1, & &1),
      block_time: DateTime.utc_now(),
      net_fee: Decimal.new("0.0"),
      sys_fee: Decimal.new("0.0"),
      nonce: 5,
      extra: %{},
      size: 123,
      type: Enum.random(@transaction_type),
      version: 0,
      n: sequence(1, & &1)
    }
  end

  def vout_factory do
    %Vout{
      transaction_id: sequence(1, & &1),
      transaction_hash: :crypto.strong_rand_bytes(32),
      n: sequence(1, & &1),
      address_hash: :crypto.strong_rand_bytes(32),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: Decimal.new("1.23"),
      claimed: false,
      spent: false,
      start_block_index: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def vin_factory do
    %Vin{
      transaction_id: sequence(1, & &1),
      vout_transaction_hash: :crypto.strong_rand_bytes(32),
      vout_n: sequence(1, & &1),
      n: sequence(1, & &1),
      block_index: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def claim_factory do
    %Claim{
      transaction_id: sequence(1, & &1),
      vout_transaction_hash: :crypto.strong_rand_bytes(32),
      vout_n: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def address_history_factory do
    %AddressHistory{
      address_hash: :crypto.strong_rand_bytes(32),
      transaction_id: sequence(1, & &1),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: Decimal.new("5.0"),
      block_time: DateTime.utc_now()
    }
  end

  def address_balance_factory do
    %AddressBalance{
      address_hash: :crypto.strong_rand_bytes(32),
      asset_hash: :crypto.strong_rand_bytes(32),
      value: Decimal.new("5.0")
    }
  end

  def address_transaction_factory do
    %AddressTransaction{
      address_hash: :crypto.strong_rand_bytes(32),
      transaction_id: sequence(1, & &1),
      block_time: DateTime.utc_now()
    }
  end

  def address_factory do
    %Address{
      hash: :crypto.strong_rand_bytes(32),
      first_transaction_time: DateTime.utc_now(),
      last_transaction_time: DateTime.utc_now(),
      tx_count: 12,
      atb_count: 1
    }
  end

  def transfer_factory do
    %Transfer{
      transaction_id: sequence(1, & &1),
      address_from: :crypto.strong_rand_bytes(32),
      address_to: :crypto.strong_rand_bytes(32),
      amount: Decimal.new("5.0"),
      contract: :crypto.strong_rand_bytes(32),
      block_index: 12,
      block_time: DateTime.utc_now()
    }
  end

  def asset_factory do
    %Asset{
      transaction_id: sequence(1, & &1),
      transaction_hash: :crypto.strong_rand_bytes(32),
      admin: :crypto.strong_rand_bytes(32),
      amount: Decimal.new("5.0"),
      name: %{"en" => "truc"},
      owner: :crypto.strong_rand_bytes(32),
      precision: 12,
      type: "token",
      issued: Decimal.new("1.0"),
      contract: :crypto.strong_rand_bytes(32),
      block_time: DateTime.utc_now()
    }
  end

  def counter_factory do
    %CounterQueue{
      name: sequence("name"),
      ref: <<0>>,
      value: sequence(1, & &1)
    }
  end
end
