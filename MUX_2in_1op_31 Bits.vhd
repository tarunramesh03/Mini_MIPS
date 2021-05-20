
--MUX 2 to 1


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity MUX_2In is
port (
      MUX_Sel : in std_logic := '0';
      MUX_Input_1, MUX_Input_2 : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end MUX_2In;


architecture MUX_Arch of MUX_2In is
  begin
    
    Output <= MUX_Input_1 when MUX_Sel = '0' else
              MUX_Input_2 when MUX_sel = '1' else (others => '0');
    
  end MUX_Arch;




