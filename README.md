# Mini_MIPS

Introduction - 

A subset of MIPS Insturction set architecture was design and implemented in a 32 bit Mini-MIPS.We performed digital logic simulation & synthesis using ModelSim software with the help of VHDL simulation from Mentor graphic corporation.

Instructions implemented - ORI, SLL, XNOR, NAND, SUBI, ADDUI, BNE, JR and J
These instructions are encoded in 16-bit Binary.


Directory - 

ALU - Arithmetic and Logical Unit - Performs operations on the operands as per the control signals generated by the ALU Decoder.

ALU Decoder - Used to generate the control signals for each operation to be performed by the ALU. The control signals are mapped to the OPCODE and Funct code Encoding for each instruction.

Branch_RegEqu - This file contains the code for conditional branch instructions like BNE or BEQ. This code checks for equality of registers.

Buffers_IF&ID, ID&IE, EX&DM and DM&WB - These buffers hold the intermediate values between the Instruction Fetch, Instruction Decode, Instruction Execute, Memory Access and Write Back stages. These buffers are also connected to the Hazard unit to directly forward the results of ALU or MEM stage as a counter measure to RAW Hazards.

Control Unit - This file contains the intermediate code for ALU Decoder, Main decoder and ALU.

Instruction fetch Stage, Instruction Decode stage, Data Memory stage, Execution stage, Write Back stage  - These files contain the code for writing the output of the pervious stages into their respective intermediate buffers.

Data Memory - This file consist of the Data Memory block code for the MIPS processor. All data read and written are 32 bits long. The data memory can hold upto 1024 bytes.

Forwarding Unit and Stall Unit - Counter RAW hazards by forwarding from IE&DM buffer and DM&WB buffer. Sets or resets intermediate bits to indicate the need for stallling or forwarding bits of buffers to other stages.

Hazard Unit - Based on the stage in which the hazard occurs, the respective intermediate buffers are written with the results computed.

Instruction Memory - this files contains the code for the Instruction memory of the MIPS. The instruction memory has a size of 2048 bytes. Instruction addresses are provided in HEX as per encoding.

Main Decoder - Part of the Control Unit. Use to distinguish the Intructions based on their type. Also sets the Opcode for the ALU to perform respective operations.

MIPS 32_main - The main code for the processor, initialising local variables and calling the fuctions of the stages of the MIPS.

Register File - Register file of the MIPS. All registers are 32 bits. The initial values of some registers as per code have been hard coded in HEX.

Sign Extender - Extends 16 bits input to 32 bits by adding 16 zeros for higher order bits.

The Zip file also included the encoding file for the instruction implemented.
