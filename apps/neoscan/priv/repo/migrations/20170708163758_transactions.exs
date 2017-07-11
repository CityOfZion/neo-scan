defmodule Neoscan.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :attributes, :string
      add :blockhash, :string
      add :height, :string
      add :net_fee, :string
      add :scripts, :string
      add :size, :string
      add :sys_fee, :string
      add :time, :string
      add :txid, :string
      add :type, :string
      add :version, :string
      add :vin, :string
      add :vout, :string

      timestamps()
    end

  end
end
