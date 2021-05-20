
--Stall Unit for Load & Control Hazards


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity stall_unit is
port
(
    WriteRegW, WriteRegM, WriteRegE: IN STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
    RegWriteM, RegWriteW, RegWriteE : IN STD_LOGIC := '0';
    MemtoRegM, MemtoRegE : IN STD_LOGIC := '0';
    
    RsE, RtE: IN STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
    RsD, RtD: IN STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
    BranchD: IN STD_LOGIC := '0';

    Stall_ID: OUT STD_LOGIC := '1'; 
    Stall_IF: OUT STD_LOGIC := '1'; 
    FlushE: OUT STD_LOGIC := '0'
    
);
end stall_unit;


architecture stall_unit_Arch of stall_unit is
  
begin
    process(WriteRegW, WriteRegM, WriteRegE, RegWriteM, RegWriteW, RegWriteE, MemtoRegM, MemtoRegE, RsE, RtE, RsD, RtD, BranchD)
      begin

      --Load Hazard
         if  ((MemtoRegE = '1') AND ((RtE=RsD) OR (RtE=RtD))) then
             
             Stall_ID <= '0';
             Stall_IF <= '0';
            FlushE <= '1';
             
          else
            Stall_ID <= '1';
           Stall_IF <= '1';
          FlushE <= '0';
         end if;
          
          --Branch Stall
          if (BranchD = '1' AND RegWriteE = '1' AND (WriteRegE = RsD OR WriteRegE = RtD))
          OR
          (BranchD = '1' AND MemtoRegM = '1' AND (WriteRegM = RsD OR WriteRegM = RtD))
          OR
          ((MemtoRegE = '1') AND ((RtE=RsD) OR (RtE=RtD))) then
          
          Stall_ID <= '0';
          Stall_IF <= '0';
          FlushE <= '1';
                 
          else 
          Stall_ID <= '1';
          Stall_IF <= '1';
          FlushE <= '0';
       end if;
          
          end process;
             
         end stall_unit_Arch;
         
         
         
         
         
         
         