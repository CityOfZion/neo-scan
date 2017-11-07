defmodule Neoscan.Repair do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.Addresses
  alias Neoscan.Transactions
  alias Neoscan.Transactions.Transaction
  alias Neoscan.Blocks.Block
  alias Neoscan.Vouts
  alias Neoscan.Vouts.Vout
  alias NeoscanSync.Blockchain
  alias NeoscanSync.HttpCalls
  alias NeoscanSync.Consumer

  #trigger repair if information is missing
  def repair_missing([], root) do
    missing = Enum.map(
      root,
      fn %{"txid" => txid} -> String.slice(to_string(txid), -64..-1) end
    )
    get_missing(missing, root)
  end
  def repair_missing(result, root) do
    missing = Enum.map(
                root,
                fn %{"txid" => txid} -> String.slice(to_string(txid), -64..-1)
                end
              ) -- Enum.map(
                result,
                fn %{:txid => txid} -> txid end
              )
    get_missing(missing, root)
  end

  #get missing information
  def get_missing(missing, root) do
    tuples = Enum.map(
               missing,
               fn txid -> get_transaction(txid) end
             )
             |> check_missing()

    get_missing_blocks(tuples)
    |> add_missing_transactions(tuples)
    |> add_missing_vouts(tuples)
    |> fetch_missing_vouts(root)
  end

  def get_transaction(txid) do
    transaction = Blockchain.get_transaction(HttpCalls.url(1), txid)
    case transaction do
      {:ok, _tx} ->
        transaction
      _ ->
        get_transaction(txid)
    end
  end

  #return the tuple list, specifying each missing entity
  def check_missing(transactions) do
    Enum.map(
      transactions,
      fn {:ok, %{"blockhash" => block_hash} = transaction} ->
        check_if_block_exists(
          String.slice(to_string(block_hash), -64..-1),
          transaction
        )
      end
    )
  end

  #fetch vouts again after reparing
  def fetch_missing_vouts(_result, root) do
    lookups = Enum.map(
      root,
      &"#{String.slice(to_string(&1["txid"]), -64..-1)}#{&1["vout"]}"
    ) #sometimes "0x" is prepended to hashes

    query = from e in Vout,
                 where: e.query in ^lookups,
                 select: struct(
                   e,
                   [:asset, :address_hash, :n, :value, :txid, :query, :id]
                 )

    Repo.all(query)
    |> Vouts.verify_vouts(lookups, root)
  end

  #check if block exist and create tuple,
  # otherwise route forward for transaction verification
  def check_if_block_exists(hash, transaction) do
    query = from e in Block,
                 where: e.hash == ^hash,
                 select: e
    case Repo.all(query)
         |> List.first() do
      nil ->
        {:block_missing, transaction}
      block ->
        check_if_transaction_exists(block, transaction)
    end
  end

  #verify if the transaction exists in the DB
  def check_if_transaction_exists(block, transaction) do
    txid = String.slice(to_string(transaction["txid"]), -64..-1)
    query = from t in Transaction,
                 where: t.txid == ^txid,
                 select: t
    case Repo.all(query)
         |> List.first() do
      nil ->
        {:transaction_missing, {block, transaction}}
      db_transaction ->
        check_if_vouts_exists(db_transaction, transaction)
    end
  end

  #Verify if vouts exists in the DB
  def check_if_vouts_exists(db_transaction, transaction) do
    query = from v in Vout,
                 where: v.transaction_id == ^db_transaction.id,
                 select: v

    db_vouts = Repo.all(query)

    missing = if db_vouts == [] do
      Enum.map(transaction["vout"], fn %{"n" => n} -> n end)
    else
      Enum.map(transaction["vout"], fn %{"n" => n} -> n end) -- Enum.map(
        db_vouts,
        fn %{:n => n} -> n end
      )
    end

    {
      :vouts_missing,
      {
        db_transaction,
        Enum.filter(transaction["vout"], fn %{"n" => n} -> n in missing end)
      }
    }
  end

  #get the missing blocks in the verification tuples
  def get_missing_blocks(transaction_tuples) do
    case Enum.any?(
           transaction_tuples,
           fn {key, _value} -> key == :block_missing end
         ) do
      true ->
        Enum.filter(
          transaction_tuples,
          fn {key, _transaction} -> key == :block_missing end
        )
        |> Enum.group_by(fn {_key, transaction} -> transaction["blockhash"] end)
        |> Map.keys
        |> Enum.each(fn hash -> get_and_add_missing_block(hash) end)
      false ->
        :ok
    end
  end

  #get a missing block from the node client
  def get_and_add_missing_block(hash) do
    case Blockchain.get_block_by_hash(HttpCalls.url(1), hash) do
      {:ok, block} ->
        Consumer.add_block(block)
      _ ->
        get_and_add_missing_block(hash)
    end
  end

  #adds missing transactions after verifying missing blocks
  def add_missing_transactions(:ok, tuples) do
    case Enum.any?(
           tuples,
           fn {key, _value} -> key == :transaction_missing end
         ) do
      true ->
        Enum.filter(tuples, fn {key, _tuple} -> key == :transaction_missing end)
        |> Enum.map(fn {_key, {block, transaction}} -> {block, transaction} end)
        |> Enum.group_by(fn {block, _transaction} -> block end)
        |> Map.to_list
        |> Enum.map(
             fn {block, transaction_tuples} ->
               {block, filter_tuples(transaction_tuples)} end
           )
        |> Enum.map(
             fn {block, transaction_list} ->
               Transactions.create_transactions(block, transaction_list) end
           )
        |> Enum.uniq
      false ->
        [{:ok, "Created"}]
    end
  end
  def add_missing_transactions(_, _tuples) do
    raise "error fetching and adding missing blocks"
  end

  #adds missing vouts after verifying missing blocks and transactions
  def add_missing_vouts(list, tuples) when list == [{:ok, "Created"}] do
    Enum.filter(tuples, fn {key, _tuple} -> key == :vouts_missing end)
    |> Enum.map(
         fn {_key, {db_transaction, vouts}} -> {db_transaction, vouts} end
       )
    |> Enum.group_by(fn {db_transaction, _transaction} -> db_transaction end)
    |> Map.to_list
    |> Enum.map(
         fn {db_transaction, vouts_tuple} ->
           {db_transaction, filter_tuples(vouts_tuple)} end
       )
    |> Enum.map(
         fn {db_transaction, vouts} ->
           address_list = Addresses.get_transaction_addresses(
             [],
             vouts,
             db_transaction.time,
             nil
           )
           Vouts.create_vouts(db_transaction, vouts, address_list)
         end
       )
  end
  def add_missing_vouts(_, _tuples) do
    raise "error fetching and adding missing transactions"
  end

  #filter the content from the tuples
  def filter_tuples(tuples) do
    Enum.map(tuples, fn {_block, content} -> content end)
  end

end
