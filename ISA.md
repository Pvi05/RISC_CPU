# Instruction Set Architecture & Assembly

## Registers and values

This architecture provides 14 general-purpose registers. These are
referred in assembly from `R0` to `R14`.

In addition to those, the architecture provides 3 special purpose
registers.

- `sp` : Stack pointer, which is initialized at 255, and automatically
  handled by the stack manipulation instructions.
- `lr` : Link register, which provides flexibility when handling
  function, and is used by the return instruction to store the return
  address before jumping.
- `pc` : Program counter, which is automatically increased by 4 every
  instruction, and used by jump instructions. *Warning* : For easier
  function handling (see below), the value actually used when calling it
  will refer to the Byte Code two lines below.

The assembler will interpret numerals as immediate values, and other
literals are assumed labels (meaning they must be defined later). The
assembler handles immediate values written as decimal (eg: `10`),
hexadecimal (eg: `0x0A`) or binary(eg: `0b00001010`).

## Basic Arithmetic & Logic

Usual basic arithmetic and logic are available as instructions. They are
used (except for the `NOT`) with one destination register, and 2
operands, either immediate or registers. A proper addition of R1's value
and 1 into R0 may therefore be written as : `ADD R0 R1 1`

Available operations are :

- `ADD` : Standard signed addition
- `SUB` : Standard signed subtraction
- `AND` : Bit-wise and
- `OR` : Bit-wise or
- `XOR` : Bit-wise xor
- `NOT` : Bit-wise not on first operand (putting a second operand will
  trigger assembler error, and is ignored in byte code).
- `LSR` : Logical Shift Right
- `LSL` : Logical Shift Left

## Conditionnal Jumps

The architecture provides a wide selection of logical condition for
jumping. Those instruction compare A and B and according the condition
jumps to the destination (immediate or register value).

- `JEQ` : Jump if equal
- `JNE` : Jump if not equal
- `JGE` : Jump if $A \geq B$
- `JPG` : Jump if $A > B$
- `JLE` : Jump if $A \leq B$
- `JPL` : Jump if $A < B$
- `J` : Always Jumps (takes no operand)
- `INOP` : Does nothing (implemented as never jumps)

Jumping to immediate values is sufficient in most cases. However, it is
sometimes required to jumps to a register value instead, typically the
lr register for a return instruction. Our architecture therefore
supports the destination as a immediate or register value.

*Note* : when confirmed, a jump takes 2 clock cycles to execute due to
PC update delay.

## RAM interaction

Our architecture provides a 255 bytes memory for running programs.
Interaction with said memory are only of 2 ways : storing data from a
register into the RAM, or loading a data from RAM to a register. Our
architecture provides a flexible way to choose the RAM address, as it
will be the sum of the first and second operand. This allows for handy
addressing when iterating through an array for example. Storing the
value from `R10` into the 3rd slot of an array where the pointer address
is located in `R11` can therefore be performed this way :
`STORE R10 R11 3`. Similarly, loading the value from `R10` into the same
slot : `LOAD R10 R11 3`, where 3 effectively acts as an offset for R11
address value.

*Note* : `LOAD` takes 2 clock cycles to execute due to RAM delay.

## Stack interaction

Stack interaction are basically special cases of RAM loading and
storing, where the address is automatically defined using the stack
pointer, which also is updated during the process.

- `PUSH Dest` : Pushes onto stack the value of the 'Dest' register
- `POP Dest` : Pops the stack top value into the 'Dest' register

*Warning* : The stack is located in the last addresses of the RAM, and
iterates through lower addresses as it grows. It is not protected, so it
is the responsibility of the user to ensure it may not collide with
other data stored in RAM.

## Function handling and labels

The assembler supports label usage for easier jumps and function calls.\
`LABEL func` defines a label named func, and all operands named func in
the code will be replaced by the Byte Code location of the assembly line
just below.\
Lastly, functions can be called and returned using a single assembly
instruction. Those will actually translate as two simpler instructions
during assembly : a stack push/pop followed by a jump. A `CALL` will
cost 3 clock cycles, and a `RET` 4 clock cycles.\
`CALL func` will push `pc` onto the stack, and jump to the label named
`func`.\
`RET` will pop the top value of the stack into `lr`, and jump to this
value.

Since usage of `pc` actually stores the location of the second-to-next
byte code line, using `RET` will correctly jump to the next assembly
line after the `CALL`.

## Opcodes

An opcode $X_7 X_6 X_5 X_4 X_3 X_2 X_1 X_0$ for an operation is
interpreted as follows :

- $X_7 X_6 X_5$ refer to the operation type : arithmetic, conditional
  jump (immediate or register), stack operation, ram operation.

- $X_4 X_3$ refer to the type of the operands : immediate (1) or
  register pointers (0). eg : 01 means A is register and B immediate.

- $X_2 X_1 X_0$ further select the desired operation depending on the
  operation type (ex : ADD, JNE, \...).

### Arithmetic and Logic (`000-----`)

| Mnemonic | Opcode   |
|----------|----------|
| ADD      | `000--000` |
| SUB      | `000--001` |
| AND      | `000--010` |
| OR       | `000--011` |
| XOR      | `000--100` |
| NOT      | `000--101` |
| LSR      | `000--110` |
| LSL      | `000--111` |

### Conditional Jumps (Immediate) (`001-----`)

| Mnemonic | Opcode   |
|----------|----------|
| JEQ      | `001--000` |
| JNE      | `001--001` |
| JGE      | `001--010` |
| JPG      | `001--011` |
| JLE      | `001--100` |
| JPL      | `001--101` |
| J        | `001--110` |
| INOP     | `001--111` |

### Conditional Jumps (Register) (`101-----`)

| Mnemonic | Opcode   |
|----------|----------|
| JEQ      | `101--000` |
| JNE      | `101--001` |
| JGE      | `101--010` |
| JPG      | `101--011` |
| JLE      | `101--100` |
| JPL      | `101--101` |
| J        | `101--110` |

### RAM Interaction 

| Mnemonic | Opcode   |
|----------|----------|
| LOAD     | `010--000` |
| STORE    | `011--000` |

### Stack Interaction

| Mnemonic | Opcode    |
|----------|-----------|
| POP      | `11001000`  |
| PUSH     | `11101000`  |

### Special (Internal)

| Name  | Opcode     | Notes                                      |
|-------|------------|--------------------------------------------|
| STALL | `100000000`  | Internal use during RAM load (not in ASM)  |

*Note* : Stall is used during RAM load by the decoder to wait for RAM
data while keeping same operands value. It is not available as an
instruction in assembly.