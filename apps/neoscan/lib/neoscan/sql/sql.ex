defmodule Neoscan.Sql do

  def add_tx(hash, tx) do
    sql = "UPDATE addresses SET tx_ids = (
          CASE
              WHEN tx_ids IS NULL THEN '{}'::JSONB
              ELSE tx_ids
          END
        ) || $2 ::JSONB WHERE address = $1;"
    Ecto.Adapters.SQL.query!(Neoscan.Repo, sql, [hash, tx])
  end

end
