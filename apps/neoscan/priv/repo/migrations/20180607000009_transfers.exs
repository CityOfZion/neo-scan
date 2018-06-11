defmodule Neoscan.Repo.Migrations.Transfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add(:address_from, :binary, null: false)
      add(:address_to, :binary, null: false)
      add(:amount, :float, null: false)
      add(:contract, :binary, null: false)
      add(:block_index, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)

      timestamps()
    end
  end
end
