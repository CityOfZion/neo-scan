defmodule Neoscan.Repo.Migrations.Counters do
  use Ecto.Migration

  def change do
    create table(:counters, primary_key: false) do
      add(:name, :string, primary_key: true)
      add(:value, :integer, null: false)
    end

    execute """
    CREATE OR REPLACE FUNCTION block_counter() RETURNS TRIGGER LANGUAGE plpgsql AS $body$
      BEGIN
        INSERT INTO counters (name, value)
        VALUES ('blocks', 1), ('transactions', NEW.tx_count)
        ON CONFLICT ON CONSTRAINT counters_pkey DO
        UPDATE SET
        value = counters.value + EXCLUDED.value;
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
        INSERT INTO counters (name, value)
        VALUES ('addresses', 1)
        ON CONFLICT ON CONSTRAINT counters_pkey DO
        UPDATE SET
        value = counters.value + EXCLUDED.value;
        RETURN NULL;
      END;
      $body$;
    """

    execute """
      CREATE TRIGGER address_counter_trigger
      AFTER INSERT ON addresses FOR each row
      EXECUTE PROCEDURE address_counter();
    """
  end
end
