defmodule Neoscan.Addresses.AddressTest do
  use Neoscan.DataCase, async: true

  alias Neoscan.Addresses.Address

  describe "schema" do
    test "empty schema has default tx_count of 0" do
      address = %Address{}

      assert address.tx_count == 0
    end
  end

  describe "changeset/2" do
    test "returns invalid changeset when attrs are missing" do
      changeset = Address.changeset(%Address{}, %{})

      refute changeset.valid?
      assert %{address: ["can't be blank"]} = errors_on(changeset)
      assert %{time: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when attrs are invalid" do
      cast_fields = [:address, :balance, :time]
      attrs = cast_fields |> Enum.map(fn field -> {field, :invalid} end) |> Map.new()
      changeset = Address.changeset(%Address{}, attrs)

      refute changeset.valid?

      errors = errors_on(changeset)

      Enum.each(cast_fields, fn field ->
        assert Map.get(errors, field) == ["is invalid"]
      end)
    end

    test "returns valid changeset when attrs are valid" do
      valid_attrs = %{
        address: "abc",
        balance: %{
          amount: 100,
          asset: "abcd",
          time: 1476769053
        },
        time: 0,
        tx_count: 100
      }

      changeset = Address.changeset(%Address{}, valid_attrs)

      assert changeset.valid?
      # make sure `:tx_count` is ignored
      refute Map.has_key?(changeset.changes, :tx_count)
    end
  end
end
