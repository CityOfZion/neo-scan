defmodule Neoscan.BalanceHistories.HistoryTest do
  use Neoscan.DataCase, async: true

  alias Neoscan.BalanceHistories.History

  describe "schema" do
    test "empty schema has default txid is nil" do
      history = %History{}
      assert history.txid == nil
    end
  end

  describe "changeset/2" do
    test "returns invalid changeset when attrs are missing" do
      missing_params = %{}

      changeset = History.changeset(%History{}, %{id: 124, address: "dsfj"}, missing_params)

      refute changeset.valid?
      assert %{block_height: ["can't be blank"]} = errors_on(changeset)
      assert %{time: ["can't be blank"]} = errors_on(changeset)
      assert %{txid: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when attrs are invalid" do
      cast_fields = [:block_height, :time, :txid]
      invalid_attrs = cast_fields
                      |> Enum.map(fn field -> {field, :invalid} end)
                      |> Map.new()
      changeset = History.changeset(%History{}, %{id: 124, address: "dsfj"}, invalid_attrs)

      refute changeset.valid?

      errors = errors_on(changeset)

      Enum.each(
        cast_fields,
        fn field ->
          assert Map.get(errors, field) == ["is invalid"]
        end
      )
    end

    test "returns valid changeset when attrs are valid" do
      valid_attrs = %{
        block_height: 123,
        time: 0,
        txid: "239832"
      }

      changeset = History.changeset(%History{}, %{id: 124, address: "dsfj"},valid_attrs)

      assert changeset.valid?
    end
  end
end
