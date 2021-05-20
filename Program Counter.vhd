
--32-bit - Program Counter


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity PC is
port (
    Clock : in std_logic;
    Enable : in std_logic := '1';
    PC_input: in std_logic_vector(31 downto 0)  :=  (others => '0');
    PC_output : out std_logic_vector(31 downto 0) :=  (others => '0')
);
end PC;


architecture PC_Arch of PC is
  
  signal Enable_n : std_logic;
  
begin
  
  process(Clock)
    begin
      if (falling_edge(Clock) and Enable ='1') then
        PC_output <= PC_input;
      end if;
    end process;  
  
end PC_Arch;