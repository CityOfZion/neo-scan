defmodule NeoscanWeb.TransactionControllerTest do
  use NeoscanWeb.ConnCase

  import NeoscanWeb.Factory

  test "/transaction/:hash", %{conn: conn} do
    scripts = [
      %{
        "contract" => %{
          "author" => "Erik Zhang",
          "code" => %{
            "hash" => "0xce3a97d7cfaa770a5e51c5b12cd1d015fbb5f87d",
            "parameters" => [
              "Hash160",
              "Hash256",
              "Hash256",
              "Hash160",
              "Boolean",
              "Integer",
              "Signature"
            ],
            "returntype" => "Boolean",
            "script" =>
              "5679547aac640800516b629202557a7cac630800006b62860252796304007c0000682953797374656d2e457865637574696f6e456e67696e652e476574536372697074436f6e7461696e65726823416e745368617265732e5472616e73616374696f6e2e4765745265666572656e63657376c00078789c63a700527978c376681e416e745368617265732e4f75747075742e47657453637269707448617368682953797374656d2e457865637574696f6e456e67696e652e476574456e7472795363726970744861736887644e0076681b416e745368617265732e4f75747075742e47657441737365744964577987630800006b62a801766819416e745368617265732e4f75747075742e47657456616c7565557993557275758b6259ff757575682953797374656d2e457865637574696f6e456e67696e652e476574536372697074436f6e7461696e65726820416e745368617265732e5472616e73616374696f6e2e4765744f75747075747376c00078789c63eb00527978c376681e416e745368617265732e4f75747075742e47657453637269707448617368682953797374656d2e457865637574696f6e456e67696e652e476574456e747279536372697074486173688764920076681b416e745368617265732e4f75747075742e476574417373657449645779876428005479786819416e745368617265732e4f75747075742e47657456616c75659455727562490076681b416e745368617265732e4f75747075742e476574417373657449645879876425005579786819416e745368617265732e4f75747075742e47657456616c756593567275758b6215ff7575757600a1640800516b623200547a641600547a957c0400e1f50595a0641b00006b621a000400e1f505957c547a95a0640800006b62070075755166746407007562fbff6c66"
          },
          "description" => "Agency Contract 2.0",
          "email" => "erik@antshares.org",
          "name" => "AgencyContract",
          "needstorage" => false,
          "version" => "2.0.1-preview2"
        }
      },
      %{
        "script" =>
          "2102486fd15702c4490a26703112a5cc1d0923fd697a33406bd5a1c00e0013b09a702102aaec38470f6aad0042c6e877cfd8087d2676b0f516fddd362801b9bd3936399e21024c7b7fb6c310fccf1ba33b082519d82964ea93868d676662d4a59ad548df0e7d2102ca0e27697b9c248f6f16e085fd0061e26f44da85b58ee835c110caa5ec3ba5542103b8d9d5771d8f513aa0869b9cc8d50986403b78c6da36890638c3d46a5adce04a2102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e8950932103b209fd4f53a7170ea4444e0cb0a6bb6a53c2bd016926989cf85f9b0fba17a70c57c1145fa99d93303775fe50ca119c327759313eccfa1c68194e656f2e426c6f636b636861696e2e4765744163636f756e7468144e656f2e4163636f756e742e536574566f746573"
      },
      %{
        "invocation" =>
          "4065a3c7abb44ed656d2625ec748bcf4add247f39956190e8907800c7871cdd10d2e470367242440cb8393546178a377a4c7893c1290530e5b45f457fc83bcce73"
      },
      %{
        "verification" => "2102df48f60e8f3e01c48ff40b9b7f1310d7a8b2a193188befe1c2e3df740e895093ac"
      }
    ]

    for type <- [
          "miner_transaction",
          "contract_transaction",
          "claim_transaction",
          "issue_transaction",
          "register_transaction",
          "invocation_transaction",
          "publish_transaction",
          "enrollment_transaction",
          "state_transaction"
        ] do
      transaction = insert(:transaction, %{type: type, scripts: scripts})
      insert(:asset, %{transaction_hash: transaction.hash})
      conn = get(conn, "/transaction/#{Base.encode16(transaction.hash)}")
      body = html_response(conn, 200)
      assert body =~ Base.encode16(transaction.hash, case: :lower)

      conn = get(conn, "/transaction/#{Base.encode16(transaction.hash, case: :lower)}")
      body = html_response(conn, 200)
      assert body =~ Base.encode16(transaction.hash, case: :lower)
    end

    #    conn = get(conn, "/transaction/random")
    #    assert "/" == redirected_to(conn, 302)
  end
end
