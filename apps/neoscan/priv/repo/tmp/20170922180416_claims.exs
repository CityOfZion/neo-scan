defmodule Neoscan.Repo.Migrations.Claims do
  use Ecto.Migration

  def change do
    create table(:claims) do
      add(:address_hash, :string)
      add(:txids, {:array, :string})
      add(:asset, :string)
      add(:amount, :float)

      add(:block_height, :integer)
      add(:time, :integer)

      add(:address_id, references(:addresses, on_delete: :delete_all))
      timestamps()
    end

    create(index(:claims, [:address_id]))
  end
end
