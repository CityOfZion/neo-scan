defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :confirmations, :integer
      add :hash, :string
      add :index, :bigint
      add :merkleroot, :string
      add :nextblockhash, :string
      add :nextconsensus, :string
      add :nonce, :string
      add :previousblockhash, :string
      add :script, {:map , :string}
      add :size, :integer
      add :time, :integer
      add :version, :integer
      add :tx_count, :integer

      add :total_sys_fee, :float
      add :total_net_fee, :float
      add :gas_generated, :float

      timestamps()
    end

    create index(:blocks, ["index DESC NULLS LAST", :hash], unique: true)

  end
end
