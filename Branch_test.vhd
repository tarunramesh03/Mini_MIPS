
--MIPS Processor


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity branch_test is
  port (
      Clock : in std_logic;
      stallID: in STD_LOGIC := '1'; 
      stallIF: in STD_LOGIC := '1'; 
      FlushE: in STD_LOGIC := '0';
      ForwardAD: in STD_LOGIC := '0';
      ForwardBD: in STD_LOGIC := '0';
      RegWriteW_Out: in STD_LOGIC := '0';
      WriteRegW_Out: in STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
      ResultW: in STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
      ALUOut: in STD_LOGIC_VECTOR (31 downto 0) := (others=>'0');
      RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, BranchD : out std_logic := '0';
      ALUControlE : out std_logic_vector(2 downto 0) := (others=>'0');
      
      RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0) := (others=>'0');  --First 3 are for Execution State. Last 2 are for Hazard Unit
      Reg_Output1, Reg_Output2, SignImmdE : out std_logic_vector(31 downto 0) := (others=>'0')
        );
end branch_test;


architecture branch_test_arch of branch_test is
  
  

  
  component IF_Stage 
  port (
        Clock : in std_logic;
        Enable_PC : in std_logic;
        Enable_BUFF : in std_logic;
        Clear : in std_logic;
        MUX_sel_branch : in std_logic;
        MUX_sel_jump : in std_logic;
        Branch_Address: in std_logic_vector(31 downto 0);
        Jump_Address: in std_logic_vector(31 downto 0);
        InstructionF, PC_F: out std_logic_vector(31 downto 0)
          );
  end component;
  
  component ID_Stage
  port
  (
  Clock : in std_logic;	
  Clear : in std_logic;
  
  Mux1_Sel_BD, Mux2_Sel_BD: in std_logic;  --SEL Pins for Branch Detect MUXs. To be connected to ForwardAD and ForwardBD
  RegWriteW : in std_logic;  --Coming back from the last stage.
  Write_Back_Address : in std_logic_vector(4 downto 0);  --Address of write back register.
  InstrustionD, Write_Data, PcPlus3, ALUOut : in std_logic_vector(31 downto 0);  --InstructionD and PcPlus3 are coming from IF stage. Write_Data from the write back stage. ALUOut from data memory stage.  

  RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, PcSrcD, BranchD, JumpD : out std_logic;
  ALUControlE : out std_logic_vector(2 downto 0);

  RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0);  --First 3 are for Execution State. Last 2 are for Hazard Unit
  Reg_Output1, Reg_Output2, SignImmdE : out std_logic_vector(31 downto 0);
  Reg_Output1F : out std_logic_vector(31 downto 0); --For jump Feedback to IF stage
  Adder_Sign_Extend_Out : out std_logic_vector(31 downto 0)  --Branch address going to PC
  );
  end component;
  

  --Signals for IF Stage
  signal PCSrcD, jump : std_logic;
  signal PCBranchD, RD1, InstrD, PCPlus3D : std_logic_vector(31 downto 0);
  
  
  begin
    
    IFStage: IF_Stage port map ( Clock => Clock,
                                 Enable_PC => stallIF,
                                 Enable_BUFF => stallID,
                                 Clear => PCSrcD,
                                 MUX_sel_branch => PCSrcD,
                                 MUX_sel_jump => jump,
                                 Branch_Address => PCBranchD,
                                 Jump_Address => RD1,
                                 InstructionF => InstrD,
                                 PC_F => PCPlus3D);    
        
    IDStage: ID_Stage port map ( Clock => Clock,
                                 Clear => FlushE,
                                 Mux1_Sel_BD => ForwardAD,
                                 Mux2_Sel_BD => ForwardBD,
                                 RegWriteW => RegWriteW_Out,
                                 Write_Back_Address => WriteRegW_Out,
                                 InstrustionD => InstrD,
                                 Write_Data => ResultW,
                                 PcPlus3 => PCPlus3D,
                                 ALUOut => ALUOut,
                                 RegWriteE => RegWriteE,
                                 MemtoRegE => MemtoRegE,
                                 MemWriteE => MemWriteE,
                                 ALUSrcE => ALUSrcE,
                                 RegDstE => RegDstE,
                                 PcSrcD => PCSrcD,
                                 BranchD => BranchD,
                                 JumpD => jump,
                                 ALUControlE => ALUControlE,
                                 RsE => RsE,
                                 RtE => RtE,
                                 RdE => RdE,
                                 RsD => RsD,
                                 RtD => RtD,
                                 Reg_Output1 => Reg_Output1,
                                 Reg_Output2 => Reg_Output2,
                                 SignImmdE => SignImmdE,
                                 Reg_Output1F => RD1,
                                 Adder_Sign_Extend_Out => PCBranchD); 
    

 

  end branch_test_arch; 
  
  