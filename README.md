# A minimal working RISC architecture

## Presentation

This proposition of a RISC architecture covers most of the essentials
functions of a RISC. 

Notably, it provides **basic Arithmetics
and Logics**, a wide selection of **Conditionnal Jumps, RAM interaction,
Stack interaction**, and lastly **function handling**. 

## Repository description

This repository includes, alongside the VHDL code for the CPU, an extensive description of the ISA and associated Assembly in the [dedicated markdown](ISA.md).
An `assembly` folder contains the Python Assembler and Byte Code to VHDL converter. Both need to be run in order to get a VHDL code that can be placed inside the ROM description.


You may also find [example codes](example/) to illustrate the CPU capabilities. 
**Exponentiation by squaring** is one of the most well-known algorithm using function recursion. I took inspiration from the algorithm and proposed first a multiplication implementation using the same idea (**Russian Peasant Multiplication**).
You can also find a proposition for Exponentiation by Squaring, but note it exceeds ROM size.

## Trying simulation yourself

**Intel's Quartus and Questa** are recommended to try the architecture yourself.

After loading the files into Questa, you are free to launch waveform simulation of all components. **You may find ready-to-launch testbenches for the Decoder and ALU**.

To test the entire CPU, you may use `cpu_wave.do` to preload relevant signals into waveform. At least a cycle with `rst` set to 1 is required to initialize memory. After that, the CPU will load instructions from the ROM as expected.
