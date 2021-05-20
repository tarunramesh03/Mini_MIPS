
--ALU Decoder for the Control Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity ALU_Decoder is
port
(

  Funct : in std_logic_vector(5 downto 0) := (others => '0');
  ALUOp : in std_logic_vector(5 downto 0) := (others => 'X');
  ALUControl : out std_logic_vector(2 downto 0) := (others => 'X')
);
end ALU_Decoder;


architecture ALU_Decoder_Arch of ALU_Decoder is

begin
  process(Funct, ALUOp)
    begin

    case ALUOp is
      when "000011" => ALUControl <= "011";   --ADDUI
      when "000110" => ALUControl <= "110";   --SUBI
      when "000111" => ALUControl <= "111";   --ORI

      when others => case Funct is --For R-Type Instructions
        when "000010" =>  ALUControl <= "100"; --XNOR
        when "000011" =>  ALUControl <= "001"; --NAND
        when "000001" =>  ALUControl <= "000"; --SLL
        when "000100" =>  ALUControl <= "010"; --JR
        when others => ALUControl <= "XXX";
    end case;
    end case;
  end process;

end ALU_Decoder_Arch;
