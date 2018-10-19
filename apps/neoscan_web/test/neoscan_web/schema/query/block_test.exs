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
end
