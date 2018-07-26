defmodule NeoVM.ExecutionEngineTest do
  use ExUnit.Case

  alias NeoVM.ExecutionEngine

  test "test 1" do
    binary =
      Base.decode16!(
        "0880946fcf06000000140de106d5a39ca2b83a2a46c46def88bc61619814141c65bc389492f9b14c8a708bba1d013c428d990953c1087472616e73666572",
        case: :mixed
      )

    assert %{
             stack: [
               "transfer",
               [
                 <<28, 101, 188, 56, 148, 146, 249, 177, 76, 138, 112, 139, 186, 29, 1, 60, 66,
                   141, 153, 9>>,
                 <<13, 225, 6, 213, 163, 156, 162, 184, 58, 42, 70, 196, 109, 239, 136, 188, 97,
                   97, 152, 20>>,
                 <<128, 148, 111, 207, 6, 0, 0, 0>>
               ]
             ]
           } == ExecutionEngine.execute(binary)
  end

  test "AND" do
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x0B, 0x84>>)
  end

  test "OR" do
    assert %{stack: [11]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x03, 0x85>>)
  end

  test "XOR" do
    assert %{stack: [3]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x0B, 0x86>>)
  end

  test "ADD" do
    assert %{stack: [3]} == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x02, 0x93>>)
  end

  test "SUB" do
    assert %{stack: [-1]} == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x02, 0x94>>)
  end

  test "MUL" do
    assert %{stack: [10]} == ExecutionEngine.execute(<<0x01, 0x05, 0x01, 0x02, 0x95>>)
  end

  test "DIV" do
    assert %{stack: [3]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x03, 0x96>>)
  end

  test "MOD" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x10, 0x01, 0x03, 0x97>>)
  end

  test "SHL" do
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x03, 0x98>>)
  end

  test "SHR" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x03, 0x99>>)
  end

  test "NUMEQUAL" do
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9C>>)
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9C>>)
  end

  test "NUMNOTEQUAL" do
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9E>>)
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9E>>)
  end

  test "LT" do
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0x9F>>)
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9F>>)
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0x9F>>)
  end

  test "GT" do
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA0>>)
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA0>>)
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA0>>)
  end

  test "LTE" do
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA1>>)
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA1>>)
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA1>>)
  end

  test "GTE" do
    assert %{stack: [false]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA2>>)
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA2>>)
    assert %{stack: [true]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA2>>)
  end

  test "MIN" do
    assert %{stack: [7]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA3>>)
    assert %{stack: [7]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA3>>)
  end

  test "MAX" do
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA4>>)
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA4>>)
  end

  test "INVERT" do
    assert %{stack: [-8]} == ExecutionEngine.execute(<<0x01, 0x07, 0x83>>)
  end

  test "INC" do
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x07, 0x8B>>)
  end

  test "DEC" do
    assert %{stack: [6]} == ExecutionEngine.execute(<<0x01, 0x07, 0x8C>>)
  end

  test "SIGN" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x07, 0x8D>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x00, 0x8D>>)
    assert %{stack: [-1]} == ExecutionEngine.execute(<<0x01, 0xFF, 0x8D>>)
  end

  test "NEGATE" do
    assert %{stack: [-7]} == ExecutionEngine.execute(<<0x01, 0x07, 0x8F>>)
    assert %{stack: [2]} == ExecutionEngine.execute(<<0x01, 0xFE, 0x8F>>)
  end

  test "ABS" do
    assert %{stack: [7]} == ExecutionEngine.execute(<<0x01, 0x07, 0x90>>)
    assert %{stack: [2]} == ExecutionEngine.execute(<<0x01, 0xFE, 0x90>>)
  end

  test "NOT" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x00, 0x91>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x01, 0x91>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x02, 0x91>>)
  end

  test "NZ" do
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x00, 0x92>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x01, 0x92>>)
  end

  test "WITHIN" do
    assert %{stack: [true]} ==
             ExecutionEngine.execute(<<0x01, 0x02, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert %{stack: [true]} ==
             ExecutionEngine.execute(<<0x01, 0x01, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert %{stack: [false]} ==
             ExecutionEngine.execute(<<0x01, 0x03, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert %{stack: [false]} ==
             ExecutionEngine.execute(<<0x01, 0x00, 0x01, 0x01, 0x01, 0x03, 0xA5>>)

    assert %{stack: [false]} ==
             ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x01, 0x01, 0x03, 0xA5>>)
  end
end
