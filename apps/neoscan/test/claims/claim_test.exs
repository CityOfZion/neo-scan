defmodule Neoscan.Claims.ClaimTest do
  use Neoscan.DataCase

  alias Neoscan.Claims.Claim

  describe "schema" do
    test "empty schema" do
      assert claim = %Claim{}

      %{
        address_hash: nil,
        address_id: nil,
        amount: nil,
        asset: nil,
        block_height: nil,
        id: nil,
        inserted_at: nil,
        time: nil,
        txids: nil,
        updated_at: nil
      } = claim
    end
  end

  describe "changeset/2" do
    test "returns invalid changeset when attrs are missing" do
      missing_params = %{}

      changeset = Claim.changeset(%Claim{}, %{id: 124, address: "dsfj"}, missing_params)

      refute changeset.valid?
      assert %{amount: ["can't be blank"]} = errors_on(changeset)
      assert %{asset: ["can't be blank"]} = errors_on(changeset)
      assert %{block_height: ["can't be blank"]} = errors_on(changeset)
      assert %{time: ["can't be blank"]} = errors_on(changeset)
      assert %{txids: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when attrs are invalid" do
      cast_fields = [:amount, :asset, :block_height, :time, :address_hash, :address_id]

      invalid_attrs =
        cast_fields
        |> Enum.map(fn field -> {field, :invalid} end)
        |> Map.new()

      changeset = Claim.changeset(%Claim{}, %{id: :invalid, address: :invalid}, invalid_attrs)

      refute changeset.valid?

      errors = errors_on(changeset)

      Enum.each(cast_fields, fn field ->
        assert Map.get(errors, field) == ["is invalid"]
      end)
    end

    test "returns valid changeset when attrs are valid" do
      valid_attrs = %{
        block_height: 123,
        amount: 12,
        asset: "232",
        time: 123,
        txids: ["322322"]
      }

      changeset = Claim.changeset(%Claim{}, %{id: 124, address: "dsfj"}, valid_attrs)

      assert changeset.valid?
    end
  end
end
