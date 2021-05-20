
--MUX 2 to 1


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity MUX_2In_JR is
port (
      MUX_Sel_JR : in std_logic := '0';
      MUX_Input_1_JR, MUX_Input_2_JR : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end MUX_2In_JR;


architecture MUX_Arch of MUX_2In_JR is
  begin

    Output <= MUX_Input_1_JR when MUX_Sel_JR = '0' else  --Output from Adder_4_IF "Output_adder"
              MUX_Input_2_JR when MUX_Sel_JR = '1' else (others => '0'); -- Output from Register File "Reg1_opernad"

  end MUX_Arch;
