defmodule Neoscan.Repo.Migrations.TransactionAssets do
  use Ecto.Migration

  def change do
    create table(:transaction_assets, primary_key: false) do
      add(:transaction_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
    end
  end
end
