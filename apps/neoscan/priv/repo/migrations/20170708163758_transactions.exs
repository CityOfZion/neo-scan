defmodule Neoscan.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:block_hash, :binary)
      add(:block_height, :integer)

      add(:attributes, {:array, :map})
      add(:net_fee, :string)
      add(:scripts, {:array, :map})
      add(:script, :text)
      add(:size, :integer)
      add(:sys_fee, :string)
      add(:type, :string)
      add(:version, :integer)
      add(:vin, {:array, :map})

      add(:time, :integer)

      add(:nonce, :bigint)
      add(:claims, {:array, :map})
      add(:pubkey, :string)
      add(:asset, :map)
      add(:description, :text)
      add(:contract, :map)
      add(:descriptors, {:array, :map})

      add(:asset_moved, :string)

      timestamps()
    end

    create(index(:transactions, [:inserted_at]))
    create(index(:transactions, [:type]))
    create(index(:transactions, [:block_hash]))
  end
end
