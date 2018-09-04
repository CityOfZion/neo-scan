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
end
