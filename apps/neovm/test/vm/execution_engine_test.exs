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
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9C>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9C>>)
  end

  test "NUMNOTEQUAL" do
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9E>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x09, 0x9E>>)
  end

  test "LT" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0x9F>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0x9F>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0x9F>>)
  end

  test "GT" do
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA0>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA0>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA0>>)
  end

  test "LTE" do
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA1>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA1>>)
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA1>>)
  end

  test "GTE" do
    assert %{stack: [0]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA2>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x08, 0xA2>>)
    assert %{stack: [1]} == ExecutionEngine.execute(<<0x01, 0x09, 0x01, 0x08, 0xA2>>)
  end

  test "MIN" do
    assert %{stack: [7]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA3>>)
    assert %{stack: [7]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA3>>)
  end

  test "MAX" do
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x07, 0x01, 0x08, 0xA4>>)
    assert %{stack: [8]} == ExecutionEngine.execute(<<0x01, 0x08, 0x01, 0x07, 0xA4>>)
  end
end
