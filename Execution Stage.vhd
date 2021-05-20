
--Execution Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity EX_Stage is
port
(
  Clock : in std_logic;

  RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE  : in std_logic := 'X';
  ALUControlE : in std_logic_vector(2 downto 0) := (others=>'X');
  MUX_3IN_Sel1, MUX_3IN_Sel2 : in std_logic_vector(1 downto 0) :=  (others =>'0');  --ForwardAE, ForwardBE

  Reg_Output1, Reg_Output2, SignImmdE, ALUOut_DM, Result_WB : in std_logic_vector(31 downto 0) :=  (others =>'X');
  RsE, RtE, RdE  : in std_logic_vector(4 downto 0) :=  (others =>'0');

  RegWriteM, MemtoRegM, MemWriteM : out std_logic :=  'X';
  RsE_HU, RtE_HU : out std_logic_vector(4 downto 0) :=  (others =>'0');
  RegWriteE_HU, MemtoRegE_HU : out std_logic := '0';
  ALU_OutM : out std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteDataM : out std_logic_vector(31 downto 0) :=  (others =>'0');
  --Write_Back_Address_OutE, Write_Back_Address_OutM : out std_logic_vector(4 downto 0) :=  (others =>'0')
  WriteRegE, WriteRegM : out std_logic_vector(4 downto 0) :=  (others =>'0')
);
end EX_Stage;


architecture EX_Stage_Arch of EX_Stage is

component ALU
port
(
  ALU_Input1, ALU_Input2 : in std_logic_vector(31 downto 0) :=  (others =>'0');
  ALU_Control :  in std_logic_vector(2 downto 0) :=  (others =>'0');
  ALU_Output:  out std_logic_vector(31 downto 0) :=  (others =>'0')
 );
end component;

component MUX_2In
port (
      MUX_Sel : in std_logic := '0';
      MUX_Input_1, MUX_Input_2 : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end component;

component MUX_2In_5Bit
port (
      MUX_Sel : in std_logic := '0';
      MUX_Input_1, MUX_Input_2 : in std_logic_vector(4 downto 0) := (others => '0');
      Output : out std_logic_vector(4 downto 0) := (others => '0')
      );
end component;

component MUX_2In_JR
port (
      MUX_Sel_JR : in std_logic := '0';
      MUX_Input_1_JR, MUX_Input_2_JR : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end component;

component MUX_3In
port (
      MUX_Sel : in std_logic_vector(1 downto 0) := (others => '0');
      MUX_Input_1, MUX_Input_2, MUX_Input_3 : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end component;

component EX_DM_Buf
port
(
  Clock : in std_logic :=  '0';

  RegWriteE, MemtoRegE, MemWriteE : in std_logic :=  '0';
  ALU_Result_Input, WriteDataE : in std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegE : in std_logic_vector(4 downto 0) :=  (others =>'0');

  RegWriteM, MemtoRegM, MemWriteM : out std_logic :=  '0';
  ALU_Result_Output, WriteDataM : out std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegM : out std_logic_vector(4 downto 0) :=  (others =>'0')
);
end component;

signal ALU_In1, ALU_In2, Mux3_to_Mux2, ALU_to_Buff : std_logic_vector(31 downto 0);
signal Mux2_to_Buff, rtg : std_logic_vector(4 downto 0);
signal RWE, MTRE: std_logic;

begin

 RWE <= RegWriteE;
 MTRE <= MemtoRegE;
-- MUX2in1JR: MUX_2In_JR port map (Jump, Output_adder, Reg1_opernad, PC_input);
 MUX2I5B: MUX_2In_5Bit port map (RegDstE, rte, RdE, Mux2_to_Buff);
 MUX3I1: MUX_3In port map (MUX_3IN_Sel1, Reg_Output1, Result_WB, ALUOut_DM, ALU_In1);
 MUX3I2: MUX_3In port map (MUX_3IN_Sel2, Reg_Output2, Result_WB, ALUOut_DM, Mux3_to_Mux2);
 MUX2I: MUX_2In port map (ALUSrcE, Mux3_to_Mux2, SignImmdE, ALU_In2);
 ALUEX: ALU port map(ALU_In1, ALU_In2, ALUControlE, ALU_to_Buff);
 BUFF: EX_DM_Buf port map (Clock, RWE, MTRE, MemWriteE, ALU_to_Buff, Mux3_to_Mux2, Mux2_to_Buff, RegWriteM, MemtoRegM, MemWriteM, ALU_OutM, WriteDataM, WriteRegM);
 WriteRegE <= Mux2_to_Buff;
 rtg <= RtE;
 RsE_HU <= RsE;
 RtE_HU <= rte;
 RegWriteE_HU <= RWE;
 MemtoRegE_HU <= MTRE;

end EX_Stage_Arch;
