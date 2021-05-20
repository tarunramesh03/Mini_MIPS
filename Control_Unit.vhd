
--Control Unit


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity Control_Unit is
port
(
  OpCode : in std_logic_vector(5 downto 0);
  Funct : in std_logic_vector(5 downto 0);
  RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg, Branch, Jump: out std_logic := '0';
  ALUControl : out std_logic_vector(2 downto 0) := (others => 'X')
);
end Control_Unit;


architecture Control_Unit_Arch of Control_Unit is

  component Main_Decoder
  port
  (
    OpCode: in std_logic_vector(5 downto 0);
    RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg, Branch, Jump: out std_logic;
    ALUOp : out std_logic_vector(5 downto 0)
  );
  end component;

  component ALU_Decoder
  port
  (
    Funct : in std_logic_vector(5 downto 0);
    ALUOp : in std_logic_vector(5 downto 0);
    ALUControl : out std_logic_vector(2 downto 0)
  );
  end component;

  Signal ALUOpcode: std_logic_vector (5 downto 0);

begin

  MD: Main_Decoder port map (OpCode, RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg, Branch, Jump, ALUOpcode);
  AD: ALU_Decoder port map (Funct, ALUOpcode, ALUControl);

end Control_Unit_Arch;
