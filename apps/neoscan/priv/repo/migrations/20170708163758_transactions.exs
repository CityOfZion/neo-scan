defmodule Neoscan.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :attributes, {:array, :map}
      add :net_fee, :string
      add :scripts, {:array, :map}
      add :size, :integer
      add :sys_fee, :string
      add :txid, :string
      add :type, :string
      add :version, :integer
      add :vin, {:array, :map}
      add :vout, {:array, :map}

      add :time, :integer
      add :block_hash, :string
      add :block_height, :integer

      add :nonce, :bigint
      add :claims, {:array, :map}
      add :pubkey, :string
      add :asset, {:array, :map}
      add :description, :string
      add :contract, :string

      add :block_id, references(:blocks, on_delete: :delete_all)

      timestamps()
    end

  end
end
