defmodule Neoscan.Repo.Migrations.Counters do
  use Ecto.Migration

  def change do
    create table(:counters, primary_key: false) do
      add(:name, :string, primary_key: true)
      add(:value, :integer, null: false)
    end
  end
end
