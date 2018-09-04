defmodule Neoscan.Repo.Migrations.Assets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add(:transaction_hash, :binary, primary_key: true)
      add(:admin, :binary, null: false)
      add(:amount, :decimal, null: false)
      add(:name, {:array, :map}, null: false)
      add(:owner, :binary, null: false)
      add(:precision, :integer, null: false)
      add(:type, :string, null: false)
      add(:issued, :decimal)
      add(:block_time, :naive_datetime, null: false)
      add(:contract, :binary, null: false)

      timestamps()
    end
  end
end
