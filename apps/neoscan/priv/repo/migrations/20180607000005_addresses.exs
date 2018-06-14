defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:first_transaction_time, :naive_datetime, null: false)
      add(:last_transaction_time, :naive_datetime, null: false)
      add(:tx_count, :integer, null: false, default: 1)

      timestamps()
    end

    create(index(:addresses, [:last_transaction_time]))
  end
end
