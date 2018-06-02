defmodule Neoscan.ChainAssets.AssetsTest do
  use Neoscan.DataCase
  alias Neoscan.Stats
  alias Neoscan.ChainAssets
  alias Neoscan.ChainAssets.Asset
  import Neoscan.Factory
  import ExUnit.CaptureLog

  test "create_asset/2" do
    assert %Asset{} =
             ChainAssets.create_asset("1394202", %{
               "admin" => "abc",
               "amount" => 123.12,
               "owner" => "def",
               "precision" => 12,
               "type" => "abc",
               "time" => 1432,
               "name" => [%{"abc" => "def"}]
             })
  end

  test "add_token/1" do
    response = %{
      "token" => %{
        "name" => "n\u0000am\u0000e",
        "contract_address" => "23243",
        "decimals" => 12,
        "script_hash" => "d9j21092901j90j2190dj219dj29jd290ffijunvcuzncz9212903nf0932n9203n"
      },
      "block" => 1,
      "tx" =>
        "d9j21092901j90j2190dj219dj29jd290ffijunvcuzncz9212903nf0932n9203ncxkmakasfkasfskjfa"
    }

    asset = ChainAssets.add_token(response)
    assert [%{"lang" => "en", "name" => "name"}] == asset.name
    assert 1_476_647_382 == asset.time
    assert "23243" == asset.admin
    assert 12 == asset.precision
    assert "j29jd290ffijunvcuzncz9212903nf0932n9203n" == asset.contract
    assert "dj219dj29jd290ffijunvcuzncz9212903nf0932n9203ncxkmakasfkasfskjfa" == asset.txid
  end

  test "create_tokens/1" do
    insert(:asset, %{txid: "contracthash"})

    response = %{
      "token" => %{
        "name" => "n\u0000am\u0000e",
        "contract_address" => "23243",
        "decimals" => 12,
        "script_hash" => "contracthash"
      },
      "block" => 1,
      "tx" =>
        "d9j21092901j90j2190dj219dj29jd290ffijunvcuzncz9212903nf0932n9203ncxkmakasfkasfskjfa"
    }

    assert [response] == ChainAssets.create_tokens([response])
  end

  test "get_asset_by_hash/1" do
    asset = insert(:asset)
    asset1 = ChainAssets.get_asset_by_hash(asset.txid)
    assert asset1.txid == asset.txid
  end

  test "get_asset_name_by_hash/1" do
    asset =
      insert(:asset, %{contract: "helloworld", name: [%{"name" => "AntShare", "lang" => "en"}]})

    assert "NEO" == ChainAssets.get_asset_name_by_hash(asset.contract)

    asset =
      insert(:asset, %{contract: "helloworld2", name: [%{"name" => "AntCoin", "lang" => "en"}]})

    assert "GAS" == ChainAssets.get_asset_name_by_hash(asset.contract)

    asset =
      insert(:asset, %{contract: "helloworld3", name: [%{"name" => "RandomName", "lang" => "en"}]})

    assert "RandomName" == ChainAssets.get_asset_name_by_hash(asset.contract)
    asset = insert(:asset, %{contract: "helloworld4", name: [%{"name" => "你好", "lang" => "cn"}]})
    assert "你好" == ChainAssets.get_asset_name_by_hash(asset.contract)

    assert "Asset not Found" == ChainAssets.get_asset_name_by_hash("notexisting thing")

    txid = "superlongtxidsuperlongtxidsuperlongtxid12"
    asset = insert(:asset, %{txid: txid, name: [%{"name" => "AntShare", "lang" => "en"}]})
    assert "NEO" == ChainAssets.get_asset_name_by_hash(asset.txid)
  end

  test "get_asset_precision_by_hash/1" do
    contract = "superlongtxidsuperlongtxidsuperlongtxid1"
    asset = insert(:asset, %{contract: contract, precision: 123})
    assert 123 == ChainAssets.get_asset_precision_by_hash(asset.contract)

    asset = insert(:asset, %{txid: "1235", precision: 123})
    assert 123 == ChainAssets.get_asset_precision_by_hash(asset.txid)
  end

  test "list_assets/0" do
    assert is_list(ChainAssets.list_assets())
  end

  test "update_asset/2" do
    asset = insert(:asset)
    asset = ChainAssets.update_asset(asset, %{issued: 1023.12})
    assert 1023.12 == asset.issued
  end

  test "add_issued_value/2" do
    asset = insert(:asset)

    assert capture_log(fn ->
             assert {:error, "Non existant asset cant be issued!"} ==
                      ChainAssets.add_issued_value("notexisting", 123.3)
           end) =~ "Error issuing asset"

    assert 123.4 == ChainAssets.add_issued_value(asset.txid, 123.4).issued
  end

  test "create/3" do
    asset = %{
      "amount" => "123.4",
      "admin" => "string",
      "owner" => "string",
      "name" => [%{"lang" => "en", "name" => "AntShare"}],
      "precision" => 12,
      "type" => "type"
    }

    asset = ChainAssets.create(asset, "1234", 1234)
    assert 123.4 == asset.amount
    assert 1234 == asset.time
    assert is_nil(ChainAssets.create(nil, "1234", 1234))
  end

  test "issue/2" do
    assert is_nil(ChainAssets.issue("random", []))

    asset1 =
      insert(:asset, %{txid: "2323322942389383289433432433244234232343443342423344324324323444"})

    asset2 =
      insert(:asset, %{txid: "2323322942389383289433432433244234232343443342423344324324323445"})

    vouts = [
      %{"asset" => asset1.txid, "value" => "123.4"},
      %{"asset" => asset2.txid, "value" => "567.8"}
    ]

    ChainAssets.issue("IssueTransaction", vouts)
    assert 123.4 == ChainAssets.get_asset_by_hash(asset1.txid).issued
    assert 567.8 == ChainAssets.get_asset_by_hash(asset2.txid).issued
  end

  #    test "verify_asset/2" do
  #      asset = insert(:asset)
  #      ChainAssets.verify_asset(asset.txid, asset.time)
  #    end

  #  test "check_db/2" do
  #    with_mocks(
  #      [
  #        {NeoscanSync.HttpCalls, [], [url: fn _ -> 1234 end]},
  #        {NeoscanSync.Blockchain, [], [get_asset: fn _, _ -> "helloworld" end]},
  #        {NeoscanSync.Notifications, [], [get_token_notifications: fn -> [] end]}
  #      ]
  #    ) do
  #      asset = insert(:asset)
  #      assert asset.txid == ChainAssets.check_db(asset.txid, asset.time)
  #      #assert asset.txid == ChainAssets.check_db("randomvalue", asset.time)
  #    end
  #  end

  test "get_new_asset/2" do
    assert %{type: "GoverningToken"} =
             ChainAssets.get_new_asset(
               "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b",
               123
             )

    assert_raise Ecto.InvalidChangesetError,
                 ~r/could not perform insert because changeset is invalid\..*/,
                 fn ->
                   ChainAssets.get_new_asset("0x06fa8be9b6609d963e8fc63977b9f8dc5f10895f", 123)
                 end
  end

  test "get_assets_stats/0" do
    # TODO we need to initialize stats counter before inserting insert otherwise there is an infinite loop
    # , potentially a bug ?
    Stats.initialize_counter()
    insert(:asset)
    assert %{assets_addresses: _, assets_transactions: _} = ChainAssets.get_assets_stats()
  end
end
