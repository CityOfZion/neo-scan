defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address, :string
      add :tx_ids, :map
      add :balance, :map

      timestamps()
    end

    create index(:addresses, [:address], unique: true)

  end
end
