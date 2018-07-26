defmodule NeoVM.ExecutionEngine do
  import Bitwise

  # An empty array of bytes is pushed onto the stack.
  #  @_PUSH0 0x00
  # b'\x01-b'\x4B The next opcode bytes is data to be pushed onto the stack
  @_PUSHBYTES1 0x01
  #  @_PUSHBYTES2 0x02
  #  @_PUSHBYTES3 0x03
  #  @_PUSHBYTES4 0x04
  #  @_PUSHBYTES5 0x05
  #  @_PUSHBYTES6 0x06
  #  @_PUSHBYTES7 0x07
  #  @_PUSHBYTES8 0x08
  #  @_PUSHBYTES9 0x09
  #  @_PUSHBYTES10 0x0A
  #  @_PUSHBYTES11 0x0B
  #  @_PUSHBYTES12 0x0C
  #  @_PUSHBYTES13 0x0D
  #  @_PUSHBYTES14 0x0E
  #  @_PUSHBYTES15 0x0F
  #  @_PUSHBYTES16 0x10
  #  @_PUSHBYTES17 0x11
  #  @_PUSHBYTES18 0x12
  #  @_PUSHBYTES19 0x13
  #  @_PUSHBYTES20 0x14
  #  @_PUSHBYTES21 0x15
  #  @_PUSHBYTES22 0x16
  #  @_PUSHBYTES23 0x17
  #  @_PUSHBYTES24 0x18
  #  @_PUSHBYTES25 0x19
  #  @_PUSHBYTES26 0x1A
  #  @_PUSHBYTES27 0x1B
  #  @_PUSHBYTES28 0x1C
  #  @_PUSHBYTES29 0x1D
  #  @_PUSHBYTES30 0x1E
  #  @_PUSHBYTES31 0x1F
  #  @_PUSHBYTES32 0x20
  #  @_PUSHBYTES33 0x21
  #  @_PUSHBYTES34 0x22
  #  @_PUSHBYTES35 0x23
  #  @_PUSHBYTES36 0x24
  #  @_PUSHBYTES37 0x25
  #  @_PUSHBYTES38 0x26
  #  @_PUSHBYTES39 0x27
  #  @_PUSHBYTES40 0x28
  #  @_PUSHBYTES41 0x29
  #  @_PUSHBYTES42 0x2A
  #  @_PUSHBYTES43 0x2B
  #  @_PUSHBYTES44 0x2C
  #  @_PUSHBYTES45 0x2D
  #  @_PUSHBYTES46 0x2E
  #  @_PUSHBYTES47 0x2F
  #  @_PUSHBYTES48 0x30
  #  @_PUSHBYTES49 0x31
  #  @_PUSHBYTES50 0x32
  #  @_PUSHBYTES51 0x33
  #  @_PUSHBYTES52 0x34
  #  @_PUSHBYTES53 0x35
  #  @_PUSHBYTES54 0x36
  #  @_PUSHBYTES55 0x37
  #  @_PUSHBYTES56 0x38
  #  @_PUSHBYTES57 0x39
  #  @_PUSHBYTES58 0x3A
  #  @_PUSHBYTES59 0x3B
  #  @_PUSHBYTES60 0x3C
  #  @_PUSHBYTES61 0x3D
  #  @_PUSHBYTES62 0x3E
  #  @_PUSHBYTES63 0x3F
  #  @_PUSHBYTES64 0x40
  #  @_PUSHBYTES65 0x41
  #  @_PUSHBYTES66 0x42
  #  @_PUSHBYTES67 0x43
  #  @_PUSHBYTES68 0x44
  #  @_PUSHBYTES69 0x45
  #  @_PUSHBYTES70 0x46
  #  @_PUSHBYTES71 0x47
  #  @_PUSHBYTES72 0x48
  #  @_PUSHBYTES73 0x49
  #  @_PUSHBYTES74 0x4A
  @_PUSHBYTES75 0x4B
  #  # The next byte contains the number of bytes to be pushed onto the stack.
  #  @_PUSHDATA1 0x4C
  #  # The next two bytes contain the number of bytes to be pushed onto the stack.
  #  @_PUSHDATA2 0x4D
  #  # The next four bytes contain the number of bytes to be pushed onto the stack.
  #  @_PUSHDATA4 0x4E
  #  # The number -1 is pushed onto the stack.
  #  @_PUSHM1 0x4F
  # The number 1 is pushed onto the stack.
  @_PUSH1 0x51
  #  # The number 2 is pushed onto the stack.
  #  @_PUSH2 0x52
  #  # The number 3 is pushed onto the stack.
  #  @_PUSH3 0x53
  #  # The number 4 is pushed onto the stack.
  #  @_PUSH4 0x54
  #  # The number 5 is pushed onto the stack.
  #  @_PUSH5 0x55
  #  # The number 6 is pushed onto the stack.
  #  @_PUSH6 0x56
  #  # The number 7 is pushed onto the stack.
  #  @_PUSH7 0x57
  #  # The number 8 is pushed onto the stack.
  #  @_PUSH8 0x58
  #  # The number 9 is pushed onto the stack.
  #  @_PUSH9 0x59
  #  # The number 10 is pushed onto the stack.
  #  @_PUSH10 0x5A
  #  # The number 11 is pushed onto the stack.
  #  @_PUSH11 0x5B
  #  # The number 12 is pushed onto the stack.
  #  @_PUSH12 0x5C
  #  # The number 13 is pushed onto the stack.
  #  @_PUSH13 0x5D
  #  # The number 14 is pushed onto the stack.
  #  @_PUSH14 0x5E
  #  # The number 15 is pushed onto the stack.
  #  @_PUSH15 0x5F
  # The number 16 is pushed onto the stack.
  @_PUSH16 0x60

  #  #  Flow control
  #  # Does nothing.
  #  @_NOP 0x61
  #  @_JMP 0x62
  #  @_JMPIF 0x63
  #  @_JMPIFNOT 0x64
  #  @_CALL 0x65
  #  @_RET 0x66
  #  @_APPCALL 0x67
  #  @_SYSCALL 0x68
  #  @_TAILCALL 0x69
  #
  #  #  Stack
  #  @_DUPFROMALTSTACK 0x6A
  #  # Puts the input onto the top of the alt stack. Removes it from the main stack.
  #  @_TOALTSTACK 0x6B
  #  # Puts the input onto the top of the main stack. Removes it from the alt stack.
  #  @_FROMALTSTACK 0x6C
  #  @_XDROP 0x6D
  #  @_XSWAP 0x72
  #  @_XTUCK 0x73
  #  # Puts the number of stack items onto the stack.
  #  @_DEPTH 0x74
  #  # Removes the top stack item.
  #  @_DROP 0x75
  #  # Duplicates the top stack item.
  #  @_DUP 0x76
  #  # Removes the second-to-top stack item.
  #  @_NIP 0x77
  #  # Copies the second-to-top stack item to the top.
  #  @_OVER 0x78
  #  # The item n back in the stack is copied to the top.
  #  @_PICK 0x79
  #  # The item n back in the stack is moved to the top.
  #  @_ROLL 0x7A
  #  # The top three items on the stack are rotated to the left.
  #  @_ROT 0x7B
  #  # The top two items on the stack are swapped.
  #  @_SWAP 0x7C
  #  # The item at the top of the stack is copied and inserted before the second-to-top item.
  #  @_TUCK 0x7D
  #
  #  #  Splice
  #  # Concatenates two strings.
  #  @_CAT 0x7E
  #  # Returns a section of a string.
  #  @_SUBSTR 0x7F
  #  # Keeps only characters left of the specified point in a string.
  #  @_LEFT 0x80
  #  # Keeps only characters right of the specified point in a string.
  #  @_RIGHT 0x81
  #  # Returns the length of the input string.
  #  @_SIZE 0x82
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
  #  # Returns 1 if the inputs are exactly equal, 0 otherwise.
  #  @_EQUAL 0x87
  #  # @_OP_EQUALVERIFY 0x88, #  Same as OP_EQUAL, but runs OP_VERIFY afterward.
  #  # @_OP_RESERVED1 0x89, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch
  #  # @_OP_RESERVED2 0x8A, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch
  #
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
  #  # If both a and b are not 0, the output is 1. Otherwise 0.
  #  @_BOOLAND 0x9A
  #  # If a or b is not 0, the output is 1. Otherwise 0.
  #  @_BOOLOR 0x9B
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
  #
  #  #  Crypto
  #  # @_RIPEMD160 0xA6, #  The input is hashed using RIPEMD-160.
  #  # The input is hashed using SHA-1.
  #  @_SHA1 0xA7
  #  # The input is hashed using SHA-256.
  #  @_SHA256 0xA8
  #  @_HASH160 0xA9
  #  @_HASH256 0xAA
  #  @_CHECKSIG 0xAC
  #  @_VERIFY 0xAD
  #  @_CHECKMULTISIG 0xAE
  #
  #  #  Array
  #  @_ARRAYSIZE 0xC0
  @_PACK 0xC1
  #  @_UNPACK 0xC2
  #  @_PICKITEM 0xC3
  #  @_SETITEM 0xC4
  #  # Used as a reference type
  #  @_NEWARRAY 0xC5
  #  # Used as a value type
  #  @_NEWSTRUCT 0xC6
  #  @_NEWMAP 0xC7
  #  @_APPEND 0xC8
  #  @_REVERSE 0xC9
  #  @_REMOVE 0xCA
  #  @_HASKEY 0xCB
  #  @_KEYS 0xCC
  #  @_VALUES 0xCD
  #
  #  # Exceptions
  #  @_THROW 0xF0
  #  @_THROWIFNOT 0xF1

  def execute(binary) do
    execute(binary, %{stack: []})
  end

  def execute(<<>>, state), do: state

  def execute(binary, state) do
    {rest, state} = do_execute(binary, state)
    execute(rest, state)
  end

  def do_execute(<<opcode, value::binary-size(opcode), rest::binary>>, state)
      when opcode >= @_PUSHBYTES1 and opcode <= @_PUSHBYTES75 do
    {rest, %{state | stack: [value | state.stack]}}
  end

  def do_execute(<<opcode, rest::binary>>, state) when opcode >= @_PUSH1 and opcode <= @_PUSH16 do
    {rest, %{state | stack: [opcode - @_PUSH1 + 1 | state.stack]}}
  end

  def do_execute(<<@_PACK, rest::binary>>, %{stack: [size | stack]} = state) do
    {list, stack} = Enum.split(stack, size)
    {rest, %{state | stack: [list | stack]}}
  end

  def do_execute(<<opcode, rest::binary>>, %{stack: [x1 | stack]} = state)
      when opcode == @_INVERT or (opcode >= @_INC and opcode <= @_NZ) do
    {rest, %{state | stack: [do_execute_integer_1(opcode, get_integer(x1)) | stack]}}
  end

  def do_execute(<<opcode, rest::binary>>, %{stack: [x2, x1 | stack]} = state)
      when (opcode >= @_ADD and opcode <= @_SHR) or (opcode >= @_NUMEQUAL and opcode <= @_MAX) or
             (opcode >= @_AND and opcode <= @_XOR) do
    {rest,
     %{state | stack: [do_execute_integer_2(opcode, get_integer(x1), get_integer(x2)) | stack]}}
  end

  def do_execute(<<@_WITHIN, rest::binary>>, %{stack: [b, a, x | stack]} = state) do
    {rest,
     %{
       state
       | stack: [get_integer(a) <= get_integer(x) and get_integer(x) < get_integer(b) | stack]
     }}
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
  def do_execute_integer_2(@_SHL, x1, x2), do: x1 <<< x2
  def do_execute_integer_2(@_SHR, x1, x2), do: x1 >>> x2
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
end
