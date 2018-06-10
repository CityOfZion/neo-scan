defmodule Neoscan.Repo.Migrations.AddressBalances do
  use Ecto.Migration

  def change do
    create table(:address_balances, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:asset, :binary, primary_key: true)
      add(:value, :float, null: false)

      timestamps()
    end
  end
end
