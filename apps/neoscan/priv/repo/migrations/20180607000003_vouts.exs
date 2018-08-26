defmodule Neoscan.Repo.Migrations.Vouts do
  use Ecto.Migration

  def change do

    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";";

    create table(:vouts, primary_key: false) do
      add(:transaction_hash, :binary, null: false, primary_key: true)
      add(:n, :integer, null: false, primary_key: true)
      add(:address_hash, :binary, null: false)
      add(:asset_hash, :binary, null: false)
      add(:value, :float, null: false)
      add(:block_time, :naive_datetime, null: false)

      add(:claimed, :boolean, null: false, default: false)
      add(:spent, :boolean, null: false, default: false)
      add(:start_block_index, :integer, null: false)
      add(:end_block_index, :integer)

      timestamps()
    end

    create(index(:vouts, [:transaction_hash]))

    #partial index is used to get unspent blocks
    create(index(:vouts, [:address_hash, :asset_hash]))
    create(index(:vouts, [:address_hash], where: "asset_hash = E'\\\\xC56F33FC6ECFCD0C225C4AB356FEE59390AF8560BE0E930FAEBE74A6DAFF7C9B' and claimed = false", name: "partial_vout_index"))
    create(index(:vouts, [:address_hash, :spent]))
    create(index(:vouts, [:address_hash, :claimed]))
    create(index(:vouts, [:address_hash, :claimed, :spent]))

    create table(:vouts_queue, primary_key: false) do
      add(:uuid, :uuid, null: false, primary_key: true)
      add(:vin_transaction_hash, :binary, null: true)
      add(:transaction_hash, :binary, null: false)
      add(:n, :integer, null: false)
      add(:claimed, :boolean, null: false, default: false)
      add(:spent, :boolean, null: false, default: false)
      add(:end_block_index, :integer)
      add(:block_time, :naive_datetime, null: false)
      timestamps()
    end

    execute """
      CREATE OR REPLACE FUNCTION flush_vouts_queue()
        RETURNS bool
        LANGUAGE plpgsql
        AS $body$
        DECLARE
            v_inserts int;
            v_updates int;
            v_prunes int;
        BEGIN
            IF NOT pg_try_advisory_xact_lock('vouts_queue'::regclass::oid::bigint) THEN
                 RAISE NOTICE 'skipping vouts_queue flush';
                 RETURN false;
            END IF;

            WITH
            selected_queue AS (
                SELECT vouts_queue.vin_transaction_hash, vouts_queue.transaction_hash, vouts_queue.n, vouts_queue.claimed,
                vouts_queue.spent, vouts_queue.end_block_index, vouts_queue.block_time,
                vouts_queue.inserted_at, vouts_queue.updated_at, vouts.address_hash, vouts.asset_hash, vouts.value
                FROM vouts_queue JOIN vouts USING (transaction_hash, n)
            ),
            aggregated_queue AS (
                SELECT transaction_hash, n, BOOL_OR(claimed) as claimed, BOOL_OR(spent) as spent, MAX(end_block_index) as end_block_index
                FROM selected_queue
                GROUP BY transaction_hash, n
            ),
            perform_updates AS (
                UPDATE vouts
                SET
                  claimed = vouts.claimed or aggregated_queue.claimed,
                  spent = vouts.spent or aggregated_queue.spent,
                  end_block_index = GREATEST(vouts.end_block_index, aggregated_queue.end_block_index)
                FROM aggregated_queue
                WHERE aggregated_queue.transaction_hash = vouts.transaction_hash and aggregated_queue.n = vouts.n
                RETURNING 1
            ),
            perform_inserts AS (
                INSERT INTO address_histories (address_hash, transaction_hash, asset_hash, value, block_time, inserted_at, updated_at)
                SELECT address_hash, vin_transaction_hash, asset_hash, value * -1.0, block_time, inserted_at, updated_at
                FROM selected_queue WHERE spent = true
                RETURNING 1
            ),
            perform_prune AS (
                DELETE FROM vouts_queue WHERE uuid IN (SELECT uuid FROM selected_queue)
                RETURNING 1
            )
            SELECT
                (SELECT count(*) FROM perform_updates) updates,
                (SELECT count(*) FROM perform_inserts) inserts,
                (SELECT count(*) FROM perform_prune) prunes
            INTO v_updates, v_inserts, v_prunes;

            RAISE NOTICE 'performed vouts_queue flush: % updates, % inserts, % prunes', v_updates, v_inserts, v_prunes;

            RETURN true;
        END;
        $body$;
    """

    execute """
      CREATE OR REPLACE FUNCTION flush_vouts_queue_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
      IF random() < 0.001 THEN
          PERFORM flush_vouts_queue();
      END IF;
      RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER vouts_queue_trigger
      AFTER INSERT ON vouts_queue
      FOR EACH ROW EXECUTE PROCEDURE flush_vouts_queue_trigger();
    """
  end
end
