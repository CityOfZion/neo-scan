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
    SELECT name, sum(value) as value
    FROM (
    SELECT name, value
    FROM counters_cached
    UNION ALL
    SELECT name, value
    FROM counters_queue
    ) combine
    GROUP BY name;
    """

    execute """
    CREATE OR REPLACE FUNCTION counters_queue_flush()
          RETURNS TRIGGER
          LANGUAGE plpgsql
          AS $body$
          DECLARE
          v_updates int;
          v_prunes int;
          BEGIN
          IF NOT pg_try_advisory_xact_lock('counters_queue'::regclass::oid::bigint) THEN
               RAISE NOTICE 'skipping counters queue flush';
               RETURN false;
          END IF;

          WITH
          perform_updates AS (
              INSERT INTO counters_cached
              SELECT name, sum(value) FROM counters_queue GROUP BY name
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

          RAISE NOTICE 'performed queue (hourly) flush: % updates, % prunes', v_updates, v_prunes;
          RETURN NULL;
          END;
          $body$;
    """

    execute """
    CREATE TRIGGER counters_queue_flush_trigger after
      INSERT ON counters_queue FOR each row
      WHEN (random() < 0.001)
      EXECUTE PROCEDURE counters_queue_flush();
    """
  end
end
