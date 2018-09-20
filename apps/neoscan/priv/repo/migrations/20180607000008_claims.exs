defmodule Neoscan.Repo.Migrations.Claims do
  use Ecto.Migration

  def change do
    create table(:claims, primary_key: false) do
      add(:transaction_id, :bigint, null: false)
      add(:transaction_hash, :binary, null: false)
      add(:vout_transaction_hash, :binary, null: false)
      add(:vout_n, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)

      timestamps()
    end

    # investigate why this index cannot be unique
    create(index(:claims, [:vout_transaction_hash, :vout_n]))
    create(index(:claims, [:transaction_hash]))
  end
end
