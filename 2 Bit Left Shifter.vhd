
--2 Bit Left Shifter


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity left_shifter is
port (    
  Input: in std_logic_vector(31 downto 0);
  Output: out std_logic_vector(31 downto 0)
  );
end left_shifter;


architecture left_shifter_Arch of left_shifter is

begin

  Output <= Input(29 downto 0) & "00";
end left_shifter_Arch;
