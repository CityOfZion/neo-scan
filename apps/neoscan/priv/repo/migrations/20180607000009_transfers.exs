defmodule Neoscan.Repo.Migrations.Transfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add(:transaction_hash, :binary, null: false)
      add(:address_from, :binary, null: false)
      add(:address_to, :binary, null: false)
      add(:amount, :float, null: false)
      add(:contract, :binary, null: false)
      add(:block_index, :integer, null: false)
      add(:block_time, :naive_datetime, null: false)

      timestamps()
    end

    create(index(:transfers, [:transaction_hash]))

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
  end
end
