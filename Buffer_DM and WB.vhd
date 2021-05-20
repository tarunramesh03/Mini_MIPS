
--Pipeline Buffer for Data Memory Stage and Write back Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity DM_WB_Buf is
 port(
  Clock : in std_logic;
  
  RegWriteM, MemToRegM : in std_logic := '0';
  Data_Mem_Out1, ALU_Result_Input : in std_logic_vector(31 downto 0) :=  (others =>'0'); 
  WriteRegM : in std_logic_vector(4 downto 0) :=  (others =>'0'); -- Write back address input
  
  RegWriteW, MemToRegW : out std_logic := '0';
  Data_Mem_Out2, ALU_Result_Output : out std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegW : out std_logic_vector(4 downto 0) :=  (others =>'0')
 );
end DM_WB_Buf;


architecture DM_WB_Arch of DM_WB_Buf is
 begin
  process(Clock)
  begin
    if (falling_edge(Clock)) then
     RegWriteW <= RegWriteM;
     MemToRegW <= MemToRegM;
     Data_Mem_Out2 <= Data_Mem_Out1;	-- ReadDataW
     ALU_Result_Output <= ALU_Result_Input;	-- ALUOutW
     WriteRegW  <= WriteRegM;	-- Write Back Address
    end if;
  end process;
end DM_WB_Arch;
