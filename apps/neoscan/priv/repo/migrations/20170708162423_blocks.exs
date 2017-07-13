defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :confirmations, :integer
      add :hash, :string
      add :index, :integer
      add :merkleroot, :string
      add :nextblockhash, :string
      add :nextconsensus, :string
      add :nonce, :string
      add :previousblockhash, :string
      add :script, {:map , :string}
      add :size, :integer
      add :time, :integer
      add :version, :integer

      timestamps()
    end

  end
end
