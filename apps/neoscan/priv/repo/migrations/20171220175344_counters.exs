defmodule Neoscan.Repo.Migrations.Counters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :total_blocks, :integer
      add :total_transactions, :integer
      add :total_addresses, :integer
      add :contract_transactions, :integer
      add :invocation_transactions, :integer
      add :miner_transactions, :integer
      add :claim_transactions, :integer
      add :publish_transactions, :integer
      add :issue_transactions, :integer
      add :register_transactions, :integer
      add :enrollment_transactions, :integer
      add :assets_transactions, {:map, :integer}
      add :assets_addresses, {:map, :integer}

      timestamps()
    end
  end
end
