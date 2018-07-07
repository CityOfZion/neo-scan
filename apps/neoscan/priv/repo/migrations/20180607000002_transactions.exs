defmodule Neoscan.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:block_hash, :binary, null: false)
      add(:block_index, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)
      add(:attributes, {:array, :map}, null: false)
      add(:net_fee, :float, null: false)
      add(:sys_fee, :float, null: false)
      add(:nonce, :bigint, null: true)
      add(:scripts, {:array, :map}, null: false)
      add(:size, :integer, null: false)
      add(:type, :string, null: false)
      add(:version, :integer, null: false)
      timestamps()
    end

    create(index(:transactions, [:block_hash]))
    create(index(:transactions, [:block_index]))
    create(index(:transactions, [:block_index], where: "type != 'miner_transaction'", name: "partial_index_block_index"))
    create(index(:transactions, [:block_time]))
    create(index(:transactions, [:type]))
  end
end
