defmodule Neoscan.Repo.Migrations.AddAddressIndex do
  use Ecto.Migration

  def change do
    create(index(:addresses, [:updated_at]))
  end
end
