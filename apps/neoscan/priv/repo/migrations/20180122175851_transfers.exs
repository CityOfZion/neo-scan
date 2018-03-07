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
      add(:check_hash, :string)

      add(:block_id, references(:blocks, on_delete: :delete_all))

      timestamps()
    end

    create(index(:transfers, [:txid]))
    create(index(:transfers, [:address_from]))
    create(index(:transfers, [:address_to]))
    create(index(:transfers, [:contract]))
    create(index(:transfers, [:block_id]))
    create(index(:transfers, [:check_hash]))
  end
end
