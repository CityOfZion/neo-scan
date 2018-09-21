defmodule Neoscan.Repo.Migrations.Vins do
  use Ecto.Migration

  def change do
    create table(:vins, primary_key: false) do
      add(:transaction_id, :bigint, null: false)
      add(:vout_transaction_hash, :binary, null: false, primary_key: true)
      add(:vout_n, :integer, null: false, primary_key: true)
      add(:n, :integer, null: false)
      add(:block_index, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)

      timestamps()
    end

    create(index(:vins, [:transaction_id]))
  end
end
