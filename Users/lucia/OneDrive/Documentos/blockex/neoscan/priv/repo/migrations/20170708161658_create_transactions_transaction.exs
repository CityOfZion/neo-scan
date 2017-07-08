defmodule Neoscan.Repo.Migrations.CreateNeoscan.Transactions.Transaction do
  use Ecto.Migration

  def change do
    create table(:transactions_transactions) do
      add :height, :string
      add :blockhash, :string
      add :time, :string
      add :txid, :string
      add :size, :string
      add :type, :string
      add :version, :string
      add :attributes, :string
      add :vin, :string
      add :vout, :string
      add :sys_fee, :string
      add :net_fee, :string
      add :scripts, :string

      timestamps()
    end

  end
end
