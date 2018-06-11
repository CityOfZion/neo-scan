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

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vins() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories (address_hash, asset, value, block_time, inserted_at, updated_at)
        SELECT address_hash, asset, value * -1.0, NEW.block_time, NEW.inserted_at, NEW.updated_at FROM vouts
        WHERE n = NEW.vout_n and transaction_hash = NEW.vout_transaction_hash;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_history_from_vins_trigger
      AFTER INSERT ON vins FOR each row
      EXECUTE PROCEDURE generate_address_history_from_vins();
    """

    execute """
    CREATE OR REPLACE FUNCTION generate_address_balances_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_balances (address_hash, asset, value, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.asset, NEW.value, NEW.inserted_at, NEW.updated_at)
        ON CONFLICT ON CONSTRAINT address_balances_pkey DO
        UPDATE SET
        value = address_balances.value + EXCLUDED.value,
        updated_at = EXCLUDED.updated_at;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_balance_from_address_history_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_balances_from_address_history();
    """

    execute """
    CREATE OR REPLACE FUNCTION generate_address_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO addresses (hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.block_time, NEW.block_time, 1, NEW.inserted_at, NEW.updated_at)
        ON CONFLICT ON CONSTRAINT addresses_pkey DO
        UPDATE SET
        tx_count = addresses.tx_count + EXCLUDED.tx_count,
        first_transaction_time = LEAST(addresses.first_transaction_time, EXCLUDED.first_transaction_time),
        last_transaction_time = GREATEST(addresses.last_transaction_time, EXCLUDED.last_transaction_time),
        updated_at = EXCLUDED.updated_at;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_from_address_history_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_from_address_history();
    """
  end
end
