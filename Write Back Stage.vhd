
--Write Back Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity WB_Stage is
port
(

  RegWriteW, MemToRegW : in std_logic := '0';
  Read_DataW, ALU_OutW : in std_logic_vector(31 downto 0);
  WriteRegW : in std_logic_vector(4 downto 0) :=  (others =>'0');

  RegWriteW_Out : out std_logic := '0'; --Use for feedback as well as for Hazard Unit
  ResultW : out std_logic_vector(31 downto 0) :=  (others =>'0');
  WriteRegW_Out : out std_logic_vector(4 downto 0) :=  (others =>'0') --Use for feedback as well as for Hazard Unit
);
end WB_Stage;

architecture WB_Stage_Arch of WB_Stage is

  component MUX_2In
  port (
        MUX_Sel : in std_logic := '0';
        MUX_Input_1, MUX_Input_2 : in std_logic_vector(31 downto 0) := (others => '0');
        Output : out std_logic_vector(31 downto 0) := (others => '0')
        );
  end component;

  component MUX_2In_JR
  port (
        MUX_Sel_JR : in std_logic := '0';
        MUX_Input_1_JR, MUX_Input_2_JR : in std_logic_vector(31 downto 0) := (others => '0');
        Output : out std_logic_vector(31 downto 0) := (others => '0')
        );
  end component;



  begin

  MUX: MUX_2In port map (MemToRegW, ALU_OutW, Read_DataW, ResultW);
  WriteRegW_Out <= WriteRegW;
  RegWriteW_Out <= RegWriteW;

  end WB_Stage_Arch;
