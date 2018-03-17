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
      missing_params = %{}

      changeset = Address.changeset(%Address{}, missing_params)

      refute changeset.valid?
      assert %{address: ["can't be blank"]} = errors_on(changeset)
      assert %{time: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when attrs are invalid" do
      cast_fields = [:address, :balance, :time]
      invalid_attrs = cast_fields |> Enum.map(fn field -> {field, :invalid} end) |> Map.new()
      changeset = Address.changeset(%Address{}, invalid_attrs)

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

  describe "update_changeset/2" do
    test "returns invalid changeset when attrs are invalid" do
      invalid_attrs = %{balance: :invalid}

      changeset = Address.update_changeset(%Address{}, invalid_attrs)

      refute changeset.valid?
      assert %{balance: ["is invalid"]} == errors_on(changeset)
    end

    test "returns changeset where existing tx_count is incremented by 1" do
      initial_tx_count = 20
      address = %Address{tx_count: initial_tx_count}
      ignored_attrs = %{tx_count: 5000}

      changeset = Address.update_changeset(address, ignored_attrs)

      assert changeset.changes.tx_count == initial_tx_count + 1
    end

    test "returns changeset ignoring expected input attrs" do
      attrs_to_ignore = %{
        address: "different address",
        time: DateTime.utc_now() |> DateTime.to_unix()
      }

      changeset = Address.update_changeset(%Address{}, attrs_to_ignore)

      attrs_to_ignore
      |> Map.keys()
      |> Enum.each(fn field ->
        refute Map.has_key?(changeset.changes, field)
      end)
    end

    test "returns valid changeset when attrs are valid" do
      balance = %{
        amount: 100,
        asset: "abcd",
        time: 1476769053
      }

      valid_attrs = %{balance: balance}

      changeset = Address.update_changeset(%Address{}, valid_attrs)

      assert changeset.valid?
      assert changeset.changes.balance == balance
    end
  end
end
