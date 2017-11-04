defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address, :string
      add :balance, :map
      add :time, :integer

      timestamps()
    end

    create index(:addresses, [:address], unique: true)
    create index(:addresses, ["inserted_at DESC NULLS LAST"])

  end
end
