defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add(:confirmations, :integer)
      add :hash, :string, primary_key: true
      add(:index, :bigint)
      add(:merkleroot, :string)
      add(:nextblockhash, :string)
      add(:nextconsensus, :string)
      add(:nonce, :string)
      add(:previousblockhash, :string)
      add(:script, {:map, :string})
      add(:size, :integer)
      add(:time, :integer)
      add(:version, :integer)
      add(:tx_count, :integer)
      add(:total_sys_fee, :float)
      add(:total_net_fee, :float)
      add(:gas_generated, :float)

      timestamps()
    end

    create(unique_index(:blocks, ["index DESC NULLS LAST"]))
    create(unique_index(:blocks, [:index]))
    create(unique_index(:blocks, [:hash]))
  end
end
