defmodule Neoscan.Repo.Migrations.Assets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add(:txid, :string)
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

    create(unique_index(:assets, [:txid, :name]))
    create(unique_index(:assets, [:contract]))
  end
end
