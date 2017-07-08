defmodule Neoscan.Repo.Migrations.CreateNeoscan.Blocks.Block do
  use Ecto.Migration

  def change do
    create table(:blocks_blocks) do
      add :hash, :string
      add :size, :string
      add :version, :string
      add :previousblockhash, :string
      add :merkleroot, :string
      add :time, :string
      add :height, :string
      add :nonce, :string
      add :nextminer, :string
      add :script, :map

      timestamps()
    end

  end
end
