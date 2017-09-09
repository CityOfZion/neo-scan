defmodule Neoscan.Sql do

  #deprecated
  #TODO update to append claims instead of tx
  def add_tx(_changes, hash, tx_ids) do
    sql = "UPDATE addresses SET tx_ids = (
          CASE
              WHEN tx_ids IS NULL THEN '{}'::JSONB
              ELSE tx_ids
          END
        ) || $2 ::JSONB WHERE address = $1;"
    Ecto.Adapters.SQL.query(Neoscan.Repo, sql, [hash, tx_ids])
  end

end
