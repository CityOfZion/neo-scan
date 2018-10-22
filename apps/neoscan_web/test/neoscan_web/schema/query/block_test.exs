defmodule NeoscanWeb.Schema.Query.BlockTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  @query """
  query Blocks($paginator: Paginator){
  blocks(paginator: $paginator){
    blockRows{
      cumulative_sys_fee
      gasGenerated
      hash
      index
      inserted_at
      lag
      merkle_root
      next_consensus
      nonce
      script {
        invocation
        verification
      }
    },
    pagination{
      totalCount
      pageSize
      page
    }
  }
  }
  """
  test "all", %{conn: conn} do
    insert(:block)
    insert(:block)
    insert(:block)

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: @query,
          variables: %{
            paginator: %{
              page_size: 2,
              page: 1
            }
          }
        }
      )

    body = json_response(conn, 200)

    %{
      "data" => %{
        "blocks" => %{
          "blockRows" => rows,
          "pagination" => %{
            "page" => 1,
            "pageSize" => 2,
            "totalCount" => 3
          }
        }
      }
    } = body

    assert length(rows) == 2
  end

  @query """
  query Block($params: Params!){
  block(params: $params){
      cumulative_sys_fee
      gasGenerated
      hash
      index
      inserted_at
      lag
      merkle_root
      next_consensus
      nonce
      script {
        invocation
        verification
      }
  }
  }
  """

  test "get one block by index", %{conn: conn} do
    block = insert(:block)
    index = block.index

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: @query,
          variables: %{
            params: %{
              index: index
            }
          }
        }
      )

    body = json_response(conn, 200)

    assert %{
             "data" => %{
               "block" => %{
                 "cumulative_sys_fee" => _,
                 "gasGenerated" => _,
                 "hash" => _,
                 "index" => ^index,
                 "inserted_at" => _,
                 "lag" => _,
                 "merkle_root" => _,
                 "next_consensus" => _,
                 "nonce" => _,
                 "script" => %{
                   "invocation" => _,
                   "verification" => _
                 }
               }
             }
           } = body
  end

  test "get one block by hash", %{conn: conn} do
    block = insert(:block)
    hash = block.hash

    conn =
      post(
        conn,
        "/graphql",
        %{
          query: @query,
          variables: %{
            params: %{
              hash: block.hash
            }
          }
        }
      )

    body = json_response(conn, 200)

    assert %{
             "data" => %{
               "block" => %{
                 "cumulative_sys_fee" => _,
                 "gasGenerated" => _,
                 "hash" => ^hash,
                 "index" => _,
                 "inserted_at" => _,
                 "lag" => _,
                 "merkle_root" => _,
                 "next_consensus" => _,
                 "nonce" => _,
                 "script" => %{
                   "invocation" => _,
                   "verification" => _
                 }
               }
             }
           } = body
  end
end
