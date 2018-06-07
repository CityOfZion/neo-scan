defmodule Neoscan.Repo.Migrations.Assets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add(:transaction_hash, :binary, primary_key: true)
      add(:admin, :string)
      add(:amount, :float)
      add(:name, {:array, :map})
      add(:owner, :string)
      add(:precision, :integer)
      add(:type, :string)
      add(:issued, :float)
      add(:time, :integer)
      add(:contract, :string)

      timestamps()
    end

    create(unique_index(:assets, [:transaction_hash, :name]))
    create(unique_index(:assets, [:contract]))
  end
end
