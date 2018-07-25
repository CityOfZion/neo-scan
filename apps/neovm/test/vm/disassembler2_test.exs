defmodule NeoVM.DisassemblerTest do
  use ExUnit.Case

  alias NeoVM.Disassembler2

  test "test vm" do
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
           } == Disassembler2.execute(binary)
  end
end
