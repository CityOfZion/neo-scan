defmodule Neoscan.Repo.Migrations.Transfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add(:address_from, :string)
      add(:address_to, :string)
      add(:amount, :float)
      add(:block_height, :integer)
      add(:txid, :string)
      add(:contract, :string)
      add(:time, :integer)

      timestamps()
    end

    create(index(:transfers, [:txid]))
    create(index(:transfers, [:address_from]))
    create(index(:transfers, [:address_to]))
    create(index(:transfers, [:contract]))
  end
end
