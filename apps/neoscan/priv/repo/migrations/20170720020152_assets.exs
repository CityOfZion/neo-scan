defmodule Neoscan.Repo.Migrations.Assets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :txid, :string





      timestamps()
    end
  end

  
end
