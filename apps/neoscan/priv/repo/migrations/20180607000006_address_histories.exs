defmodule Neoscan.Repo.Migrations.AddressHistories do
  use Ecto.Migration

  def change do
    create table(:address_histories, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:asset, :binary, null: false)
      add(:value, :float, null: false)
      add(:block_time,  :naive_datetime, null: false)

      timestamps()
    end
  end
end
