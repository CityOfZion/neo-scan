defmodule Neoscan.Repo.Migrations.AddressHistories do
  use Ecto.Migration

  def change do
    create table(:address_histories, primary_key: false) do
      add(:address_hash, :binary, null: false)
      add(:transaction_hash, :binary, null: false)
      add(:transaction_id, :bigint, null: false)
      add(:asset_hash, :binary, null: false)
      add(:value, :decimal, null: false)
      add(:block_time,  :naive_datetime, null: false)

      timestamps()
    end
  end
end
