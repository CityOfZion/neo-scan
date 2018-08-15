defmodule Neoscan.Repo.Migrations.Counters do
  use Ecto.Migration

  def change do
    create table(:counters_cached, primary_key: false) do
      add(:name, :string, primary_key: true)
      add(:value, :integer, null: false)
    end

    create table(:counters_queue, primary_key: false) do
      add(:name, :string, null: false)
      add(:value, :integer, null: false)
    end

    execute """
    CREATE OR REPLACE VIEW counters AS
      SELECT name, SUM(value) AS value
      FROM (
        SELECT name, value FROM counters_queue
         UNION ALL
        SELECT name, value FROM counters_cached
          ) combine
      GROUP BY name;

    """

    execute """
      CREATE OR REPLACE FUNCTION flush_counters_queue()
        RETURNS bool
        LANGUAGE plpgsql
        AS $body$
        DECLARE
            v_inserts int;
            v_updates int;
            v_prunes int;
        BEGIN
            IF NOT pg_try_advisory_xact_lock('counters_queue'::regclass::oid::bigint) THEN
                 RAISE NOTICE 'skipping counters_queue flush';
                 RETURN false;
            END IF;

            WITH
            aggregated_queue AS (
                SELECT name, SUM(value) AS value
                FROM counters_queue
                GROUP BY name
            ),
            perform_updates AS (
                INSERT INTO counters_cached
                SELECT name, value
                FROM aggregated_queue
                ON CONFLICT ON CONSTRAINT counters_cached_pkey DO
                UPDATE SET value = counters_cached.value + EXCLUDED.value
                RETURNING 1
            ),
            perform_prune AS (
                DELETE FROM counters_queue
                RETURNING 1
            )
            SELECT
                (SELECT count(*) FROM perform_updates) updates,
                (SELECT count(*) FROM perform_prune) prunes
            INTO v_updates, v_prunes;

            RAISE NOTICE 'performed counters_queue flush: % updates, % prunes', v_updates, v_prunes;

            RETURN true;
        END;
        $body$;
    """

    execute """
      CREATE OR REPLACE FUNCTION flush_counters_queue_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
      IF random() < 0.001 THEN
          PERFORM flush_counters_queue();
      END IF;
      RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER counters_queue_trigger
      AFTER INSERT ON counters_queue
      FOR EACH ROW EXECUTE PROCEDURE flush_counters_queue_trigger();
    """
  end
end
