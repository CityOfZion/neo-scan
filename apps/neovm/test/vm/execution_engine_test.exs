defmodule NeoVM.ExecutionEngineTest do
  use ExUnit.Case

  alias NeoVM.ExecutionEngine

  test "test 1" do
    binary =
      Base.decode16!(
        "0880946fcf06000000140de106d5a39ca2b83a2a46c46def88bc61619814141c65bc389492f9b14c8a708bba1d013c428d990953c1087472616e73666572",
        case: :mixed
      )

    assert [
             "transfer",
             [
               <<28, 101, 188, 56, 148, 146, 249, 177, 76, 138, 112, 139, 186, 29, 1, 60, 66, 141,
                 153, 9>>,
               <<13, 225, 6, 213, 163, 156, 162, 184, 58, 42, 70, 196, 109, 239, 136, 188, 97, 97,
                 152, 20>>,
               <<128, 148, 111, 207, 6, 0, 0, 0>>
             ]
           ] == ExecutionEngine.execute(binary)
  end

  test "PUSH0" do
    assert [<<>>] == ExecutionEngine.execute(<<0x00>>)
  end

  test "PUSHDATA1" do
    assert [<<0x35, 0x49>>] == ExecutionEngine.execute(<<0x4C, 0x02, 0x35, 0x49>>)
  end

  test "PUSHDATA2" do
    assert [<<0x35, 0x49>>] == ExecutionEngine.execute(<<0x4D, 0x00, 0x02, 0x35, 0x49>>)
  end

  test "PUSHDATA4" do
    assert [<<0x35, 0x49>>] ==
             ExecutionEngine.execute(<<0x4E, 0x00, 0x00, 0x00, 0x02, 0x35, 0x49>>)
  end

  test "PUSHM1" do
    assert [-1] == ExecutionEngine.execute(<<0x4F>>)
  end

  test "NOP" do
    assert [] == ExecutionEngine.execute(<<0x61>>)
  end

  test "JMP" do
    assert [] == ExecutionEngine.execute(<<0x62, 0x00, 0x05, 0x51, 0x52>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x62, 0xFF, 0x05, 0x51, 0x52>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x62, 0x00, 0x15, 0x51, 0x52>>)
  end

  test "JMPIF" do
    assert [] == ExecutionEngine.execute(<<0x51, 0x63, 0x00, 0x05, 0x51, 0x52>>)
    assert [2, 1] == ExecutionEngine.execute(<<0x01, 0x00, 0x63, 0x00, 0x05, 0x51, 0x52>>)
  end

  test "JMPIFNOT" do
    assert [2, 1] == ExecutionEngine.execute(<<0x51, 0x64, 0x00, 0x05, 0x51, 0x52>>)
    assert [] == ExecutionEngine.execute(<<0x01, 0x00, 0x64, 0x00, 0x05, 0x51, 0x52>>)
  end

  test "DUPFROMALTSTACK / TOALTSTACK / FROMALTSTACK" do
    assert [3] == ExecutionEngine.execute(<<0x53>>)
    assert [] == ExecutionEngine.execute(<<0x53, 0x6B>>)
    assert [3] == ExecutionEngine.execute(<<0x53, 0x6B, 0x6A>>)
    assert [3, 3] == ExecutionEngine.execute(<<0x53, 0x6B, 0x6A, 0x6C>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x53, 0x6B, 0x6A, 0x6C, 0x6C>>)
  end

  test "XDROP" do
    assert [3, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x51, 0x6D>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x57, 0x6D>>)
  end

  test "XSWAP" do
    assert [2, 3, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x51, 0x72>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x58, 0x72>>)
  end

  test "XTUCK" do
    assert [5, 4, 3, 5, 2, 1] ==
             ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x54, 0x55, 0x53, 0x73>>)

    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x58, 0x73>>)
  end

  test "DEPTH" do
    assert [3, 1, 2, 3] == ExecutionEngine.execute(<<0x53, 0x52, 0x51, 0x74>>)
  end

  test "DROP" do
    assert [2, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x75>>)
  end

  test "DUP" do
    assert [3, 3, 2, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x76>>)
  end

  test "NIP" do
    assert [3, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x77>>)
  end

  test "OVER" do
    assert [2, 3, 2, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x78>>)
  end

  test "PICK" do
    assert [2, 5, 4, 3, 2, 1] ==
             ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x54, 0x55, 0x53, 0x79>>)

    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x58, 0x79>>)
  end

  test "ROLL" do
    assert [2, 5, 4, 3, 1] ==
             ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x54, 0x55, 0x53, 0x7A>>)

    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x58, 0x7A>>)
  end

  test "ROT" do
    assert [1, 3, 2] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x7B>>)
  end

  test "SWAP" do
    assert [2, 3, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x7C>>)
  end

  test "TUCK" do
    assert [3, 2, 3, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x7D>>)
  end

  test "AND" do
    assert [8] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x0B, 0x84>>)
  end

  test "OR" do
    assert [11] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x03, 0x85>>)
  end

  test "XOR" do
    assert [3] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x0B, 0x86>>)
  end

  test "ADD" do
    assert [3] == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x02, 0x93>>)
  end

  test "SUB" do
    assert [-1] == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x02, 0x94>>)
  end

  test "MUL" do
    assert [10] == ExecutionEngine.execute(<<0x01, 0x05, 0x01, 0x02, 0x95>>)
  end

  test "DIV" do
    assert [3] == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x03, 0x96>>)
  end

  test "MOD" do
    assert [1] == ExecutionEngine.execute(<<0x01, 0x10, 0x01, 0x03, 0x97>>)
  end

  test "SHL" do
    assert [8] == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x03, 0x98>>)
  end

  test "SHR" do
    assert [1] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x03, 0x99>>)
  end

  test "NUMEQUAL" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9C>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9C>>)
  end

  test "NUMNOTEQUAL" do
    assert [false] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9E>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9E>>)
  end

  test "LT" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0x9F>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9F>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0x9F>>)
  end

  test "GT" do
    assert [false] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA0>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA0>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA0>>)
  end

  test "LTE" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA1>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA1>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA1>>)
  end

  test "GTE" do
    assert [false] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA2>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA2>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA2>>)
  end

  test "MIN" do
    assert [7] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA3>>)
    assert [7] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA3>>)
  end

  test "MAX" do
    assert [8] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA4>>)
    assert [8] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA4>>)
  end

  test "CAT" do
    assert ["hello world"] ==
             ExecutionEngine.execute(
               <<0x4C, 0x06>> <> "hello " <> <<0x4C, 0x05>> <> "world" <> <<0x7E>>
             )
  end

  test "SUBSTR" do
    assert ["lo wo"] ==
             ExecutionEngine.execute(<<0x4C, 0x0B>> <> "hello world" <> <<0x53, 0x55, 0x7F>>)
  end

  test "LEFT" do
    assert ["hel"] == ExecutionEngine.execute(<<0x4C, 0x0B>> <> "hello world" <> <<0x53, 0x80>>)
  end

  test "RIGHT" do
    assert ["lo world"] ==
             ExecutionEngine.execute(<<0x4C, 0x0B>> <> "hello world" <> <<0x53, 0x81>>)
  end

  test "SIZE" do
    assert [11] == ExecutionEngine.execute(<<0x4C, 0x0B>> <> "hello world" <> <<0x82>>)
  end

  test "INVERT" do
    assert [-8] == ExecutionEngine.execute(<<0x01, 0x07, 0x83>>)
  end

  test "INC" do
    assert [8] == ExecutionEngine.execute(<<0x01, 0x07, 0x8B>>)
  end

  test "DEC" do
    assert [6] == ExecutionEngine.execute(<<0x01, 0x07, 0x8C>>)
  end

  test "SIGN" do
    assert [1] == ExecutionEngine.execute(<<0x01, 0x07, 0x8D>>)
    assert [0] == ExecutionEngine.execute(<<0x01, 0x00, 0x8D>>)
    assert [-1] == ExecutionEngine.execute(<<0x01, 0xFF, 0x8D>>)
  end

  test "NEGATE" do
    assert [-7] == ExecutionEngine.execute(<<0x01, 0x07, 0x8F>>)
    assert [2] == ExecutionEngine.execute(<<0x01, 0xFE, 0x8F>>)
  end

  test "ABS" do
    assert [7] == ExecutionEngine.execute(<<0x01, 0x07, 0x90>>)
    assert [2] == ExecutionEngine.execute(<<0x01, 0xFE, 0x90>>)
  end

  test "NOT" do
    assert [1] == ExecutionEngine.execute(<<0x01, 0x00, 0x91>>)
    assert [0] == ExecutionEngine.execute(<<0x01, 0x01, 0x91>>)
    assert [0] == ExecutionEngine.execute(<<0x01, 0x02, 0x91>>)
  end

  test "NZ" do
    assert [0] == ExecutionEngine.execute(<<0x01, 0x00, 0x92>>)
    assert [1] == ExecutionEngine.execute(<<0x01, 0x01, 0x92>>)
  end

  test "SHA256" do
    assert [
             <<110, 52, 11, 156, 255, 179, 122, 152, 156, 165, 68, 230, 187, 120, 10, 44, 120,
               144, 29, 63, 179, 55, 56, 118, 133, 17, 163, 6, 23, 175, 160, 29>>
           ] == ExecutionEngine.execute(<<0x01, 0x00, 0xA8>>)
  end

  test "SHA1" do
    assert [
             <<91, 169, 60, 157, 176, 207, 249, 63, 82, 181, 33, 215, 66, 14, 67, 246, 237, 162,
               120, 79>>
           ] == ExecutionEngine.execute(<<0x01, 0x00, 0xA7>>)
  end

  test "HASH256" do
    assert [
             <<20, 6, 224, 88, 129, 226, 153, 54, 119, 102, 211, 19, 226, 108, 5, 86, 78, 201, 27,
               247, 33, 211, 23, 38, 189, 110, 70, 230, 6, 137, 83, 154>>
           ] == ExecutionEngine.execute(<<0x01, 0x00, 0xAA>>)
  end

  test "RIPEMD160" do
    assert [
             <<200, 27, 148, 147, 52, 32, 34, 26, 122, 192, 4, 169, 2, 66, 216, 177, 211, 229, 7,
               13>>
           ] == ExecutionEngine.execute(<<0x01, 0x00, 0xA6>>)
  end

  test "HASH160" do
    assert [
             <<159, 127, 208, 150, 211, 126, 210, 192, 227, 247, 240, 207, 201, 36, 190, 239, 79,
               252, 235, 104>>
           ] == ExecutionEngine.execute(<<0x01, 0x00, 0xA9>>)
  end

  test "WITHIN" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x02, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert [true] == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert [false] == ExecutionEngine.execute(<<0x01, 0x03, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert [false] == ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert [false] == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x01, 0x01, 0x03, 0xA5>>)
  end

  test "EQUAL" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x87>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x87>>)
  end

  test "BOOLOR" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9B>>)
    assert [true] == ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x09, 0x9B>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x00, 0x9B>>)
  end

  test "BOOLAND" do
    assert [true] == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9A>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x09, 0x9A>>)
    assert [false] == ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x00, 0x9A>>)
  end

  test "ARRAYSIZE" do
    assert [3] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0xC0>>)
    assert [3] == ExecutionEngine.execute(<<0x03, 0x52, 0x53, 0x53, 0xC0>>)
  end

  test "PACK" do
    assert [[3, 2, 1]] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1>>)
  end

  test "UNPACK" do
    assert [3, 3, 2, 1] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0xC2>>)

    assert [[3, 2, 1]] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0xC2, 0xC1>>)
  end

  test "PICKITEM" do
    assert [2] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x51, 0xC3>>)
    assert [4] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x53, 0xC3>>)
  end

  test "SETITEM" do
    assert [%{3 => 4}] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4>>)
    assert [[0, 0, 4, 0]] == ExecutionEngine.execute(<<0x54, 0xC5, 0x52, 0x54, 0xC4>>)
  end

  test "NEWMAP" do
    assert [%{}] == ExecutionEngine.execute(<<0xC7>>)
  end

  test "NEWARRAY" do
    assert [[0, 0, 0, 0]] == ExecutionEngine.execute(<<0x54, 0xC5>>)
  end

  test "NEWSTRUCT" do
    assert [[false, false, false, false]] == ExecutionEngine.execute(<<0x54, 0xC6>>)
  end

  test "APPEND" do
    assert [[4, 3, 2, 1]] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x54, 0xC8>>)
    assert {:error, _} = ExecutionEngine.execute(<<0xC8>>)
  end

  test "REVERSE" do
    assert [[1, 2, 3]] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0xC9>>)
  end

  test "REMOVE" do
    assert [[3, 2]] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x52, 0xCA>>)
    assert [%{}] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x53, 0xCA>>)
    assert [%{3 => 4}] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x52, 0xCA>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x55, 0xCA>>)
  end

  test "HASKEY" do
    assert [true] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x53, 0xCB>>)
    assert [false] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x52, 0xCB>>)
    assert [true] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x51, 0xCB>>)
    assert [false] == ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0x55, 0xCB>>)
  end

  test "KEYS" do
    assert [[3, 5]] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x55, 0x54, 0xC4, 0xCC>>)
  end

  test "VALUES" do
    assert [[4, 4]] == ExecutionEngine.execute(<<0xC7, 0x53, 0x54, 0xC4, 0x55, 0x54, 0xC4, 0xCD>>)

    assert [[3, 2, 1]] ==
             ExecutionEngine.execute(<<0x51, 0x52, 0x53, 0x53, 0xC1, 0xC2, 0xC1, 0xCD>>)
  end

  test "THROW" do
    assert {:error, _} = ExecutionEngine.execute(<<0xF0>>)
  end

  test "THROWIFNOT" do
    assert [] == ExecutionEngine.execute(<<0x51, 0xF1>>)
    assert {:error, _} = ExecutionEngine.execute(<<0x50, 0xF1>>)
  end
end
