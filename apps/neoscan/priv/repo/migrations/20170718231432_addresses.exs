defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :address, :string
      add :tx_ids, {:array, :string}
      add :balance, {:array, :map}
      add :claimed, {:array, :string}


      timestamps()
    end

    create unique_index(:addresses, [:address])

  end
end
