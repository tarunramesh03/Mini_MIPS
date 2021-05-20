

--MUX 3 to 1


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity MUX_3In is
port (
      MUX_Sel : in std_logic_vector(1 downto 0) := (others => '0');
      MUX_Input_1, MUX_Input_2, MUX_Input_3 : in std_logic_vector(31 downto 0) := (others => '0');
      Output : out std_logic_vector(31 downto 0) := (others => '0')
      );
end MUX_3In;


architecture MUX_3In_Arch of MUX_3In is
  begin
    
    Output <= MUX_Input_1 when MUX_Sel = "00" else
              MUX_Input_2 when MUX_sel = "01" else
              MUX_Input_3 when MUX_sel = "10" else (others => '0');
    
  end MUX_3In_Arch;




