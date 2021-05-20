
--Pipeline Buffer for Instruction Decode and Execution Stage


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity ID_EX_Buf is
port
(
  Clock : in std_logic;
  Clear : in std_logic := '0';

  RegDst, RegWrite, ALUSrc, MemWrite, MemtoReg : in std_logic := '0';
  ALUControl : in std_logic_vector(2 downto 0) := (others=>'0');
  Rs, Rt, Rd : in std_logic_vector(4 downto 0) :=  (others =>'0');
  Reg_Output1, Reg_Output2, SignImmd : in std_logic_vector(31 downto 0) :=  (others =>'0');

  RegDstE, RegWriteE, ALUSrcE, MemWriteE, MemtoRegE : out std_logic := '0';
  ALUControlE : out std_logic_vector(2 downto 0) := (others=>'0');
  RsE, RtE, RdE : out std_logic_vector(4 downto 0) :=  (others =>'0');
  Reg_Output1E, Reg_Output2E, SignImmdE : out std_logic_vector(31 downto 0) :=  (others =>'0')
);
end ID_EX_Buf;


architecture IEB_Arch of ID_EX_Buf is

begin
 process(Clock)
  begin
    if (falling_edge(Clock)) then
     if (Clear = '0') then

  RegWriteE <= RegWrite;
  MemtoRegE <= MemtoReg;
  MemWriteE <= MemWrite;
  ALUSrcE <= ALUSrc;
  RegDstE <= RegDst;
  ALUControlE <= ALUControl;

  RsE <= Rs;
  RtE <= Rt;
  RdE <= Rd;
  Reg_Output1E <= Reg_Output1;
  Reg_Output2E <= Reg_Output2;
  SignImmdE <= SignImmd;

 

elsif (clear = '1') then
  RegWriteE <= '0';
  MemtoRegE <= '0';
  MemWriteE <= '0';
  ALUSrcE <= '0';
  RegDstE <= '0';
  ALUControlE <= (others=>'0');

  RsE <= (others=>'0');
  RtE <= (others=>'0');
  RdE <= (others=>'0');
  Reg_Output1E <= (others=>'0');
  Reg_Output2E <= (others=>'0');
  SignImmdE <= (others=>'0');
    end if;
    end if;
  end process;
end IEB_Arch;
