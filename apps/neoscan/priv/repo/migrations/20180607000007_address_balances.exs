defmodule Neoscan.Repo.Migrations.AddressBalances do
  use Ecto.Migration

  def change do
    create table(:address_balances, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:asset, :binary, primary_key: true)
      add(:value, :float, null: false)

      timestamps()
    end

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vouts() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories (address_hash, asset, value, block_time, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.asset, NEW.value, NEW.block_time, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;

    """

    execute """
      CREATE TRIGGER generate_address_history_from_vouts_trigger
      AFTER INSERT ON vouts FOR each row
      EXECUTE PROCEDURE generate_address_history_from_vouts();
    """
  end
end
