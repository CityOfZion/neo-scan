defmodule Neoscan.Vm.Disassembler do
  @opcodes_list %{
      "00" => "PUSH0", # An empty array of bytes is pushed onto the stack.
      "PUSH0" => "PUSHF",
      "01" => "PUSHBYTES1", # 0x01-0x4B The next opcode bytes is data to be pushed onto the stack
      "4b" => "PUSHBYTES75",
      "4c" => "PUSHDATA1", # The next byte contains the number of bytes to be pushed onto the stack.
      "4d" => "PUSHDATA2", # The next two bytes contain the number of bytes to be pushed onto the stack.
      "4e" => "PUSHDATA4", # The next four bytes contain the number of bytes to be pushed onto the stack.
      "4f" => "PUSHM1", # The number -1 is pushed onto the stack.
      "51" => "PUSH1", # The number 1 is pushed onto the stack.
      "PUSH1" => "PUSHT",
      "52" => "PUSH2", # The number 2 is pushed onto the stack.
      "53" => "PUSH3", # The number 3 is pushed onto the stack.
      "54" => "PUSH4", # The number 4 is pushed onto the stack.
      "55" => "PUSH5", # The number 5 is pushed onto the stack.
      "56" => "PUSH6", # The number 6 is pushed onto the stack.
      "57" => "PUSH7", # The number 7 is pushed onto the stack.
      "58" => "PUSH8", # The number 8 is pushed onto the stack.
      "59" => "PUSH9", # The number 9 is pushed onto the stack.
      "5a" => "PUSH10", # The number 10 is pushed onto the stack.
      "5b" => "PUSH11", # The number 11 is pushed onto the stack.
      "5c" => "PUSH12", # The number 12 is pushed onto the stack.
      "5d" => "PUSH13", # The number 13 is pushed onto the stack.
      "5e" => "PUSH14", # The number 14 is pushed onto the stack.
      "5f" => "PUSH15", # The number 15 is pushed onto the stack.
      "60" => "PUSH16", # The number 16 is pushed onto the stack.
      "61" => "NOP", # Does nothing.
      "62" => "JMP",
      "63" => "JMPIF",
      "64" => "JMPIFNOT",
      "65" => "CALL",
      "66" => "RET",
      "67" => "APPCALL",
      "68" => "SYSCALL",
      "69" => "TAILCALL",
      "6a" => "DUPFROMALTSTACK",
      "6b" => "TOALTSTACK", # Puts the input onto the top of the alt stack. Removes it from the main stack.
      "6c" => "FROMALTSTACK", # Puts the input onto the top of the main stack. Removes it from the alt stack.
      "6d" => "XDROP",
      "72" => "XSWAP",
      "73" => "XTUCK",
      "74" => "DEPTH", # Puts the number of stack items onto the stack.
      "75" => "DROP", # Removes the top stack item.
      "76" => "DUP", # Duplicates the top stack item.
      "77" => "NIP", # Removes the second-to-top stack item.
      "78" => "OVER", # Copies the second-to-top stack item to the top.
      "79" => "PICK", # The item n back in the stack is copied to the top.
      "7a" => "ROLL", # The item n back in the stack is moved to the top.
      "7b" => "ROT", # The top three items on the stack are rotated to the left.
      "7c" => "SWAP", # The top two items on the stack are swapped.
      "7d" => "TUCK", # The item at the top of the stack is copied and inserted before the second-to-top item.
      "7e" => "CAT", # Concatenates two strings.
      "7f" => "SUBSTR", # Returns a section of a string.
      "80" => "LEFT", # Keeps only characters left of the specified point in a string.
      "81" => "RIGHT", # Keeps only characters right of the specified point in a string.
      "82" => "SIZE", # Returns the length of the input string.
      "83" => "INVERT", # Flips all of the bits in the input.
      "84" => "AND", # Boolean and between each bit in the inputs.
      "85" => "OR", # Boolean or between each bit in the inputs.
      "86" => "XOR", # Boolean exclusive or between each bit in the inputs.
      "87" => "EQUAL", # Returns 1 if the inputs are exactly equal", 0 otherwise.
      "8b" => "INC", # 1 is added to the input.
      "8c" => "DEC", # 1 is subtracted from the input.
      "8d" => "SIGN",
      "8f" => "NEGATE", # The sign of the input is flipped.
      "90" => "ABS", # The input is made positive.
      "91" => "NOT", # If the input is 0 or 1", it is flipped. Otherwise the output will be 0.
      "92" => "NZ", # Returns 0 if the input is 0. 1 otherwise.
      "93" => "ADD", # a is added to b.
      "94" => "SUB", # b is subtracted from a.
      "95" => "MUL", # a is multiplied by b.
      "96" => "DIV", # a is divided by b.
      "97" => "MOD", # Returns the remainder after dividing a by b.
      "98" => "SHL", # Shifts a left b bits, preserving sign.
      "99" => "SHR", # Shifts a right b bits, preserving sign.
      "9a" => "BOOLAND", # If both a and b are not 0, the output is 1. Otherwise 0.
      "9b" => "BOOLOR", # If a or b is not 0, the output is 1. Otherwise 0.
      "9c" => "NUMEQUAL", # Returns 1 if the numbers are equal, 0 otherwise.
      "9e" => "NUMNOTEQUAL", # Returns 1 if the numbers are not equal, 0 otherwise.
      "9f" => "LT", # Returns 1 if a is less than b, 0 otherwise.
      "a0" => "GT", # Returns 1 if a is greater than b, 0 otherwise.
      "a1" => "LTE", # Returns 1 if a is less than or equal to b, 0 otherwise.
      "a2" => "GTE", # Returns 1 if a is greater than or equal to b, 0 otherwise.
      "a3" => "MIN", # Returns the smaller of a and b.
      "a4" => "MAX", # Returns the larger of a and b.
      "a5" => "WITHIN", # Returns 1 if x is within the specified range (left-inclusive), 0 otherwise.
      "a7" => "SHA1", # The input is hashed using SHA-1.
      "a8" => "SHA256", # The input is hashed using SHA-256.
      "a9" => "HASH160",
      "aa" => "HASH256",
      "ac" => "CHECKSIG",
      "ae" => "CHECKMULTISIG",
      "c0" => "ARRAYSIZE",
      "c1" => "PACK",
      "c2" => "UNPACK",
      "c3" => "PICKITEM",
      "c4" => "SETITEM",
      "c5" => "NEWARRAY", #用作引用類型
      "c6" => "NEWSTRUCT", #用作值類型
      "f0" => "THROW",
      "f1" => "THROWIFNOT"
    };

    @extended_opcodes %{
      "62" => 3,
      "63" => 3,
      "64" => 3,
      "65" => 3
    }

  def parse_script(hex_string) do
    hex_string
    |> String.slice(0..40)
    |> String.codepoints
    |> Stream.chunk(2)
    |> Enum.map(&Enum.join/1)
    |> make_list
    |> Enum.reduce("", fn(code, acc) ->
      cond do
        Map.has_key?(@opcodes_list, code) and String.length(code) == 2 ->
          newline = case code do
            "68" -> ""
            _ -> "\n"
          end
          acc <> @opcodes_list[code] <> newline
        true ->
          opcode_key = String.slice(code, 0..1)
          {opcode_keyword, push_bytes} =
            case Map.fetch(@opcodes_list, opcode_key) do
              {:ok, keyword} -> { keyword, "" }
              :error -> check_hex_num(opcode_key)
            end
          base_args = String.slice(code, 2..-1)
          args =
            cond do
              Map.has_key?(@extended_opcodes, opcode_key) -> get_jmp_num(base_args)
              push_bytes == "PUSHBYTES" -> "0x" <> base_args
              true -> base_args
            end
          acc <> push_bytes <> opcode_keyword <> " " <> args <>  "\n"
      end
    end)
    |> String.split("\n")
    |> parse_syscalls
  end

  defp get_jmp_num(args) do
    if (String.ends_with?(args, "ff")) do
      switch_args = "ffffff" <> String.slice(args, 0..1)
      {x, ""} = Integer.parse(switch_args, 16)
      <<signed_jmp_num :: integer-signed-32>> = <<x :: integer-unsigned-32>>
      to_string(signed_jmp_num)
    else
      switch_args = String.slice(args, 2..-1) <> String.slice(args, 0..1)
      {jmp_num, ""} = Integer.parse(switch_args, 16)
      to_string(jmp_num)
    end
  end

  defp check_hex_num(str) do
    case Integer.parse(str, 16) do
      {num, _} -> if (num > 1 and num < 75), do: {to_string(num), "PUSHBYTES"}, else: {"parsing error", ""}
      :error -> {"parsing error", ""}
    end
  end

  defp make_list(initial_list) do
    initial_list
    |> Enum.reduce({initial_list, []}, fn(current, {remaining, acc}) ->
      remaining_head =
        case length(remaining) do
          0 -> nil
          _ -> hd(remaining)
        end
      with true <- remaining_head == current,
        {:ok, joins} <- extend_the_opcode(current) do
          {opcodes_to_be_joined, new_remaining} = Enum.split(remaining, joins)
          joined_item = Enum.join(opcodes_to_be_joined)
          {new_remaining, [joined_item | acc]}
      else
        :error -> {tl(remaining), [current | acc]}
        false -> {remaining, acc}
      end
    end)
    |> elem(1)
    |> Enum.reverse()
  end

  defp extend_the_opcode(current) do
    case Map.fetch(@extended_opcodes, current) do
      {:ok, extend_amount} -> {:ok, extend_amount}
      :error ->
        case Integer.parse(current, 16) do
          {num, _} -> if (num > 1 and num < 75), do: {:ok, num + 1}, else: :error
          :error -> :error
        end
    end
  end

  defp parse_syscalls(list) do
    final_opcodes =
      for line <- list do
        case String.contains?(line, "SYSCALL") do
         false -> line
         true ->
           newline = Regex.replace(~r/PUSHBYTES[0-9]{1,3} 0x/, line, " ")
           split_newline = String.split(newline, " ")
           syscall_fn = case Base.decode16(Enum.at(split_newline, 1), case: :lower) do
             {:ok, syscall_arg} -> syscall_arg
             :error -> "error parsing syscall fn arg"
           end
           Enum.at(split_newline, 0) <> " " <> syscall_fn
        end
      end
    if (Enum.at(final_opcodes, length(final_opcodes)-1) == ""), do: Enum.drop(final_opcodes, -1), else: final_opcodes
  end
end
