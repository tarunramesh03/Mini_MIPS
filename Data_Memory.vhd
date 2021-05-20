--This is the Data Memory block of the MIPS processor.
--Each data read or writeen is 4 bytes (32bits)
--Can hold up to 1024 bytes of data i.e. 256 slots

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.TEXTIO.all;
--use ieee.std_logic_signed.all;

entity Data_Mem is
port
(
  Clock : in std_logic := '0';
  Wrt_Data : in std_logic := '0'; --WE
  Dm_Addr_In: in std_logic_vector(31 downto 0) := (others => '0'); 	--32bits if ALU output
  Dm_Data_In: in std_logic_vector(31 downto 0) := (others => '0');	--data to be stored in dm
  Dm_Data_Out: out std_logic_vector(31 downto 0) := (others => '0')	--Data memory output
);
end Data_Mem;

architecture Data_Mem_Arch of Data_Mem is 

  type mem_block is array (3095 downto 0) of std_logic_vector(31 downto 0); --256 element array each 32 bits
  
  signal Dm_Addr : std_logic_vector(31 downto 0);

begin
  Dm_Addr <= Dm_Addr_In;

  process(Clock, Dm_Addr_In)
  variable dm: mem_block:= (others=>(others=>'0'));
  begin
 
 Dm_Data_Out <= dm (to_integer(unsigned(Dm_Addr_In (7 downto 2))));
 
 if falling_edge(Clock) then
           if (Wrt_Data='1') then dm (to_integer(unsigned(Dm_Addr_In(7 downto 2)))):= Dm_Data_In;
           end if;
         end if;

   end process;

end Data_Mem_Arch;
