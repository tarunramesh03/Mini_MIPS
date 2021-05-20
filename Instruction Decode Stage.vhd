
--Instruction Decode Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity ID_Stage is
port
(
  Clock : in std_logic;
  Clear : in std_logic := '0';

  Mux1_Sel_BD, Mux2_Sel_BD: in std_logic := '0';  --SEL Pins for Branch Detect MUXs. To be connected to ForwardAD and ForwardBD
  RegWriteW : in std_logic := '0';  --Coming back from the last stage. Written as WE3 in diagram
  Write_Back_Address : in std_logic_vector(4 downto 0) := (others=>'0');  --Address of write back register. WA3
  InstrustionD, Write_Data, PcPlus3, ALUOut : in std_logic_vector(31 downto 0) := (others=>'0');  --InstructionD and PcPlus3 are coming from IF stage. Write_Data from the write back stage. ALUOut from data memory stage.

  RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, PcSrcD, BranchD, JumpD : out std_logic := '0';
  ALUControlE : out std_logic_vector(2 downto 0) := (others=>'0');

  RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0) := (others=>'0');  --First 3 are for Execution State. Last 2 are for Hazard Unit
  Reg_Output1, Reg_Output2, SignImmdE : out std_logic_vector(31 downto 0) :=  (others =>'0');
  Reg_Output1F : out std_logic_vector(31 downto 0) :=  (others =>'0'); --For jump Feedback to IF stage
  Adder_Sign_Extend_Out : out std_logic_vector(31 downto 0) :=  (others =>'0')  --Branch address going to PC
);

end ID_Stage;


architecture ID_Stage_Arch of ID_Stage is

component reg_file is
  port (
      Clock: in std_logic;
      Enable: in std_logic;
      Reg1_opernad: in std_logic_vector(4 downto 0);
      Reg2_opernad: in std_logic_vector(4 downto 0);
      Write_back_Reg: in std_logic_vector(4 downto 0);
      Write_back_Data: in std_logic_vector(31 downto 0);
      Output_Data1: out std_logic_vector(31 downto 0);
      Output_Data2: out std_logic_vector(31 downto 0)
    );
  end component;


component Sign_Extend is
port
(
  Sign_Extend_in : in std_logic_vector(15 downto 0);
  Sign_Extend_out : out std_logic_vector(31 downto 0)
);
end component;


component left_shifter is
port (
  Input: in std_logic_vector(31 downto 0);
  Output: out std_logic_vector(31 downto 0)
  );
end component;


component Adder_Sign_extend is
  port (
      Input_1 : in std_logic_vector(31 downto 0);
      Input_2 : in std_logic_vector(31 downto 0);
      Output_adder : out std_logic_vector(31 downto 0)
        );
end component;


component branch_detect is
  port (
      Branch: in std_logic ;
      Register_1, Register_2: in std_logic_vector(31 downto 0);
      Branch_Out: out std_logic
      );
end component;


component MUX_2In is
port (
      MUX_Sel : in std_logic;
      MUX_Input_1, MUX_Input_2 : in std_logic_vector(31 downto 0);
      Output : out std_logic_vector(31 downto 0)
      );
end component;

component MUX_2In_JR
port (
      MUX_Sel_JR : in std_logic := '0';
      MUX_Input_1_JR, MUX_Input_2_JR : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end component;


component Control_Unit is
port
(
  OpCode : in std_logic_vector(5 downto 0);
  Funct : in std_logic_vector(5 downto 0);
  RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg, Branch, Jump: out std_logic;
  ALUControl : out std_logic_vector(2 downto 0)
);
end component;


component ID_EX_Buf is
port
(
  Clock : in std_logic;
  Clear : in std_logic;

  RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg : in std_logic;
  ALUControl : in std_logic_vector(2 downto 0);
  Rs, Rt, Rd : in std_logic_vector(4 downto 0);
  Reg_Output1, Reg_Output2, SignImmd : in std_logic_vector(31 downto 0);

  RegDstE, RegWriteE, ALUSrcE, MemWriteE, MemtoRegE : out std_logic;
  ALUControlE : out std_logic_vector(2 downto 0);
  RsE, RtE, RdE : out std_logic_vector(4 downto 0);
  Reg_Output1E, Reg_Output2E, SignImmdE : out std_logic_vector(31 downto 0)
);
end component;
 
signal SignExt_Out, LeftShift_to_Adder, Reg_2_Branch_MUX1, Reg_2_Branch_MUX2, MUX1_to_BD, MUX2_to_BD : std_logic_vector(31 downto 0);
signal RD, RW, AS, MW, MR, BD , JP: std_logic;
signal ALUControlD : std_logic_vector(2 downto 0);


begin

  REG: reg_file port map (Clock, RegWriteW, InstrustionD(25 downto 21), InstrustionD(20 downto 16), Write_Back_Address, Write_Data, Reg_2_Branch_MUX1, Reg_2_Branch_MUX2);
  SignEx: Sign_Extend port map(InstrustionD(15 downto 0), SignExt_Out);
  LeftShift: left_shifter port map(SignExt_Out, LeftShift_to_Adder);
  Adder_SignExtnd: Adder_Sign_extend port map(LeftShift_to_Adder, PcPlus3, Adder_Sign_Extend_Out);
  --MUX2in1JR: MUX_2In_JR port map (Jump, Output_adder, Reg1_opernad, PC_input);
  MUX1: MUX_2In port map(Mux1_Sel_BD, Reg_2_Branch_MUX1, ALUOut, MUX1_to_BD);
  MUX2: MUX_2In port map(Mux2_Sel_BD, Reg_2_Branch_MUX2, ALUOut, MUX2_to_BD);
  BRANCH: branch_detect port map (BD, MUX1_to_BD, MUX2_to_BD, PcSrcD);
  CTRL: Control_Unit port map (InstrustionD(31 downto 26), InstrustionD(5 downto 0), RD, RW, AS, MW, MR, BD, JP, ALUControlD);
  BUFF: ID_EX_Buf port map(Clock, Clear, RD, RW, AS, MW, MR, ALUControlD, InstrustionD(25 downto 21), InstrustionD(20 downto 16), InstrustionD(15 downto 11), Reg_2_Branch_MUX1, Reg_2_Branch_MUX2, SignExt_Out, RegDstE, RegWriteE, ALUSrcE, MemWriteE, MemtoRegE, ALUControlE, RsE, RtE, RdE, Reg_Output1, Reg_Output2, SignImmdE);
  RsD <= InstrustionD(25 downto 21);
  RtD <= InstrustionD(20 downto 16);
  BranchD <= BD;
  JumpD <= JP;
  Reg_Output1F <= Reg_2_Branch_MUX1;

end ID_Stage_Arch;
