defmodule Neoscan.Repo.Migrations.AddressTransactions do
  use Ecto.Migration

  def change do
    create table(:address_transactions, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:transaction_hash, :binary, primary_key: true)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    create(index(:address_transactions, [:address_hash, :block_time]))

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
