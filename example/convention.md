Please note following conventions are used in our code :

- Registers are saved during function prologue and restored during
  epilogue

- Arguments are pushed onto the stack in order before call (and need to
  be deallocated after call)

- Function write their return value in Register 13

When simulating RPM for example, when the code has been fully executed, we are left with 247 (=13x19) in the 13th register.


You may find below a commented version of the RPM code :

``` {.gnuassembler language="Assembler" caption="Russian peasant multiplication"}
J main

LABEL mul
PUSH R0                         # function prologue : saving registers
PUSH R1
PUSH R2
PUSH R3
LOAD R0 sp 7                    # location of argument 1 (a)
LOAD R1 sp 6                    # location of argument 2 (b)
JGE mul_correct_order R0 R1     # Reorders arguments to ensure the smallest is b
PUSH R1                         # Prepare call ; push argument 1
PUSH R0                         # push argument 2
CALL mul
ADD sp sp 2                     # Arguments deallocation after call
J mul_ret
LABEL mul_correct_order
JNE mul_not_base_case R1 1      # Base case
ADD R13 R0 0
J mul_ret
LABEL mul_not_base_case         # Other cases
AND R2 R1 0b00000001            # modulo 2
LSR R3 R1 1                     # division by 2
PUSH R0
PUSH R3
CALL mul
ADD sp sp 2 
LSL R13 R13 1                   # multiply by 2
JEQ mul_odd R2 1 
J mul_ret                       # if b is even
LABEL mul_odd                   # if b is odd
ADD R13 R13 R0
J mul_ret 
LABEL mul_ret                   # Function epilogue : restoring resgisters
POP R3
POP R2
POP R1
POP R0
RET

LABEL main
ADD R0 13 0
ADD R1 19 0
PUSH R0                         # Prepare call ; push argument 1
PUSH R1                         # push argument 2
CALL mul
```