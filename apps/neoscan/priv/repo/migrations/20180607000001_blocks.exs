defmodule Neoscan.Repo.Migrations.Blocks do
  use Ecto.Migration

  def change do
    create table(:blocks, primary_key: false) do
      add(:hash, :binary, primary_key: true)
      add(:index, :integer, null: false)
      add(:merkle_root, :binary, null: false)
      add(:next_consensus, :binary, null: false)
      add(:nonce, :binary, null: false)
      add(:script, {:map, :string}, null: false)
      add(:size, :integer, null: false)
      add(:time, :naive_datetime, null: false)
      add(:version, :integer, null: false)
      add(:tx_count, :integer, null: false)
      add(:total_sys_fee, :decimal, null: false)
      add(:total_net_fee, :decimal, null: false)
      add(:cumulative_sys_fee, :decimal, null: false)
      add(:gas_generated, :decimal, null: false)

      timestamps()
    end

    create(unique_index(:blocks, [:index]))

    create table(:blocks_queue, primary_key: false) do
      add(:index, :integer, primary_key: true)
      add(:total_sys_fee, :decimal, null: false)
    end

    create table(:blocks_meta, primary_key: false) do
      add(:id, :integer, primary_key: true)
      add(:index, :integer, null: true)
      add(:cumulative_sys_fee, :decimal, null: true)
    end

    execute """
      CREATE OR REPLACE FUNCTION flush_blocks_queue()
        RETURNS bool
        LANGUAGE plpgsql
        AS $body$
        DECLARE
            v_inserts int;
            v_updates int;
            v_prunes int;
        BEGIN
            IF NOT pg_try_advisory_xact_lock('blocks_queue'::regclass::oid::bigint) THEN
                 RAISE NOTICE 'skipping blocks_queue flush';
                 RETURN false;
            END IF;

            WITH
            current_values AS (
              SELECT COALESCE((SELECT index FROM blocks_meta WHERE id = 1), -1) AS index,
                COALESCE((SELECT cumulative_sys_fee FROM blocks_meta WHERE id = 1), 0) AS cumulative_sys_fee
            ),
            integral_queue AS (
              SELECT index, total_sys_fee, (sum(total_sys_fee) OVER (ORDER BY index) + (SELECT cumulative_sys_fee FROM current_values)) AS cumulative_sys_fee,
                (CASE WHEN (index - LAG(index) OVER ()) = 1 THEN 0 ELSE 1 END) AS limiter,
                first_value(index) OVER (ORDER BY INDEX)
              FROM blocks_queue WHERE index >= 0
            ),
            integral_integral_queue AS (
              SELECT index, cumulative_sys_fee, (SUM(limiter) OVER (ORDER BY index)) AS limiter, first_value FROM integral_queue
            ),
            to_update_queue AS (
              SELECT index, cumulative_sys_fee FROM integral_integral_queue WHERE limiter = 1 AND first_value = (SELECT index FROM current_values) + 1
            ),
            perform_updates AS (
                UPDATE blocks
                  SET cumulative_sys_fee = to_update_queue.cumulative_sys_fee
                  FROM to_update_queue
                  WHERE blocks.index = to_update_queue.index
                RETURNING 1
            ),
            perform_insert AS (
              INSERT INTO blocks_meta (id, index, cumulative_sys_fee)
              VALUES (1, (SELECT index FROM to_update_queue ORDER BY index DESC LIMIT 1),
                (SELECT cumulative_sys_fee FROM to_update_queue ORDER BY index DESC LIMIT 1))
              ON CONFLICT ON CONSTRAINT blocks_meta_pkey DO
                UPDATE SET
                  index = coalesce(EXCLUDED.index, blocks_meta.index),
                  cumulative_sys_fee = coalesce(EXCLUDED.cumulative_sys_fee, blocks_meta.cumulative_sys_fee)
              RETURNING 1
            ),
            perform_prune AS (
                DELETE FROM blocks_queue WHERE index in (SELECT index FROM to_update_queue)
                RETURNING 1
            )
            SELECT
                (SELECT count(*) FROM perform_updates) updates,
                (SELECT count(*) FROM perform_insert) inserts,
                (SELECT count(*) FROM perform_prune) prunes
            INTO v_updates, v_inserts, v_prunes;

            RAISE NOTICE 'performed address_balances_queue flush: % updates, % prunes', v_updates, v_prunes;

            RETURN true;
        END;
        $body$;
    """

    execute """
      CREATE OR REPLACE FUNCTION flush_blocks_queue_trigger() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
      IF random() < 0.01 THEN
          PERFORM flush_blocks_queue();
      END IF;
      RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER blocks_queue_trigger
      AFTER INSERT ON blocks_queue
      FOR EACH ROW EXECUTE PROCEDURE flush_blocks_queue_trigger();
    """
  end
end
