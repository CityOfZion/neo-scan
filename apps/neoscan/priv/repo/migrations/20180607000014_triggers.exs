defmodule Neoscan.Repo.Migrations.Triggers do
  use Ecto.Migration

  def change do
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

    # generate vout updates based on vin

    execute """
    CREATE OR REPLACE FUNCTION generate_vout_updates_based_on_vins() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO vouts_queue (vin_transaction_hash, transaction_hash, n, claimed, spent, end_block_index, block_time, inserted_at, updated_at)
        VALUES (NEW.transaction_hash, NEW.vout_transaction_hash, NEW.vout_n, false, true, NEW.block_index, NEW.block_time, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_vout_updates_based_on_vins_trigger
      AFTER INSERT ON vins FOR each row
      EXECUTE PROCEDURE generate_vout_updates_based_on_vins();
    """

    # generate vout update based on claim insertion

    execute """
    CREATE OR REPLACE FUNCTION generate_vout_updates_based_on_claims() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO vouts_queue (transaction_hash, n, claimed, spent, end_block_index, block_time, inserted_at, updated_at)
        VALUES (NEW.vout_transaction_hash, NEW.vout_n, true, false, null, NEW.block_time, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_vout_updates_based_on_claims_trigger
      AFTER INSERT ON claims FOR each row
      EXECUTE PROCEDURE generate_vout_updates_based_on_claims();
    """

    # generate address summary from address history

    execute """
    CREATE OR REPLACE FUNCTION generate_address_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO addresses_queue (hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.block_time, NEW.block_time, 0, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_from_address_history_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_from_address_history();
    """

    # generate address balance from address history

    execute """
    CREATE OR REPLACE FUNCTION generate_address_balances_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_balances_queue (address_hash, asset_hash, value, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.asset_hash, NEW.value, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_balance_from_address_history_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_balances_from_address_history();
    """

    # generate address transaction balance from address history

    execute """
    CREATE OR REPLACE FUNCTION generate_address_transaction_balances_from_address_history() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_transaction_balances_queue (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.transaction_hash, NEW.asset_hash, NEW.value, NEW.block_time, NEW.inserted_at, NEW.updated_at);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_transaction_balances_from_address_history_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_transaction_balances_from_address_history();
    """

    # Generate address history from transfer

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_transfers() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_histories
        SELECT * FROM
        (VALUES (NEW.address_from, NEW.transaction_hash, NEW.contract, - NEW.amount, NEW.block_time, NEW.inserted_at, NEW.updated_at),
        (NEW.address_to, NEW.transaction_hash, NEW.contract, NEW.amount, NEW.block_time, NEW.inserted_at, NEW.updated_at)) as
        tmp (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
        WHERE address_hash != E'\\\\x00';
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_history_from_transfers_trigger
      AFTER INSERT ON transfers FOR each row
      EXECUTE PROCEDURE generate_address_history_from_transfers();
    """

    # Counters

    execute """
    CREATE OR REPLACE FUNCTION block_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO counters_queue (name, value) VALUES ('blocks', 1), ('transactions', NEW.tx_count - 1);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER block_counter_trigger
      AFTER INSERT ON blocks FOR each row
      EXECUTE PROCEDURE block_counter();
    """

    execute """
    CREATE OR REPLACE FUNCTION address_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO counters_queue (name, value) VALUES ('addresses', 1);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER address_counter_trigger
      AFTER INSERT ON addresses FOR each row
      EXECUTE PROCEDURE address_counter();
    """

    execute """
    CREATE OR REPLACE FUNCTION asset_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO counters (name, value)
        VALUES ('assets', 1)
        ON CONFLICT ON CONSTRAINT counters_pkey DO
        UPDATE SET
        value = counters.value + EXCLUDED.value;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER asset_counter_trigger
      AFTER INSERT ON assets FOR each row
      EXECUTE PROCEDURE asset_counter();
    """

    execute """
    CREATE OR REPLACE FUNCTION transaction_by_asset_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        IF EXISTS (
          SELECT 1 FROM address_transaction_balances
          WHERE asset_hash = NEW.asset_hash AND transaction_hash = NEW.transaction_hash
          OFFSET 1
        ) THEN
          RETURN NULL;
        END IF;
        
        INSERT INTO counters (name, value)
        VALUES ('transactions_by_asset_' || encode(NEW.asset_hash, 'hex'), 1)
        ON CONFLICT ON CONSTRAINT counters_pkey DO
        UPDATE SET
        value = counters.value + EXCLUDED.value;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER transaction_by_asset_counter_trigger
      AFTER INSERT ON address_transaction_balances FOR each row
      EXECUTE PROCEDURE transaction_by_asset_counter();
    """

    execute """
    CREATE OR REPLACE FUNCTION address_by_asset_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO counters (name, value)
        VALUES ('addresses_by_asset_' || encode(NEW.asset_hash, 'hex'), 1)
        ON CONFLICT ON CONSTRAINT counters_pkey DO
        UPDATE SET
        value = counters.value + EXCLUDED.value;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER address_by_asset_counter_trigger
      AFTER INSERT ON address_balances FOR each row
      EXECUTE PROCEDURE address_by_asset_counter();
    """

    # transactions

    execute """
    CREATE OR REPLACE FUNCTION generate_address_transactions_from_address_histories() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO address_transactions (address_hash, transaction_hash, block_time, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.transaction_hash, NEW.block_time, NEW.inserted_at, NEW.updated_at)
        ON CONFLICT ON CONSTRAINT address_transactions_pkey DO NOTHING;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_transactions_from_address_histories_trigger
      AFTER INSERT ON address_histories FOR each row
      EXECUTE PROCEDURE generate_address_transactions_from_address_histories();
    """

    execute """
    CREATE OR REPLACE FUNCTION generate_address_tx_count_from_address_transactions() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO addresses_queue (hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at)
        VALUES (NEW.address_hash, NEW.block_time, NEW.block_time, 1, now(), now());
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER generate_address_tx_count_from_address_transactions_trigger
      AFTER INSERT ON address_transactions FOR each row
      EXECUTE PROCEDURE generate_address_tx_count_from_address_transactions();
    """
  end
end
