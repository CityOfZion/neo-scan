defmodule Neoscan.Repo.Migrations.Histories do
  use Ecto.Migration

  def change do
    create table(:histories) do
      add :address_hash, :string
      add :balance, :map
      add :block_height, :integer
      add :txid, :string

      add :address_id, references(:addresses, on_delete: :delete_all)

      timestamps()
    end

    create index(:histories, [:address_hash])
    create index(:histories, [:address_id])

  end
end
