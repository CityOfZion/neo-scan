defmodule Neoscan.Repo.Migrations.Vouts do
  use Ecto.Migration

  def change do
    create table(:vouts, primary_key: false) do
      add(:transaction_hash, :binary, null: false, primary_key: true)
      add(:n, :integer, null: false, primary_key: true)
      add(:address_hash, :binary, null: false)
      add(:asset, :binary, null: false)
      add(:value, :float)

      timestamps()
    end

#    create(unique_index(:vouts, [:query]))
#    create(index(:vouts, [:transaction_id]))
#    create(index(:vouts, [:address_id]))
#    create(index(:vouts, [:address_id, :asset]))
#    create(index(:vouts, [:address_hash, :asset, :end_height]))
  end
end
