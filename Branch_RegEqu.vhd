
--Branch detection Using Register Equality and Control Signal


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity branch_detect is
  port (
      Branch: in std_logic  := '0';
      Register_1, Register_2: in std_logic_vector(31 downto 0)  := (others=>'0');
      Branch_Out: out std_logic  := '0'
      );
end branch_detect;
    

architecture branch_detect_arch of branch_detect is
begin
  
  Branch_Out <= '1'when (Branch='1' and (unsigned(Register_1) = unsigned(Register_2)))
		else '0';
  
end branch_detect_arch;