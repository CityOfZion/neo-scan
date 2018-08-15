defmodule Neoscan.Repo.Migrations.Addresses do
  use Ecto.Migration

  def change do
    create table(:addresses_cached, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:first_transaction_time, :naive_datetime, null: false)
      add(:last_transaction_time, :naive_datetime, null: false)
      add(:tx_count, :integer, null: false, default: 1)

      timestamps()
    end

    create table(:addresses_queue, primary_key: false) do
      add(:hash, :binary, null: false)
      add(:first_transaction_time, :naive_datetime, null: false)
      add(:last_transaction_time, :naive_datetime, null: false)
      add(:tx_count, :integer, null: false, default: 1)

      timestamps()
    end

    create(index(:addresses_cached, [:last_transaction_time]))

    execute """
    CREATE OR REPLACE VIEW addresses AS
      SELECT hash, MIN(first_transaction_time) as first_transaction_time,
        MAX(last_transaction_time) as last_transaction_time,
        SUM(tx_count) as tx_count,
        MIN(inserted_at) as inserted_at,
        MAX(updated_at) as updated_at
      FROM (
        SELECT hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at FROM addresses_queue
         UNION ALL
        SELECT hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at FROM addresses_cached
          ) combine
      GROUP BY hash;

    """

    execute """
      CREATE OR REPLACE FUNCTION flush_addresses_queue()
        RETURNS bool
        LANGUAGE plpgsql
        AS $body$
        DECLARE
            v_inserts int;
            v_updates int;
            v_prunes int;
        BEGIN
            IF NOT pg_try_advisory_xact_lock('addresses_queue'::regclass::oid::bigint) THEN
                 RAISE NOTICE 'skipping addresses_queue flush';
                 RETURN false;
            END IF;

            WITH
            aggregated_queue AS (
                SELECT hash, MIN(first_transaction_time) as first_transaction_time,
                MAX(last_transaction_time) as last_transaction_time,
                SUM(tx_count) as tx_count,
                MIN(inserted_at) as inserted_at,
                MAX(updated_at) as updated_at
                FROM addresses_queue
                GROUP BY hash
            ),
            perform_updates AS (
                INSERT INTO addresses_cached
                SELECT hash, first_transaction_time, last_transaction_time, tx_count, inserted_at, updated_at
                FROM aggregated_queue
                ON CONFLICT ON CONSTRAINT addresses_cached_pkey DO
                UPDATE SET
                  first_transaction_time = LEAST(addresses_cached.first_transaction_time, EXCLUDED.first_transaction_time),
                  last_transaction_time = GREATEST(addresses_cached.last_transaction_time, EXCLUDED.last_transaction_time),
                  tx_count = addresses_cached.tx_count + EXCLUDED.tx_count,
                  updated_at = GREATEST(addresses_cached.updated_at, EXCLUDED.updated_at)
                RETURNING 1
            ),
            perform_prune AS (
                DELETE FROM addresses_queue
                RETURNING 1
            )
            SELECT
                (SELECT count(*) FROM perform_updates) updates,
                (SELECT count(*) FROM perform_prune) prunes
            INTO v_updates, v_prunes;

            RAISE NOTICE 'performed addresses_queue flush: % updates, % prunes', v_updates, v_prunes;

            RETURN true;
        END;
        $body$;
    """

    execute """
      CREATE OR REPLACE FUNCTION flush_addresses_queue_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
      IF random() < 0.001 THEN
          PERFORM flush_addresses_queue();
      END IF;
      RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER addresses_queue_trigger
      AFTER INSERT ON addresses_queue
      FOR EACH ROW EXECUTE PROCEDURE flush_addresses_queue_trigger();
    """
  end
end
