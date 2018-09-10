defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:index, :integer, null: false)
      add(:merkle_root, :binary, null: false)
      add(:next_consensus, :binary, null: false)
      add(:nonce, :binary, null: false)
      add(:script, {:map, :string}, null: false)
      add(:size, :integer, null: false)
      add(:time, :naive_datetime, null: false)
      add(:version, :integer, null: false)
      add(:tx_count, :integer, null: false)
      add(:total_sys_fee, :decimal, null: false)
      add(:total_net_fee, :decimal, null: false)
      add(:gas_generated, :decimal, null: false)

      timestamps()
    end

    create(unique_index(:blocks, [:index]))
  end
end
