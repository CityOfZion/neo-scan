defmodule Neoscan.ChainAssets.AssetTest do
  use Neoscan.DataCase
  alias Neoscan.ChainAssets.Asset

  describe "schema" do
    test "empty schema" do
      asset = %Asset{}
      assert is_nil(asset.txid)
    end
  end

  describe "changeset/2" do
    test "returns invalid changeset when attrs are missing" do
      missing_params = %{}

      changeset = Asset.changeset(%Asset{}, missing_params)
      refute changeset.valid?
      assert %{txid: ["is invalid"]} = errors_on(changeset)
      assert %{admin: ["can't be blank"]} = errors_on(changeset)
      assert %{amount: ["can't be blank"]} = errors_on(changeset)
      assert %{name: ["can't be blank"]} = errors_on(changeset)
      assert %{owner: ["can't be blank"]} = errors_on(changeset)
      assert %{precision: ["can't be blank"]} = errors_on(changeset)
      assert %{type: ["can't be blank"]} = errors_on(changeset)
      assert %{time: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns invalid changeset when attrs are invalid" do
      cast_fields = [:admin, :amount, :owner, :precision, :type, :time]

      invalid_attrs =
        cast_fields
        |> Enum.map(fn field -> {Atom.to_string(field), :invalid} end)
        |> Map.new()

      changeset = Asset.changeset("1234", invalid_attrs)
      refute changeset.valid?
      errors = errors_on(changeset)

      Enum.each(cast_fields, fn field ->
        assert Map.get(errors, field) == ["is invalid"]
      end)
    end

    test "returns valid changeset when attrs are valid" do
      valid_attrs = %{
        "admin" => "abc",
        "amount" => 123.12,
        "owner" => "def",
        "precision" => 12,
        "type" => "abc",
        "time" => 1432,
        "txid" => "234",
        "name" => [%{"abc" => "def"}]
      }

      changeset = Asset.changeset("125", valid_attrs)

      assert changeset.valid?
    end
  end

  test "update_changeset/2" do
    assert Asset.update_changeset(%Asset{}, %{issued: 123.3232}).valid?
    refute Asset.update_changeset(%Asset{}, %{issued: "hello"}).valid?
  end
end
