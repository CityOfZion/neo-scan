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

    # generate address history on vouts insert (-) if vin is already present

    execute """
    CREATE OR REPLACE FUNCTION generate_address_history_from_vouts2() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        UPDATE vouts SET spent = (EXISTS(SELECT 1 FROM vins
          WHERE vout_n = NEW.n AND vout_transaction_hash = NEW.transaction_hash)),
          end_block_index = (SELECT block_index FROM vins
          WHERE vout_n = NEW.n AND vout_transaction_hash = NEW.transaction_hash),
          claimed = (EXISTS(SELECT 1 FROM claims
          WHERE vout_n = NEW.n AND vout_transaction_hash = NEW.transaction_hash))
          WHERE n = NEW.n AND transaction_hash = NEW.transaction_hash;

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
        UPDATE vouts SET spent = true, end_block_index = NEW.block_index
          WHERE n = NEW.vout_n and transaction_hash = NEW.vout_transaction_hash;

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

    # toggle vout claimed on claim insertion

    execute """
    CREATE OR REPLACE FUNCTION toggle_vout_claimed_on_claim_insertion() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        UPDATE vouts SET claimed = true WHERE n = NEW.vout_n and transaction_hash = NEW.vout_transaction_hash;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER toggle_vout_claimed_on_claim_insertion_trigger
      AFTER INSERT ON claims FOR each row
      EXECUTE PROCEDURE toggle_vout_claimed_on_claim_insertion();
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
        INSERT INTO counters_queue (name, value)
        VALUES ('blocks', 1), ('transactions', NEW.tx_count - 1);
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
        INSERT INTO counters_queue (name, value)
        VALUES ('addresses', 1);
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER address_counter_trigger
      AFTER INSERT ON addresses FOR each row
      EXECUTE PROCEDURE address_counter();
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
        UPDATE addresses SET tx_count = addresses.tx_count + 1 WHERE hash = NEW.address_hash;
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
