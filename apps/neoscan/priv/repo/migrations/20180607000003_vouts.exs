defmodule Neoscan.Repo.Migrations.Vouts do
  use Ecto.Migration

  def change do
    create table(:vouts, primary_key: false) do
      add(:transaction_hash, :binary, null: false, primary_key: true)
      add(:n, :integer, null: false, primary_key: true)
      add(:address_hash, :binary, null: false)
      add(:asset_hash, :binary, null: false)
      add(:value, :float, null: false)
      add(:block_time, :naive_datetime, null: false)

      add(:claimed, :boolean, null: false, default: false)
      add(:spent, :boolean, null: false, default: false)
      add(:start_block_index, :integer, null: false)
      add(:end_block_index, :integer)

      timestamps()
    end

    create(index(:vouts, [:transaction_hash]))

    #partial index is used to get unspent blocks
    create(index(:vouts, [:address_hash, :spent]))
    create(index(:vouts, [:address_hash, :claimed]))
    create(index(:vouts, [:address_hash, :claimed, :spent]))
  end
end
