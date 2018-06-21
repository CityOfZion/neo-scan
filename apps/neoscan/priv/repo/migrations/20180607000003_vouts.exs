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

      timestamps()
    end

    create(index(:vouts, [:transaction_hash]))
  end
end
