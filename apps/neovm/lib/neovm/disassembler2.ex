defmodule NeoVM.Disassembler2 do
  @op_codes %{
    # An empty array of bytes is pushed onto the stack.
    0x00 => "PUSH0",
    # b'\x01-b'\x4B The next opcode bytes is data to be pushed onto the stack
    0x01 => "PUSHBYTES1",
    0x02 => "PUSHBYTES2",
    0x03 => "PUSHBYTES3",
    0x04 => "PUSHBYTES4",
    0x05 => "PUSHBYTES5",
    0x06 => "PUSHBYTES6",
    0x07 => "PUSHBYTES7",
    0x08 => "PUSHBYTES8",
    0x09 => "PUSHBYTES9",
    0x0A => "PUSHBYTES10",
    0x0B => "PUSHBYTES11",
    0x0C => "PUSHBYTES12",
    0x0D => "PUSHBYTES13",
    0x0E => "PUSHBYTES14",
    0x0F => "PUSHBYTES15",
    0x10 => "PUSHBYTES16",
    0x11 => "PUSHBYTES17",
    0x12 => "PUSHBYTES18",
    0x13 => "PUSHBYTES19",
    0x14 => "PUSHBYTES20",
    0x15 => "PUSHBYTES21",
    0x16 => "PUSHBYTES22",
    0x17 => "PUSHBYTES23",
    0x18 => "PUSHBYTES24",
    0x19 => "PUSHBYTES25",
    0x1A => "PUSHBYTES26",
    0x1B => "PUSHBYTES27",
    0x1C => "PUSHBYTES28",
    0x1D => "PUSHBYTES29",
    0x1E => "PUSHBYTES30",
    0x1F => "PUSHBYTES31",
    0x20 => "PUSHBYTES32",
    0x21 => "PUSHBYTES33",
    0x22 => "PUSHBYTES34",
    0x23 => "PUSHBYTES35",
    0x24 => "PUSHBYTES36",
    0x25 => "PUSHBYTES37",
    0x26 => "PUSHBYTES38",
    0x27 => "PUSHBYTES39",
    0x28 => "PUSHBYTES40",
    0x29 => "PUSHBYTES41",
    0x2A => "PUSHBYTES42",
    0x2B => "PUSHBYTES43",
    0x2C => "PUSHBYTES44",
    0x2D => "PUSHBYTES45",
    0x2E => "PUSHBYTES46",
    0x2F => "PUSHBYTES47",
    0x30 => "PUSHBYTES48",
    0x31 => "PUSHBYTES49",
    0x32 => "PUSHBYTES50",
    0x33 => "PUSHBYTES51",
    0x34 => "PUSHBYTES52",
    0x35 => "PUSHBYTES53",
    0x36 => "PUSHBYTES54",
    0x37 => "PUSHBYTES55",
    0x38 => "PUSHBYTES56",
    0x39 => "PUSHBYTES57",
    0x3A => "PUSHBYTES58",
    0x3B => "PUSHBYTES59",
    0x3C => "PUSHBYTES60",
    0x3D => "PUSHBYTES61",
    0x3E => "PUSHBYTES62",
    0x3F => "PUSHBYTES63",
    0x40 => "PUSHBYTES64",
    0x41 => "PUSHBYTES65",
    0x42 => "PUSHBYTES66",
    0x43 => "PUSHBYTES67",
    0x44 => "PUSHBYTES68",
    0x45 => "PUSHBYTES69",
    0x46 => "PUSHBYTES70",
    0x47 => "PUSHBYTES71",
    0x48 => "PUSHBYTES72",
    0x49 => "PUSHBYTES73",
    0x4A => "PUSHBYTES74",
    0x4B => "PUSHBYTES75",
    # The next byte contains the number of bytes to be pushed onto the stack.
    0x4C => "PUSHDATA1",
    # The next two bytes contain the number of bytes to be pushed onto the stack.
    0x4D => "PUSHDATA2",
    # The next four bytes contain the number of bytes to be pushed onto the stack.
    0x4E => "PUSHDATA4",
    # The number -1 is pushed onto the stack.
    0x4F => "PUSHM1",
    # The number 1 is pushed onto the stack.
    0x51 => "PUSH1",
    # The number 2 is pushed onto the stack.
    0x52 => "PUSH2",
    # The number 3 is pushed onto the stack.
    0x53 => "PUSH3",
    # The number 4 is pushed onto the stack.
    0x54 => "PUSH4",
    # The number 5 is pushed onto the stack.
    0x55 => "PUSH5",
    # The number 6 is pushed onto the stack.
    0x56 => "PUSH6",
    # The number 7 is pushed onto the stack.
    0x57 => "PUSH7",
    # The number 8 is pushed onto the stack.
    0x58 => "PUSH8",
    # The number 9 is pushed onto the stack.
    0x59 => "PUSH9",
    # The number 10 is pushed onto the stack.
    0x5A => "PUSH10",
    # The number 11 is pushed onto the stack.
    0x5B => "PUSH11",
    # The number 12 is pushed onto the stack.
    0x5C => "PUSH12",
    # The number 13 is pushed onto the stack.
    0x5D => "PUSH13",
    # The number 14 is pushed onto the stack.
    0x5E => "PUSH14",
    # The number 15 is pushed onto the stack.
    0x5F => "PUSH15",
    # The number 16 is pushed onto the stack.
    0x60 => "PUSH16",

    #  Flow control
    # Does nothing.
    0x61 => "NOP",
    0x62 => "JMP",
    0x63 => "JMPIF",
    0x64 => "JMPIFNOT",
    0x65 => "CALL",
    0x66 => "RET",
    0x67 => "APPCALL",
    0x68 => "SYSCALL",
    0x69 => "TAILCALL",

    #  Stack
    0x6A => "DUPFROMALTSTACK",
    # Puts the input onto the top of the alt stack. Removes it from the main stack.
    0x6B => "TOALTSTACK",
    # Puts the input onto the top of the main stack. Removes it from the alt stack.
    0x6C => "FROMALTSTACK",
    0x6D => "XDROP",
    0x72 => "XSWAP",
    0x73 => "XTUCK",
    # Puts the number of stack items onto the stack.
    0x74 => "DEPTH",
    # Removes the top stack item.
    0x75 => "DROP",
    # Duplicates the top stack item.
    0x76 => "DUP",
    # Removes the second-to-top stack item.
    0x77 => "NIP",
    # Copies the second-to-top stack item to the top.
    0x78 => "OVER",
    # The item n back in the stack is copied to the top.
    0x79 => "PICK",
    # The item n back in the stack is moved to the top.
    0x7A => "ROLL",
    # The top three items on the stack are rotated to the left.
    0x7B => "ROT",
    # The top two items on the stack are swapped.
    0x7C => "SWAP",
    # The item at the top of the stack is copied and inserted before the second-to-top item.
    0x7D => "TUCK",

    #  Splice
    # Concatenates two strings.
    0x7E => "CAT",
    # Returns a section of a string.
    0x7F => "SUBSTR",
    # Keeps only characters left of the specified point in a string.
    0x80 => "LEFT",
    # Keeps only characters right of the specified point in a string.
    0x81 => "RIGHT",
    # Returns the length of the input string.
    0x82 => "SIZE",

    #  Bitwise logic
    # Flips all of the bits in the input.
    0x83 => "INVERT",
    # Boolean and between each bit in the inputs.
    0x84 => "AND",
    # Boolean or between each bit in the inputs.
    0x85 => "OR",
    # Boolean exclusive or between each bit in the inputs.
    0x86 => "XOR",
    # Returns 1 if the inputs are exactly equal, 0 otherwise.
    0x87 => "EQUAL",
    # OP_EQUALVERIFY => 0x88, #  Same as OP_EQUAL, but runs OP_VERIFY afterward.
    # OP_RESERVED1 => 0x89, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch
    # OP_RESERVED2 => 0x8A, #  Transaction is invalid unless occuring in an unexecuted OP_IF branch

    #  Arithmetic
    #  Note: Arithmetic inputs are limited to signed 32-bit integers, but may overflow their output.
    # 1 is added to the input.
    0x8B => "INC",
    # 1 is subtracted from the input.
    0x8C => "DEC",
    0x8D => "SIGN",
    # The sign of the input is flipped.
    0x8F => "NEGATE",
    # The input is made positive.
    0x90 => "ABS",
    # If the input is 0 or 1, it is flipped. Otherwise the output will be 0.
    0x91 => "NOT",
    # Returns 0 if the input is 0. 1 otherwise.
    0x92 => "NZ",
    # a is added to b.
    0x93 => "ADD",
    # b is subtracted from a.
    0x94 => "SUB",
    # a is multiplied by b.
    0x95 => "MUL",
    # a is divided by b.
    0x96 => "DIV",
    # Returns the remainder after dividing a by b.
    0x97 => "MOD",
    # Shifts a left b bits, preserving sign.
    0x98 => "SHL",
    # Shifts a right b bits, preserving sign.
    0x99 => "SHR",
    # If both a and b are not 0, the output is 1. Otherwise 0.
    0x9A => "BOOLAND",
    # If a or b is not 0, the output is 1. Otherwise 0.
    0x9B => "BOOLOR",
    # Returns 1 if the numbers are equal, 0 otherwise.
    0x9C => "NUMEQUAL",
    # Returns 1 if the numbers are not equal, 0 otherwise.
    0x9E => "NUMNOTEQUAL",
    # Returns 1 if a is less than b, 0 otherwise.
    0x9F => "LT",
    # Returns 1 if a is greater than b, 0 otherwise.
    0xA0 => "GT",
    # Returns 1 if a is less than or equal to b, 0 otherwise.
    0xA1 => "LTE",
    # Returns 1 if a is greater than or equal to b, 0 otherwise.
    0xA2 => "GTE",
    # Returns the smaller of a and b.
    0xA3 => "MIN",
    # Returns the larger of a and b.
    0xA4 => "MAX",
    # Returns 1 if x is within the specified range (left-inclusive), 0 otherwise.
    0xA5 => "WITHIN",

    #  Crypto
    # RIPEMD160 => 0xA6, #  The input is hashed using RIPEMD-160.
    # The input is hashed using SHA-1.
    0xA7 => "SHA1",
    # The input is hashed using SHA-256.
    0xA8 => "SHA256",
    0xA9 => "HASH160",
    0xAA => "HASH256",
    0xAC => "CHECKSIG",
    0xAD => "VERIFY",
    0xAE => "CHECKMULTISIG",

    #  Array
    0xC0 => "ARRAYSIZE",
    0xC1 => "PACK",
    0xC2 => "UNPACK",
    0xC3 => "PICKITEM",
    0xC4 => "SETITEM",
    # Used as a reference type
    0xC5 => "NEWARRAY",
    # Used as a value type
    0xC6 => "NEWSTRUCT",
    0xC7 => "NEWMAP",
    0xC8 => "APPEND",
    0xC9 => "REVERSE",
    0xCA => "REMOVE",
    0xCB => "HASKEY",
    0xCC => "KEYS",
    0xCD => "VALUES",

    # Exceptions
    0xF0 => "THROW",
    0xF1 => "THROWIFNOT"
  }

  @_PUSHBYTES1 elem(Enum.find(@op_codes, &(elem(&1, 1) == "PUSHBYTES1")), 0)
  @_PUSHBYTES75 elem(Enum.find(@op_codes, &(elem(&1, 1) == "PUSHBYTES75")), 0)
  @_PUSH1 elem(Enum.find(@op_codes, &(elem(&1, 1) == "PUSH1")), 0)
  @_PUSH16 elem(Enum.find(@op_codes, &(elem(&1, 1) == "PUSH16")), 0)
  @_PACK elem(Enum.find(@op_codes, &(elem(&1, 1) == "PACK")), 0)
  @_ADD elem(Enum.find(@op_codes, &(elem(&1, 1) == "ADD")), 0)

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

  def do_execute(<<@_ADD, rest::binary>>, %{stack: [x2, x1 | stack]} = state) do
    value = get_little_signed_integer(x1) + get_little_signed_integer(x2)
    {rest, %{state | stack: [value | stack]}}
  end

  def get_little_signed_integer(value) do
    size = byte_size(value) * 8
    <<x::signed-little-integer-size(size)>> = value
    x
  end
end
