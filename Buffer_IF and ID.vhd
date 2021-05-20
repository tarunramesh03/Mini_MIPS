
--Pipeline Buffer for Instruction Fetch and instruction Decode Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity Buff_IF_ID is
port
(
  Clock : in std_logic;
  Enable : in std_logic := '1';
  Clear : in std_logic := '0';
  Instruction_Mem_in : in std_logic_vector(31 downto 0) :=  (others =>'0');   --Instruction memory writes to this buffer
  PC_in: in std_logic_vector(31 downto 0) :=  (others =>'0'); 	    --PC writes to this buff
  Instruction_Mem_out: out std_logic_vector (31 downto 0) := (others => '0'); 
  PC_out: out std_logic_vector (31 downto 0) := (others => '0')	
 );
end Buff_IF_ID;

architecture Buff_IF_ID_Arch of Buff_IF_ID is

signal Enable_n : std_logic;

 begin
   
   --Enable_n <= not Enable;
  process(Clock)
    begin
      if (falling_edge(Clock)) then
      if ((Enable ='1') and (Clear = '0')) then
        Instruction_Mem_out <= Instruction_Mem_in;
        PC_out <= PC_in;

      elsif (clear = '1') then
        Instruction_Mem_out <= (others=>'0');
        PC_out <= (others=>'0');
  
      end if;
      end if;
  end process;
end Buff_IF_ID_Arch;