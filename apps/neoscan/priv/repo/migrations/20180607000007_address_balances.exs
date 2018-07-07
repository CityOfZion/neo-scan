defmodule Neoscan.Repo.Migrations.AddressBalances do
  use Ecto.Migration

  def change do
    create table(:address_balances, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
      add(:value, :float, null: false)

      timestamps()
    end
  end
end
