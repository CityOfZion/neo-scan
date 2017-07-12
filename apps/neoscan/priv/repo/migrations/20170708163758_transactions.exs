defmodule Neoscan.Repo.Migrations.Transactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :attributes, {:array, :string}
      add :net_fee, :string
      add :nonce, :integer
      add :scripts, {:array, :string}
      add :size, :integer
      add :sys_fee, :string
      add :txid, :string
      add :type, :string
      add :version, :integer
      add :vin, {:array, :string}
      add :vout, {:array, :string}
      add :block, references(:blocks, on_delete: :delete_all)

      timestamps()
    end

  end
end
