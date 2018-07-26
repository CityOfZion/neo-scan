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

  test "add" do
    binary = <<0x01, 0x01, 0x01, 0x02, 0x93>>
    assert %{stack: [3]} == ExecutionEngine.execute(binary)
  end

  test "sub" do
    binary = <<0x01, 0x01, 0x01, 0x02, 0x94>>
    assert %{stack: [-1]} == ExecutionEngine.execute(binary)
  end

  test "mul" do
    binary = <<0x01, 0x05, 0x01, 0x02, 0x95>>
    assert %{stack: [10]} == ExecutionEngine.execute(binary)
  end

  test "div" do
    binary = <<0x01, 0x09, 0x01, 0x03, 0x96>>
    assert %{stack: [3]} == ExecutionEngine.execute(binary)
  end

  test "mod" do
    binary = <<0x01, 0x10, 0x01, 0x03, 0x97>>
    assert %{stack: [1]} == ExecutionEngine.execute(binary)
  end

  test "shl" do
    binary = <<0x01, 0x01, 0x01, 0x03, 0x98>>
    assert %{stack: [8]} == ExecutionEngine.execute(binary)
  end

  test "shr" do
    binary = <<0x01, 0x08, 0x01, 0x03, 0x99>>
    assert %{stack: [1]} == ExecutionEngine.execute(binary)
  end
end
