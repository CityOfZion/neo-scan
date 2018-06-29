defmodule Neoscan.Repo.Migrations.AddressBalances do
  use Ecto.Migration

  def change do
    create table(:address_balances_cached, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
      add(:value, :float, null: false)

      timestamps()
    end

    create table(:address_balances_queue, primary_key: false) do
      add(:address_hash, :binary, null: false)
      add(:asset_hash, :binary, null: false)
      add(:value, :float, null: false)

      timestamps()
    end

    execute """
    CREATE OR REPLACE VIEW address_balances AS
    SELECT address_hash, asset_hash, SUM(value) as value, MIN(inserted_at) as inserted_at, MAX(updated_at) as updated_at
    FROM (
      SELECT * FROM address_balances_cached
      UNION ALL
      SELECT * FROM address_balances_queue
    ) combine
    GROUP BY address_hash, asset_hash;
    """

    execute """
    CREATE OR REPLACE FUNCTION address_balances_queue_flush()
          RETURNS TRIGGER
          LANGUAGE plpgsql
          AS $body$
          DECLARE
          v_updates int;
          v_prunes int;
          BEGIN
          IF NOT pg_try_advisory_xact_lock('address_balances_queue'::regclass::oid::bigint) THEN
               RAISE NOTICE 'skipping address balances queue flush';
               RETURN false;
          END IF;

          WITH
          perform_updates AS (
              INSERT INTO address_balances_cached
              SELECT address_hash, asset_hash, SUM(value) as value, MIN(inserted_at) as inserted_at,
                MAX(updated_at) as updated_at FROM address_balances_queue GROUP BY address_hash, asset_hash
              ON CONFLICT ON CONSTRAINT address_balances_cached_pkey DO
              UPDATE SET
                value = address_balances_cached.value + EXCLUDED.value,
                updated_at = GREATEST(address_balances_cached.updated_at, EXCLUDED.updated_at)
              RETURNING 1
          ),
          perform_prune AS (
              DELETE FROM address_balances_queue
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
    CREATE TRIGGER address_balances_queue_flush_trigger after
      INSERT ON address_balances_queue FOR each row
      WHEN (random() < 0.001)
      EXECUTE PROCEDURE address_balances_queue_flush();
    """
  end
end
