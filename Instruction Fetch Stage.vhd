
--Instruction Fetch Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity IF_Stage is
  port (
      Clock : in std_logic;
      Enable_PC : in std_logic := '1';
      Enable_BUFF : in std_logic := '1';
      Clear : in std_logic := '0';
      MUX_sel_branch : in std_logic:= '0';
      MUX_sel_jump : in std_logic:= '0';
      Branch_Address: in std_logic_vector(31 downto 0) :=  (others =>'0');
      Jump_Address: in std_logic_vector(31 downto 0) :=  (others =>'0');
      InstructionF, PC_F: out std_logic_vector(31 downto 0) :=  (others =>'0')
        );
end IF_Stage;


architecture IF_Stage_arch of IF_Stage is


component PC
port (
    Clock : in std_logic;
    Enable : in std_logic := '1';
    PC_input: in std_logic_vector(31 downto 0)  :=  (others => '0');
    PC_output : out std_logic_vector(31 downto 0) :=  (others => '0')
);
end component;

component Adder_4bits
  port (
      Input_adder : in std_logic_vector(31 downto 0);
      Output_adder : out std_logic_vector(31 downto 0)
        );
end component;


component MUX_2In
port (
      MUX_Sel : in std_logic := '0';
      MUX_Input_1, MUX_Input_2 : in std_logic_vector(31 downto 0);
     Output : out std_logic_vector(31 downto 0)
      );
end component;

component MUX_3In
port (
      MUX_Sel : in std_logic_vector(1 downto 0);
      MUX_Input_1, MUX_Input_2, MUX_Input_3 : in std_logic_vector(31 downto 0);
      Output : out std_logic_vector(31 downto 0)
      );
end component;

component Im_Mem
port
(
pc: in std_logic_vector(31 downto 0); --program counter output and input to IM
Im_output: out std_logic_vector(31 downto 0) --Output the 32-bit instruction
);
end component;

component Buff_IF_ID is
port
(
  Clock : in std_logic;
  Enable : in std_logic := '1';
  Clear : in std_logic := '0';
  Instruction_Mem_in : in std_logic_vector(31 downto 0);
  PC_in: in std_logic_vector(31 downto 0);
  Instruction_Mem_out: out std_logic_vector (31 downto 0);
  PC_out: out std_logic_vector (31 downto 0)
 );
end component;

signal MUX_Out, Pc_Out, ADDER_Out, MEM_Out : std_logic_vector(31 downto 0);
signal MUX_Sel : std_logic_vector(1 downto 0);

begin
    P: PC port map (Clock, Enable_PC, MUX_Out, Pc_Out);
    ADDER: Adder_4bits port map (Pc_Out, ADDER_Out);
   -- MUX2in1JR: MUX_2In_JR port map (Jump, Output_adder, Reg1_opernad, PC_input);
    MUXB: MUX_2In port map (MUX_sel_branch, ADDER_Out, MUX_Out);
    MUXJ: MUX_2In port map (MUX_sel_jump, Branch_Address, Jump_Address);

    MUX_Sel(0) <= MUX_sel_branch;
    MUX_Sel(1) <= MUX_sel_jump;
    MUX: MUX_3In port map (MUX_Sel, ADDER_Out, Branch_Address, Jump_Address, MUX_Out);
    MEM: Im_Mem port map (Pc_Out, MEM_Out);
    BUFF: Buff_IF_ID port map (Clock, Enable_BUFF, Clear, MEM_Out, ADDER_Out, InstructionF, PC_F);

end IF_Stage_arch;
