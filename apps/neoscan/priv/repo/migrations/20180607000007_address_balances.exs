defmodule Neoscan.Repo.Migrations.AddressBalances do
  use Ecto.Migration

  def change do
    create table(:address_balances, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
      add(:value, :float, null: false)

      timestamps()
    end

    # generate address history on vouts insertion (+)

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vouts() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.transaction_hash, NEW.asset_hash, NEW.value, NEW.block_time, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_history_from_vouts_trigger
      AFTER INSERT ON vouts FOR each row
      EXECUTE PROCEDURE generate_address_history_from_vouts();
    """

    # generate address history on vouts insert (-) if vin is already present

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vouts2() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
        SELECT NEW.address_hash, NEW.transaction_hash, NEW.asset_hash, NEW.value * -1.0, block_time, inserted_at, updated_at FROM vins
        WHERE vout_n = NEW.n and vout_transaction_hash = NEW.transaction_hash;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_history_from_vins_trigger
      AFTER INSERT ON vouts FOR each row
      EXECUTE PROCEDURE generate_address_history_from_vouts2();
    """

    # generate address history on vins insert (-) if vout is already present

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vins() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
        SELECT address_hash, NEW.transaction_hash, asset_hash, value * -1.0, NEW.block_time, NEW.inserted_at, NEW.updated_at FROM vouts
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

    # generate address balance from address history

    execute """
    CREATE OR REPLACE FUNCTION generate_address_balances_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_balances (address_hash, asset_hash, value, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.asset_hash, NEW.value, NEW.inserted_at, NEW.updated_at)
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

    # generate address summary from address history

    execute """
    CREATE OR REPLACE FUNCTION generate_address_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO addresses (hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.block_time, NEW.block_time, 0, NEW.inserted_at, NEW.updated_at)
        ON CONFLICT ON CONSTRAINT addresses_pkey DO
        UPDATE SET
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
