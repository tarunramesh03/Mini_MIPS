
--32 Bits Adder for Sign extending


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity Adder_Sign_extend is
  port (
      Input_1 : in std_logic_vector(31 downto 0) := (others => '0');
      Input_2 : in std_logic_vector(31 downto 0) := (others => '0');
      Output_adder : out std_logic_vector(31 downto 0) := (others => '0')
        );
end Adder_Sign_extend;


architecture Adder_Sign_extend_arch of Adder_Sign_extend is
begin
  Output_adder <= (Input_1 + Input_2);
end Adder_Sign_extend_arch;
