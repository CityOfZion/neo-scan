defmodule Neoscan.Repo.Migrations.AddressTransactionBalances do
  use Ecto.Migration

  def change do
    create table(:address_transaction_balances, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:transaction_hash, :binary, primary_key: true)
      add(:asset_hash, :binary, primary_key: true)
      add(:value, :float, null: false)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    create(index(:address_transaction_balances, [:address_hash, :block_time]))
    create(index(:address_transaction_balances, [:transaction_hash]))
    create(index(:address_transaction_balances, [:transaction_hash, :asset_hash]))

    create table(:address_transaction_balances_queue, primary_key: false) do
      add(:uuid, :uuid, null: false)
      add(:address_hash, :binary, null: false)
      add(:transaction_hash, :binary, null: false)
      add(:asset_hash, :binary, null: false)
      add(:value, :float, null: false)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    execute """
      CREATE OR REPLACE FUNCTION flush_address_transaction_balances_queue()
        RETURNS bool
        LANGUAGE plpgsql
        AS $body$
        DECLARE
            v_inserts int;
            v_updates int;
            v_prunes int;
        BEGIN
            IF NOT pg_try_advisory_xact_lock('address_transaction_balances_queue'::regclass::oid::bigint) THEN
                 RAISE NOTICE 'skipping address_transaction_balances_queue flush';
                 RETURN false;
            END IF;

            WITH
            selected_queue AS (
                SELECT * FROM address_transaction_balances_queue
            ),
            aggregated_queue AS (
                SELECT address_hash, transaction_hash, asset_hash, SUM(value) as value, MIN(block_time) as block_time, MIN(inserted_at) as inserted_at, MAX(updated_at) as updated_at
                FROM selected_queue
                GROUP BY address_hash, transaction_hash, asset_hash
            ),
            perform_updates AS (
                INSERT INTO address_transaction_balances
                SELECT address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at
                FROM aggregated_queue
                ON CONFLICT ON CONSTRAINT address_transaction_balances_pkey DO
                UPDATE SET
                  value = address_transaction_balances.value + EXCLUDED.value,
                  updated_at = GREATEST(address_transaction_balances.updated_at, EXCLUDED.updated_at)
                RETURNING 1
            ),
            perform_prune AS (
                DELETE FROM address_transaction_balances_queue WHERE uuid IN (SELECT uuid FROM selected_queue)
                RETURNING 1
            )
            SELECT
                (SELECT count(*) FROM perform_updates) updates,
                (SELECT count(*) FROM perform_prune) prunes
            INTO v_updates, v_prunes;

            RAISE NOTICE 'performed address_transaction_balances_queue flush: % updates, % prunes', v_updates, v_prunes;

            RETURN true;
        END;
        $body$;
    """

    execute """
      CREATE OR REPLACE FUNCTION flush_address_transaction_balances_queue_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
      IF random() < 0.001 THEN
          PERFORM flush_address_transaction_balances_queue();
      END IF;
      RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER address_transaction_balances_queue_trigger
      AFTER INSERT ON address_transaction_balances_queue
      FOR EACH ROW EXECUTE PROCEDURE flush_address_transaction_balances_queue_trigger();
    """
  end
end
