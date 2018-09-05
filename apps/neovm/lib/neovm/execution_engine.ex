defmodule NeoVM.ExecutionEngine do
  import Bitwise
  alias NeoVM.Crypto

  # An empty array of bytes is pushed onto the stack.
  @_PUSH0 0x00
  # b'\x01-b'\x4B The next opcode bytes is data to be pushed onto the stack
  @_PUSHBYTES1 0x01
  @_PUSHBYTES75 0x4B
  # The next byte contains the number of bytes to be pushed onto the stack.
  @_PUSHDATA1 0x4C
  # The next two bytes contain the number of bytes to be pushed onto the stack.
  @_PUSHDATA2 0x4D
  # The next four bytes contain the number of bytes to be pushed onto the stack.
  @_PUSHDATA4 0x4E
  # The number -1 is pushed onto the stack.
  @_PUSHM1 0x4F
  # The number 1 is pushed onto the stack.
  @_PUSH1 0x51
  # The number 16 is pushed onto the stack.
  @_PUSH16 0x60

  #  Flow control
  # Does nothing.
  @_NOP 0x61
  @_JMP 0x62
  @_JMPIF 0x63
  @_JMPIFNOT 0x64
  #  @_CALL 0x65
  #  @_RET 0x66
  #  @_APPCALL 0x67
  #  @_SYSCALL 0x68
  #  @_TAILCALL 0x69

  #  Stack
  @_DUPFROMALTSTACK 0x6A
  # Puts the input onto the top of the alt stack. Removes it from the main stack.
  @_TOALTSTACK 0x6B
  # Puts the input onto the top of the main stack. Removes it from the alt stack.
  @_FROMALTSTACK 0x6C
  @_XDROP 0x6D
  @_XSWAP 0x72
  @_XTUCK 0x73
  # Puts the number of stack items onto the stack.
  @_DEPTH 0x74
  # Removes the top stack item.
  @_DROP 0x75
  # Duplicates the top stack item.
  @_DUP 0x76
  # Removes the second-to-top stack item.
  @_NIP 0x77
  # Copies the second-to-top stack item to the top.
  @_OVER 0x78
  # The item n back in the stack is copied to the top.
  @_PICK 0x79
  # The item n back in the stack is moved to the top.
  @_ROLL 0x7A
  # The top three items on the stack are rotated to the left.
  @_ROT 0x7B
  # The top two items on the stack are swapped.
  @_SWAP 0x7C
  # The item at the top of the stack is copied and inserted before the second-to-top item.
  @_TUCK 0x7D

  #  Splice
  # Concatenates two strings.
  @_CAT 0x7E
  # Returns a section of a string.
  @_SUBSTR 0x7F
  # Keeps only characters left of the specified point in a string.
  @_LEFT 0x80
  # Keeps only characters right of the specified point in a string.
  @_RIGHT 0x81
  # Returns the length of the input string.
  @_SIZE 0x82
  #
  #  Bitwise logic
  # Flips all of the bits in the input.
  @_INVERT 0x83
  # Boolean and between each bit in the inputs.
  @_AND 0x84
  # Boolean or between each bit in the inputs.
  @_OR 0x85
  # Boolean exclusive or between each bit in the inputs.
  @_XOR 0x86
  # Returns 1 if the inputs are exactly equal, 0 otherwise.
  @_EQUAL 0x87
  # @_OP_EQUALVERIFY 0x88, #  Same as OP_EQUAL, but runs OP_VERIFY afterward.
  # @_OP_RESERVED1 0x89, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch
  # @_OP_RESERVED2 0x8A, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch

  #  Arithmetic
  #  Note: Arithmetic inputs are limited to signed 32-bit integers, but may overflow their output.
  # 1 is added to the input.
  @_INC 0x8B
  # 1 is subtracted from the input.
  @_DEC 0x8C
  @_SIGN 0x8D
  # The sign of the input is flipped.
  @_NEGATE 0x8F
  # The input is made positive.
  @_ABS 0x90
  # If the input is 0 or 1, it is flipped. Otherwise the output will be 0.
  @_NOT 0x91
  # Returns 0 if the input is 0. 1 otherwise.
  @_NZ 0x92
  # a is added to b.
  @_ADD 0x93
  # b is subtracted from a.
  @_SUB 0x94
  # a is multiplied by b.
  @_MUL 0x95
  # a is divided by b.
  @_DIV 0x96
  # Returns the remainder after dividing a by b.
  @_MOD 0x97
  # Shifts a left b bits, preserving sign.
  @_SHL 0x98
  # Shifts a right b bits, preserving sign.
  @_SHR 0x99
  # If both a and b are not 0, the output is 1. Otherwise 0.
  @_BOOLAND 0x9A
  # If a or b is not 0, the output is 1. Otherwise 0.
  @_BOOLOR 0x9B
  # Returns 1 if the numbers are equal, 0 otherwise.
  @_NUMEQUAL 0x9C
  # Returns 1 if the numbers are not equal, 0 otherwise.
  @_NUMNOTEQUAL 0x9E
  # Returns 1 if a is less than b, 0 otherwise.
  @_LT 0x9F
  # Returns 1 if a is greater than b, 0 otherwise.
  @_GT 0xA0
  # Returns 1 if a is less than or equal to b, 0 otherwise.
  @_LTE 0xA1
  # Returns 1 if a is greater than or equal to b, 0 otherwise.
  @_GTE 0xA2
  # Returns the smaller of a and b.
  @_MIN 0xA3
  # Returns the larger of a and b.
  @_MAX 0xA4
  # Returns 1 if x is within the specified range (left-inclusive), 0 otherwise.
  @_WITHIN 0xA5

  #  Crypto
  #  The input is hashed using RIPEMD-160.
  @_RIPEMD160 0xA6
  # The input is hashed using SHA-1.
  @_SHA1 0xA7
  # The input is hashed using SHA-256.
  @_SHA256 0xA8
  @_HASH160 0xA9
  @_HASH256 0xAA
  #  @_CHECKSIG 0xAC
  #  @_VERIFY 0xAD
  #  @_CHECKMULTISIG 0xAE

  #  Array
  @_ARRAYSIZE 0xC0
  @_PACK 0xC1
  @_UNPACK 0xC2
  @_PICKITEM 0xC3
  @_SETITEM 0xC4
  # Used as a reference type
  @_NEWARRAY 0xC5
  # Used as a value type
  @_NEWSTRUCT 0xC6
  @_NEWMAP 0xC7
  @_APPEND 0xC8
  @_REVERSE 0xC9
  @_REMOVE 0xCA
  @_HASKEY 0xCB
  @_KEYS 0xCC
  @_VALUES 0xCD

  # Exceptions
  @_THROW 0xF0
  @_THROWIFNOT 0xF1

  defguard is_integer_1_op(opcode) when opcode == @_INVERT or (opcode >= @_INC and opcode <= @_NZ)

  defguard is_integer_2_op(opcode)
           when (opcode >= @_ADD and opcode <= @_SHR) or
                  (opcode >= @_NUMEQUAL and opcode <= @_MAX) or
                  (opcode >= @_AND and opcode <= @_XOR)

  defmodule VmFaultError do
    defexception message: "Error while executing code"
  end

  def execute(binary) do
    state = %{alt_stack: [], evaluation_stack: []}

    case execute(binary, 0, state) do
      %{evaluation_stack: evaluation_stack} ->
        evaluation_stack

      otherwise ->
        otherwise
    end
  end

  def execute(binary, cursor, state) when cursor == byte_size(binary), do: state

  def execute(binary, cursor, state) do
    <<_::binary-size(cursor), rest::binary>> = binary

    try do
      {cursor, state} = do_execute(rest, cursor, state)
      execute(binary, cursor, state)
    rescue
      error ->
        {:error, error}
    end
  end

  def do_execute(<<opcode, value::binary-size(opcode), _::binary>>, cursor, state)
      when opcode >= @_PUSHBYTES1 and opcode <= @_PUSHBYTES75 do
    {cursor + opcode + 1, %{state | evaluation_stack: [value | state.evaluation_stack]}}
  end

  def do_execute(<<@_PUSHDATA1, size, data::binary-size(size), _::binary>>, cursor, state) do
    {cursor + size + 2, %{state | evaluation_stack: [data | state.evaluation_stack]}}
  end

  def do_execute(
        <<@_PUSHDATA2, size::integer-size(16), data::binary-size(size), _::binary>>,
        cursor,
        state
      ) do
    {cursor + size + 3, %{state | evaluation_stack: [data | state.evaluation_stack]}}
  end

  def do_execute(
        <<@_PUSHDATA4, size::integer-size(32), data::binary-size(size), _::binary>>,
        cursor,
        state
      ) do
    {cursor + size + 5, %{state | evaluation_stack: [data | state.evaluation_stack]}}
  end

  def do_execute(<<opcode, offset::signed-integer-size(16), rest::binary>>, cursor, state)
      when cursor + offset >= 0 and byte_size(rest) >= cursor and opcode >= @_JMP and
             opcode <= @_JMPIFNOT do
    case opcode do
      @_JMP ->
        {cursor + offset, state}

      _ ->
        [boolean | stack] = state.evaluation_stack
        offset = if get_boolean(boolean) == (@_JMPIF == opcode), do: offset, else: 3
        {cursor + offset, %{state | evaluation_stack: stack}}
    end
  end

  def do_execute(<<@_DUPFROMALTSTACK, _::binary>>, cursor, %{alt_stack: [item | _]} = state) do
    {cursor + 1, %{state | evaluation_stack: [item | state.evaluation_stack]}}
  end

  def do_execute(
        <<@_TOALTSTACK, _::binary>>,
        cursor,
        %{evaluation_stack: [item | evaluation_stack]} = state
      ) do
    {cursor + 1,
     %{state | alt_stack: [item | state.alt_stack], evaluation_stack: evaluation_stack}}
  end

  def do_execute(<<@_FROMALTSTACK, _::binary>>, cursor, %{alt_stack: [item | alt_stack]} = state) do
    {cursor + 1,
     %{state | alt_stack: alt_stack, evaluation_stack: [item | state.evaluation_stack]}}
  end

  def do_execute(<<opcode, _::binary>>, cursor, state),
    do: {cursor + 1, %{state | evaluation_stack: do_execute(opcode, state.evaluation_stack)}}

  def do_execute(@_PUSH0, stack), do: [<<>> | stack]

  def do_execute(opcode, stack) when opcode >= @_PUSH1 and opcode <= @_PUSH16 do
    [opcode - @_PUSH1 + 1 | stack]
  end

  def do_execute(@_PUSHM1, stack), do: [-1 | stack]
  def do_execute(@_NOP, stack), do: stack

  def do_execute(@_XDROP, [n | stack]) do
    n = get_integer(n)

    if n >= 0 and n < length(stack) do
      List.delete_at(stack, get_integer(n))
    else
      raise(VmFaultError, message: "XDROP out of range")
    end
  end

  def do_execute(@_XSWAP, [n | [head | _] = stack]) do
    n = get_integer(n)

    if n >= 0 and n < length(stack) do
      stack
      |> List.replace_at(0, Enum.at(stack, n))
      |> List.replace_at(n, head)
    else
      raise(VmFaultError, message: "XSWAP out of range")
    end
  end

  def do_execute(@_XTUCK, [n | [head | _] = stack]) do
    n = get_integer(n)

    if n >= 0 and n < length(stack) do
      List.insert_at(stack, n, head)
    else
      raise(VmFaultError, message: "XTUCK out of range")
    end
  end

  def do_execute(@_DEPTH, stack), do: [length(stack) | stack]
  def do_execute(@_DROP, [_ | stack]), do: stack
  def do_execute(@_DUP, [head | stack]), do: [head, head | stack]
  def do_execute(@_NIP, [head, _ | stack]), do: [head | stack]
  def do_execute(@_OVER, [x2, x1 | stack]), do: [x1, x2, x1 | stack]

  def do_execute(@_PICK, [n | stack]) do
    n = get_integer(n)

    if n >= 0 and n < length(stack) do
      [Enum.at(stack, n) | stack]
    else
      raise(VmFaultError, message: "PICK out of range")
    end
  end

  def do_execute(@_ROLL, [n | stack]) do
    n = get_integer(n)

    if n >= 0 and n < length(stack) do
      [Enum.at(stack, n) | List.delete_at(stack, n)]
    else
      raise(VmFaultError, message: "ROLL out of range")
    end
  end

  def do_execute(@_ROT, [x3, x2, x1 | stack]), do: [x1, x3, x2 | stack]
  def do_execute(@_SWAP, [x2, x1 | stack]), do: [x1, x2 | stack]
  def do_execute(@_TUCK, [x2, x1 | stack]), do: [x2, x1, x2 | stack]

  def do_execute(@_CAT, [binary2, binary1 | stack]) do
    [get_binary(binary1) <> get_binary(binary2) | stack]
  end

  def do_execute(@_SUBSTR, [count, index, binary | stack]) when index >= 0 and count >= 0 do
    [String.slice(get_binary(binary), get_integer(index), get_integer(count)) | stack]
  end

  def do_execute(@_LEFT, [index, binary | stack]) when index >= 0 do
    [elem(String.split_at(get_binary(binary), get_integer(index)), 0) | stack]
  end

  def do_execute(@_RIGHT, [index, binary | stack]) when index >= 0 do
    [elem(String.split_at(get_binary(binary), get_integer(index)), 1) | stack]
  end

  def do_execute(@_SIZE, [binary | stack]) do
    [byte_size(get_binary(binary)) | stack]
  end

  def do_execute(opcode, [x1 | stack]) when is_integer_1_op(opcode) do
    [do_execute_integer_1(opcode, get_integer(x1)) | stack]
  end

  def do_execute(opcode, [x2, x1 | stack]) when is_integer_2_op(opcode) do
    [do_execute_integer_2(opcode, get_integer(x1), get_integer(x2)) | stack]
  end

  def do_execute(@_WITHIN, [b, a, x | stack]) do
    [get_integer(a) <= get_integer(x) and get_integer(x) < get_integer(b) | stack]
  end

  def do_execute(@_EQUAL, [b, a | stack]), do: [a == b | stack]
  def do_execute(@_BOOLAND, [b, a | stack]), do: [get_boolean(a) and get_boolean(b) | stack]
  def do_execute(@_BOOLOR, [b, a | stack]), do: [get_boolean(a) or get_boolean(b) | stack]

  def do_execute(@_ARRAYSIZE, [value | stack]) when is_binary(value) do
    [byte_size(value) | stack]
  end

  def do_execute(@_ARRAYSIZE, [value | stack]) when is_list(value) or is_map(value) do
    [Enum.count(value) | stack]
  end

  def do_execute(@_PACK, [size | stack]) do
    {list, stack} = Enum.split(stack, size)
    [list | stack]
  end

  def do_execute(@_UNPACK, [value | stack]) when is_list(value) do
    [Enum.count(value) | value ++ stack]
  end

  def do_execute(@_PICKITEM, [index, list | stack]) when is_list(list) do
    [Enum.at(list, index) | stack]
  end

  def do_execute(@_PICKITEM, [key, map | stack]) when is_map(map) do
    [Map.get(map, key) | stack]
  end

  def do_execute(@_SETITEM, [value, key, map | stack]) when is_map(map) do
    [Map.put(map, key, value) | stack]
  end

  def do_execute(@_SETITEM, [value, index, list | stack]) when is_list(list) do
    [List.replace_at(list, index, value) | stack]
  end

  def do_execute(@_NEWARRAY, [size | stack]), do: [List.duplicate(0, size) | stack]
  def do_execute(@_NEWSTRUCT, [size | stack]), do: [List.duplicate(false, size) | stack]
  def do_execute(@_NEWMAP, stack), do: [%{} | stack]
  def do_execute(@_APPEND, [item, list | stack]) when is_list(list), do: [[item | list] | stack]
  def do_execute(@_REVERSE, [list | stack]) when is_list(list), do: [Enum.reverse(list) | stack]

  def do_execute(@_REMOVE, [index, list | stack])
      when is_list(list) and index >= 0 and index < length(list) do
    [List.delete_at(list, index) | stack]
  end

  def do_execute(@_REMOVE, [key, map | stack]) when is_map(map) do
    [Map.delete(map, key) | stack]
  end

  def do_execute(@_HASKEY, [index, list | stack]) when is_list(list) and index >= 0 do
    [index < length(list) | stack]
  end

  def do_execute(@_HASKEY, [key, map | stack]) when is_map(map) do
    [Map.has_key?(map, key) | stack]
  end

  def do_execute(@_KEYS, [map | stack]) when is_map(map), do: [Map.keys(map) | stack]
  def do_execute(@_VALUES, [map | stack]) when is_map(map), do: [Map.values(map) | stack]
  def do_execute(@_VALUES, [list | stack]) when is_list(list), do: [list | stack]

  def do_execute(@_SHA256, [x | stack]), do: [Crypto.sha256(get_binary(x)) | stack]
  def do_execute(@_SHA1, [x | stack]), do: [Crypto.sha1(get_binary(x)) | stack]
  def do_execute(@_RIPEMD160, [x | stack]), do: [Crypto.ripemd160(get_binary(x)) | stack]
  def do_execute(@_HASH160, [x | stack]), do: [Crypto.hash160(get_binary(x)) | stack]
  def do_execute(@_HASH256, [x | stack]), do: [Crypto.hash256(get_binary(x)) | stack]

  def do_execute(@_THROW, _) do
    raise VmFaultError, message: "THROW"
  end

  def do_execute(@_THROWIFNOT, [boolean | stack]) do
    if get_boolean(boolean), do: stack, else: raise(VmFaultError, message: "THROW")
  end

  def do_execute(opcode, stack) do
    raise VmFaultError,
      message: """
      opcode: #{Base.encode16(<<opcode>>)}
      stack: #{inspect(stack)}
      """
  end

  def do_execute_integer_1(@_INVERT, x1), do: ~~~x1
  def do_execute_integer_1(@_INC, x1), do: x1 + 1
  def do_execute_integer_1(@_DEC, x1), do: x1 - 1

  def do_execute_integer_1(@_SIGN, x1) when x1 > 0, do: 1
  def do_execute_integer_1(@_SIGN, 0), do: 0
  def do_execute_integer_1(@_SIGN, _), do: -1

  def do_execute_integer_1(@_NEGATE, x1), do: -x1
  def do_execute_integer_1(@_ABS, x1), do: abs(x1)

  def do_execute_integer_1(@_NOT, 0), do: 1
  def do_execute_integer_1(@_NOT, 1), do: 0
  def do_execute_integer_1(@_NOT, _), do: 0

  def do_execute_integer_1(@_NZ, 0), do: 0
  def do_execute_integer_1(@_NZ, _), do: 1

  def do_execute_integer_2(@_AND, x1, x2), do: band(x1, x2)
  def do_execute_integer_2(@_OR, x1, x2), do: bor(x1, x2)
  def do_execute_integer_2(@_XOR, x1, x2), do: bxor(x1, x2)
  def do_execute_integer_2(@_ADD, x1, x2), do: x1 + x2
  def do_execute_integer_2(@_SUB, x1, x2), do: x1 - x2
  def do_execute_integer_2(@_MUL, x1, x2), do: x1 * x2
  def do_execute_integer_2(@_DIV, x1, x2), do: x1 / x2
  def do_execute_integer_2(@_MOD, x1, x2), do: rem(x1, x2)

  def do_execute_integer_2(@_SHL, x1, x2),
    do: x1 <<< x2

  def do_execute_integer_2(@_SHR, x1, x2),
    do: x1 >>> x2

  def do_execute_integer_2(@_NUMEQUAL, x1, x2), do: x1 == x2
  def do_execute_integer_2(@_NUMNOTEQUAL, x1, x2), do: x1 != x2
  def do_execute_integer_2(@_LT, x1, x2), do: x1 < x2
  def do_execute_integer_2(@_GT, x1, x2), do: x1 > x2
  def do_execute_integer_2(@_LTE, x1, x2), do: x1 <= x2
  def do_execute_integer_2(@_GTE, x1, x2), do: x1 >= x2
  def do_execute_integer_2(@_MIN, x1, x2), do: min(x1, x2)
  def do_execute_integer_2(@_MAX, x1, x2), do: max(x1, x2)

  defp get_integer(value) when is_integer(value), do: value

  defp get_integer(value) when is_binary(value) do
    size = byte_size(value) * 8
    <<x::signed-little-integer-size(size)>> = value
    x
  end

  defp get_boolean(value) when is_boolean(value), do: value
  defp get_boolean(0), do: false
  defp get_boolean(value) when is_integer(value), do: true
  defp get_boolean(value) when is_binary(value), do: get_boolean(get_integer(value))

  # Convert stackitems to binary
  defp get_binary(true), do: <<1>>
  defp get_binary(false), do: <<0>>
  defp get_binary(x) when is_binary(x), do: x
  defp get_binary(x) when is_integer(x), do: :binary.encode_unsigned(x, :big)
end
