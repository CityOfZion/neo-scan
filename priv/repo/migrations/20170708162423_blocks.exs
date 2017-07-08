defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks) do
      add :hash, :string
      add :height, :string
      add :merkleroot, :string
      add :nextminer, :string
      add :nonce, :string
      add :previousblockhash, :string
      add :script, :map
      add :size, :string
      add :time, :string
      add :version, :string

      timestamps()
    end

  end
end
