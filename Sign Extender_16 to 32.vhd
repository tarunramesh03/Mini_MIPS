
--Sign Extender - 16 bits to 32 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Sign_Extend is
port
(
  Sign_Extend_in : in std_logic_vector(15 downto 0);
  Sign_Extend_out : out std_logic_vector(31 downto 0)
);
end Sign_Extend;

architecture Sign_Extend_Arch of Sign_Extend is
begin
    Sign_Extend_out <= X"ffff" & Sign_Extend_in when Sign_Extend_in(15)='1'
    else X"0000" & Sign_Extend_in;
end Sign_Extend_Arch;
