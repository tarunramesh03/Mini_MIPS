--Instruction Memory block 
--This memory block can hold a  program size of 2048 bytes
--Each instruction is 4 bytes(32 bits) so the instruction memory can hold 512 instructions (512*4= 2048) 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Im_Mem is 

port
(
pc: in std_logic_vector(31 downto 0); --program counter output and input to IM
Im_output: out std_logic_vector(31 downto 0) --Output the 32-bit instruction
); 
end Im_Mem;


architecture  IM_Arch of Im_Mem is 
type Im_Block is array (0 to 2047) of std_logic_vector (7 downto 0);
signal I: Im_Block := (others=>(others=>'0'));

begin



I(0) <= X"00"; I(1) <= X"04"; I(2) <= X"10"; I(3) <= X"81"; -- SLL
I(4) <= X"00"; I(5) <= X"46"; I(6) <= X"40"; I(7) <= X"02"; -- XNOR 
I(8) <= X"00"; I(9) <= X"CA"; I(10) <= X"60"; I(11) <= X"03"; -- NAND
I(12) <= X"05"; I(13) <= X"82"; I(14) <= X"00"; I(15) <= X"48"; -- ORI
I(16) <= X"08"; I(17) <= X"C8"; I(18) <= X"00"; I(19) <= X"4C"; -- SUBI
I(20) <= X"0E"; I(21) <= X"0E"; I(22) <= X"00"; I(23) <= X"50"; --ADDUI 
I(24) <= X"10"; I(25) <= X"4C"; I(26) <= X"00"; I(27) <= X"40"; -- BNE 
I(28) <= X"16"; I(29) <= X"92"; I(30) <= X"00"; I(31) <= X"09"; -- LH
I(28) <= X"18"; I(29) <= X"14"; I(30) <= X"00"; I(31) <= X"54"; -- SB
I(32) <= X"1C"; I(33) <= X"00"; I(34) <= X"00"; I(35) <= X"40"; -- J
I(36) <= X"03"; I(37) <= X"00"; I(38) <= X"00"; I(39) <= X"04"; -- JR 


  
Im_output <= I(to_integer(unsigned(pc))) & I(to_integer(unsigned(pc))+1) & I(to_integer(unsigned(pc)) +  2) & I(to_integer(unsigned(pc)) +3);

end IM_Arch;
