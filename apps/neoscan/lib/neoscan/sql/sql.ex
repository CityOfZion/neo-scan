defmodule Neoscan.Sql do

  def add_tx(tx) do
    sql = "UPDATE addresses SET tx_ids = (
          CASE
              WHEN tx_ids IS NULL THEN '{}'::JSONB
              ELSE tx_ids
          END
        ) || $1 ::JSONB"
    Ecto.Adapters.SQL.query!(Neoscan.Repo, sql, [tx])
  end
  
end
