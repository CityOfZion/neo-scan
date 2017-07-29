defmodule NeoscanWeb.BlockViewControllerTest do
  use NeoscanWeb.ConnCase

  alias Neoscan.Blocks

  @create_attrs %{hash: "some hash"}
  @update_attrs %{hash: "some updated hash"}
  @invalid_attrs %{hash: nil}

  def fixture(:block_view) do
    {:ok, block_view} = Blocks.create_block_view(@create_attrs)
    block_view
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, block_view_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Blocks"
  end

  test "renders form for new blocks", %{conn: conn} do
    conn = get conn, block_view_path(conn, :new)
    assert html_response(conn, 200) =~ "New Block view"
  end

  test "creates block_view and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, block_view_path(conn, :create), block_view: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == block_view_path(conn, :show, id)

    conn = get conn, block_view_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Block view"
  end

  test "does not create block_view and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, block_view_path(conn, :create), block_view: @invalid_attrs
    assert html_response(conn, 200) =~ "New Block view"
  end

  test "renders form for editing chosen block_view", %{conn: conn} do
    block_view = fixture(:block_view)
    conn = get conn, block_view_path(conn, :edit, block_view)
    assert html_response(conn, 200) =~ "Edit Block view"
  end

  test "updates chosen block_view and redirects when data is valid", %{conn: conn} do
    block_view = fixture(:block_view)
    conn = put conn, block_view_path(conn, :update, block_view), block_view: @update_attrs
    assert redirected_to(conn) == block_view_path(conn, :show, block_view)

    conn = get conn, block_view_path(conn, :show, block_view)
    assert html_response(conn, 200) =~ "some updated hash"
  end

  test "does not update chosen block_view and renders errors when data is invalid", %{conn: conn} do
    block_view = fixture(:block_view)
    conn = put conn, block_view_path(conn, :update, block_view), block_view: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Block view"
  end

  test "deletes chosen block_view", %{conn: conn} do
    block_view = fixture(:block_view)
    conn = delete conn, block_view_path(conn, :delete, block_view)
    assert redirected_to(conn) == block_view_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, block_view_path(conn, :show, block_view)
    end
  end
end
