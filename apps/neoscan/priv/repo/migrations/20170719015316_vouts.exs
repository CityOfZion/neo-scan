defmodule Neoscan.Repo.Migrations.Vouts do
  use Ecto.Migration

  def change do
    create table(:vouts) do
      add :asset, :string
      add :address, :string
      add :n, :integer
      add :value, :float

      add :transaction_id, references(:transactions, on_delete: :delete_all)

      timestamps()
    end
  end
end
