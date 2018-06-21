defmodule Neoscan.Repo.Migrations.Vins do
  use Ecto.Migration

  def change do
    create table(:vins, primary_key: false) do
      add(:transaction_hash, :binary, null: false)
      add(:vout_transaction_hash, :binary, null: false)
      add(:vout_n, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)

      timestamps()
    end

    create(unique_index(:vins, [:vout_transaction_hash, :vout_n]))
    create(index(:vins, [:transaction_hash]))
  end
end
