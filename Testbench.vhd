library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MIPS32_tb is
end MIPS32_tb;

architecture arc of MIPS32_tb is
  
  component MIPS is 
    port(
      Clock: in std_logic
    );
  end component;
  
  signal clk: std_logic:='0';
  constant clk_period: time:=100 ns;
  
begin
  uut: MIPS
  port map (Clock=>clk);
    --clock generation
    clk_process: process
    begin
      clk<='1';
      wait for clk_period;
      clk<='0';
      wait for clk_period;
    end process;
  end;
