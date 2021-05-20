--Pipeline Buffer for Execution Stage & Data Memory Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity EX_DM_Buf is
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
end EX_DM_Buf;


architecture EX_DM_Arch of EX_DM_Buf is
 begin
  process(Clock)
  begin
    if (falling_edge(Clock)) then

     RegWriteM <= RegWriteE;
     MemtoRegM <= MemtoRegE;
     MemWriteM <= MemWriteE;

     ALU_Result_Output <= ALU_Result_Input;
     WriteDataM <= WriteDataE;
     WriteRegM  <= WriteRegE;

    end if;
  end process;
end EX_DM_Arch;