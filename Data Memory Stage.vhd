
--Data Memory Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity DM_Stage is
port
(
  Clock : in std_logic := '0';
  
  RegWriteM, MemToRegM, MemWriteM : in std_logic := '0';
  ALUOutM, WriteDataM : in std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegM : in std_logic_vector(4 downto 0) :=  (others =>'0');

  RegWriteW, MemToRegW : out std_logic := '0';
  Read_DataW, ALU_OutW : out std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegW : out std_logic_vector(4 downto 0) :=  (others =>'0');
  WriteRegM_HU: out std_logic_vector(4 downto 0) :=  (others =>'0');
  RegWriteM_HU, MemToRegM_HU : out std_logic := '0';
  ALUOutM_Output : out std_logic_vector(31 downto 0) :=  (others =>'0')
);
end DM_Stage;


architecture DM_Stage_Arch of DM_Stage is

component Data_Mem 
port
(
  Clock : in std_logic := '0';
  Wrt_Data : in std_logic := '0';
  Dm_Addr_In: in std_logic_vector(31 downto 0) := (others => '0'); 	--32bits of ALU output
  Dm_Data_In: in std_logic_vector(31 downto 0) := (others => '0');	--data to be stored in data memory
  Dm_Data_Out: out std_logic_vector(31 downto 0) := (others => '0')
);
end component;

component DM_WB_Buf 
 port(
 Clock : in std_logic;
 
 RegWriteM, MemToRegM : in std_logic := '0';
 Data_Mem_Out1, ALU_Result_Input : in std_logic_vector(31 downto 0) :=  (others =>'0'); 
 WriteRegM : in std_logic_vector(4 downto 0) :=  (others =>'0'); -- Write back address input
 
 RegWriteW, MemToRegW : out std_logic := '0';
 Data_Mem_Out2, ALU_Result_Output : out std_logic_vector(31 downto 0) :=  (others =>'0');
 WriteRegW : out std_logic_vector(4 downto 0) :=  (others =>'0')
 );
end component;

signal DM_to_Buff, ALUOut_to_DM : std_logic_vector(31 downto 0);
signal RWM, MTRM : std_logic;
signal WriteRegME : std_logic_vector(4 downto 0);

begin

 DM: Data_Mem port map (Clock, MemWriteM, ALUOut_to_DM, WriteDataM, DM_to_Buff); 
 BUFF: DM_WB_Buf port map (Clock, RWM, MTRM, DM_to_Buff, ALUOut_to_DM, WriteRegM, RegWriteW, MemToRegW, Read_DataW, ALU_OutW, WriteRegW);
 ALUOut_to_DM <= ALUOutM;
 ALUOutM_Output <= ALUOut_to_DM;
 RWM <= RegWriteM;
 RegWriteM_HU <= RWM; 
 MTRM <= MemToRegM;
 MemToRegM_HU <= MTRM;
 WriteRegME <= WriteRegM;
 WriteRegM_HU <= WriteRegM;
end DM_Stage_Arch;
