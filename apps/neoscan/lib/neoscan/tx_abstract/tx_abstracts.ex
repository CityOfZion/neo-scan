defmodule Neoscan.TxAbstracts do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Neoscan.Repo
  alias Neoscan.TxAbstracts.TxAbstract

  require Logger

  def create_abstracts_from_tx(transaction) do
    vin_count = count_addresses_in_vins(transaction["vin"])

    cond do
      vin_count > 1 ->
        build_list_for_multiple_vins(transaction)
        |> Enum.each(fn abstract -> create_abstract(abstract) end)

      vin_count == 0 ->
        cond do
          transaction["type"] == "ClaimTransaction" ->
            build_list_for_claim(transaction)
            |> Enum.each(fn abstract -> create_abstract(abstract) end)

          transaction["type"] == "IssueTransaction" ->
            build_list_for_issue(transaction)
            |> Enum.each(fn abstract -> create_abstract(abstract) end)

          true ->
            "ok"
        end

      vin_count == 1 ->
        build_list_for_vouts(transaction)
        |> Enum.each(fn abstract -> create_abstract(abstract) end)
    end
  end

  def create_abstract_from_transfer(transfer) do
    %{
      :address_from => transfer["address_from"],
      :address_to => transfer["address_to"],
      :amount => transfer["amount"],
      :block_height => transfer["block_height"],
      :txid => transfer["txid"],
      :asset => transfer["contract"],
      :time => transfer["time"]
    }
    |> create_abstract()
  end

  def create_abstract(attrs) do
    TxAbstract.changeset(attrs)
    |> Repo.insert!()
  end

  def count_addresses_in_vins(vin_list) do
    {c, _list} =
      vin_list
      |> Enum.reduce({0, []}, fn %{:address_hash => hash}, {counter, address_list} ->
        case Enum.any?(address_list, fn address ->
               hash == address
             end) do
          true ->
            {counter, address_list}

          false ->
            {counter + 1, [hash] ++ address_list}
        end
      end)

    c
  end

  def get_amount_for_address(hash, list) do
    Enum.reduce(list, 0, fn %{"address" => address, "value" => amount}, total ->
      case address == hash do
        true ->
          total + amount

        false ->
          amount
      end
    end)
  end

  def build_list_for_multiple_vins(transaction) do
    list1 =
      Enum.map(transaction["vin"], fn %{
                                        :address_hash => address,
                                        :value => amount,
                                        :asset => asset
                                      } ->
        %{
          :address_from => address,
          :address_to => transaction["txid"],
          :amount => amount,
          :block_height => transaction["block_height"],
          :txid => transaction["txid"],
          :asset => String.slice(to_string(asset), -64..-1),
          :time => transaction["time"]
        }
      end)

    list2 =
      Enum.map(transaction["vout"], fn %{
                                         "address" => address,
                                         "value" => amount,
                                         "asset" => asset
                                       } ->
        %{
          :address_from => transaction["txid"],
          :address_to => address,
          :amount => amount,
          :block_height => transaction["block_height"],
          :txid => transaction["txid"],
          :asset => String.slice(to_string(asset), -64..-1),
          :time => transaction["time"]
        }
      end)

    list1 ++ list2
  end

  def build_list_for_claim(transaction) do
    Enum.map(transaction["vout"], fn %{"address" => address, "value" => amount, "asset" => asset} ->
      %{
        :address_from => "claim",
        :address_to => address,
        :amount => amount,
        :block_height => transaction["block_height"],
        :txid => transaction["txid"],
        :asset => String.slice(to_string(asset), -64..-1),
        :time => transaction["time"]
      }
    end)
  end

  def build_list_for_issue(transaction) do
    Enum.map(transaction["vout"], fn %{"address" => address, "value" => amount, "asset" => asset} ->
      %{
        :address_from => "issue",
        :address_to => address,
        :amount => amount,
        :block_height => transaction["block_height"],
        :txid => transaction["txid"],
        :asset => String.slice(to_string(asset), -64..-1),
        :time => transaction["time"]
      }
    end)
  end

  def build_list_for_vouts(transaction) do
    %{:address_hash => address_from} =
      transaction["vin"]
      |> List.first()

    Enum.map(transaction["vout"], fn %{"address" => address, "value" => amount, "asset" => asset} ->
      cond do
        address != address_from ->
          %{
            :address_from => address_from,
            :address_to => address,
            :amount => amount,
            :block_height => transaction["block_height"],
            :txid => transaction["txid"],
            :asset => String.slice(to_string(asset), -64..-1),
            :time => transaction["time"]
          }

        true ->
          nil
      end
    end)
    |> Enum.filter(fn result -> result != nil end)
  end

  def get_address_abstracts(hash, page) do
    abstract_query =
      from(
        abstract in TxAbstract,
        where: abstract.address_from == ^hash or abstract.address_to == ^hash,
        order_by: [
          desc: abstract.id
        ],
        select: %{
          :id => abstract.id,
          :address_from => abstract.address_from,
          :address_to => abstract.address_to,
          :amount => abstract.amount,
          :block_height => abstract.block_height,
          :txid => abstract.txid,
          :asset => abstract.asset,
          :time => abstract.time
        }
      )

    Repo.paginate(abstract_query, page: page, page_size: 15)
  end

  def get_address_to_address_abstracts(hash1, hash2, page) do
    abstract_query =
      from(
        abstract in TxAbstract,
        where:
          (abstract.address_from == ^hash1 and abstract.address_to == ^hash2) or
            (abstract.address_from == ^hash2 and abstract.address_to == ^hash1),
        order_by: [
          desc: abstract.id
        ],
        select: %{
          :id => abstract.id,
          :address_from => abstract.address_from,
          :address_to => abstract.address_to,
          :amount => abstract.amount,
          :block_height => abstract.block_height,
          :txid => abstract.txid,
          :asset => abstract.asset,
          :time => abstract.time
        }
      )

    Repo.paginate(abstract_query, page: page, page_size: 15)
  end
end
