defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address, :string
      add :tx_ids, {:array, :string}
      add :balance, :map


      timestamps()
    end

  end
end
