defmodule Neoscan.Repo.Migrations.TxAbstracts do
  use Ecto.Migration

  def change do
    create table(:tx_abstracts) do
      add(:address_from, :string)
      add(:address_to, :string)
      add(:amount, :string)
      add(:block_height, :integer)
      add(:txid, :string)
      add(:asset, :string)
      add(:time, :integer)
      add(:check_hash, :string)

      timestamps()
    end

    create(index(:tx_abstracts, [:address_from]))
    create(index(:tx_abstracts, [:address_to]))
  end
end
