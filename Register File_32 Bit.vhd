
--32 Bit 32 GP Registers


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity reg_file is
  port (
      Clock: in std_logic;
      Enable: in std_logic := '0';  --From RegWrite feedback
      Reg1_opernad: in std_logic_vector(4 downto 0) := (others => '0');
      Reg2_opernad: in std_logic_vector(4 downto 0) := (others => '0');
      Write_back_Reg: in std_logic_vector(4 downto 0) := (others => '0'); --Write back register address
      Write_back_Data: in std_logic_vector(31 downto 0) := (others => '0');
      Output_Data1: out std_logic_vector(31 downto 0) := (others => '0');
      Output_Data2: out std_logic_vector(31 downto 0) := (others => '0')
    );
  end reg_file;
  

  architecture reg_file_arch of reg_file is
  type Reg_Mem_Block is array(0 to 31) of std_logic_vector(31 downto 0);
  signal   Reg: Reg_Mem_Block := (others => (others => '0'));
    
    begin
      
      Output_Data1 <= Reg(to_integer(unsigned(Reg1_opernad)));
      Output_Data2 <= Reg(to_integer(unsigned(Reg2_opernad)));
      
      
      
      process(Clock)
      begin
              Reg(2) <= X"00000002";
         Reg(3) <= X"0000000F";
         Reg(5) <= X"00000004";
         Reg(8) <= X"00000000";
         Reg(10) <= X"00000000";
         Reg(11) <= X"00000002";
         Reg(12) <= X"00000000";         
                 
         
        if (rising_edge(Clock)) then
         if (Enable = '1') then 
          Reg(to_integer(unsigned(Write_back_Reg))) <= Write_back_Data;
        end if;
        end if;
      end process;
      
      
    end reg_file_arch;
