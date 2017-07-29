defmodule Neoscan.Repo.Migrations.Data do
  use Ecto.Migration

  def change do
    create table(:data) do
      add :height, :integer
      add :block, :map
    end

    create unique_index(:data, [:height])

  end
end
