defmodule Neoscan.Repo.Migrations.TransactionAbstracts do
  use Ecto.Migration

  def change do
    create table(:transaction_abstracts, primary_key: false) do
      add(:transaction_hash, :binary, primary_key: true)
      add(:address_from, :binary, primary_key: false)
      add(:address_to, :binary, primary_key: false)
      add(:value, :float, null: false)
      add(:asset_hash, :binary, null: false)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    create(index(:transaction_abstracts, [:address_from, :block_time]))
    create(index(:transaction_abstracts, [:address_to, :block_time]))
  end
end
