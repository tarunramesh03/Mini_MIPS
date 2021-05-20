
--Arithmetic and Logical Unit


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ALU is

port
(
  ALU_Input1, ALU_Input2 : in std_logic_vector(31 downto 0) :=  (others =>'0');
  ALU_Control :  in std_logic_vector(2 downto 0) :=  (others =>'0');
  ALU_Output:  out std_logic_vector(31 downto 0) :=  (others =>'0')
 );
end ALU;

architecture ALU_Arch of ALU is
begin

ALU_Output <= std_logic_vector(unsigned (ALU_Input1) nand unsigned (ALU_Input2)) when ALU_Control = "001" else
              std_logic_vector(unsigned (ALU_Input1) xnor unsigned (ALU_Input2)) when ALU_Control = "100" else
              std_logic_vector(unsigned (ALU_Input1) - unsigned (ALU_Input2)) when ALU_Control = "110" else
              std_logic_vector(unsigned (ALU_Input1) + unsigned (ALU_Input2)) when ALU_Control = "011" else
              std_logic_vector(unsigned (ALU_Input1) or unsigned (ALU_Input2)) when ALU_Control = "111" else
              (OTHERS=>'0');
         
end ALU_Arch;