defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:first_transaction_time, :naive_datetime)
      add(:tx_count, :integer)

      timestamps()
    end
  end
end
