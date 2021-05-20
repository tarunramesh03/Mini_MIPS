
--MIPS Processor


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity MIPS is
  port (
      Clock : in std_logic
        );
end MIPS;


architecture MIPS_arch of MIPS is


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

  Mux1_Sel_BD, Mux2_Sel_BD: in std_logic;  --SEL Pins for Branch Detect MUXs. Connected to ForwardAD and ForwardBD
  RegWriteW : in std_logic;  --Coming back from the last stage.
  Write_Back_Address : in std_logic_vector(4 downto 0);  --Address of write back register. 
  InstrustionD, Write_Data, PcPlus3, ALUOut : in std_logic_vector(31 downto 0);  --InstructionD and PcPlus3 are coming from IF stage. Write_Data from the write back stage. ALUOut from data memory stage.

  RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, PcSrcD, BranchD, JumpD : out std_logic;
  ALUControlE : out std_logic_vector(2 downto 0);

  RsE, RtE, RdE, RsD, RtD : out std_logic_vector(4 downto 0);  --First 3 variables are for Execution State. Last 2 variables are for Hazard Unit
  Reg_Output1, Reg_Output2, SignImmdE : out std_logic_vector(31 downto 0);
  Reg_Output1F : out std_logic_vector(31 downto 0); --For jump Feedback to IF stage
  Adder_Sign_Extend_Out : out std_logic_vector(31 downto 0)  --Branch address goes to PC
  );
  end component;

  component EX_Stage
  port
  (
  Clock : in std_logic;

  RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE  : in std_logic;
  ALUControlE : in std_logic_vector(2 downto 0);
  MUX_3IN_Sel1, MUX_3IN_Sel2 : in std_logic_vector(1 downto 0);  --ForwardAE and ForwardBE

  Reg_Output1, Reg_Output2, SignImmdE, ALUOut_DM, Result_WB : in std_logic_vector(31 downto 0);
  RsE, RtE, RdE  : in std_logic_vector(4 downto 0);

  RegWriteM, MemtoRegM, MemWriteM : out std_logic;
  RsE_HU, RtE_HU : out std_logic_vector(4 downto 0);
  RegWriteE_HU, MemtoRegE_HU : out std_logic;
  ALU_OutM : out std_logic_vector(31 downto 0);
  WriteDataM : out std_logic_vector(31 downto 0);
  WriteRegE, WriteRegM : out std_logic_vector(4 downto 0)
  );
  end component;

  component DM_Stage
  port
  (
    Clock : in std_logic;

    RegWriteM, MemToRegM, MemWriteM : in std_logic;
    ALUOutM, WriteDataM : in std_logic_vector(31 downto 0);
    WriteRegM : in std_logic_vector(4 downto 0);

    RegWriteW, MemToRegW : out std_logic;
    Read_DataW, ALU_OutW : out std_logic_vector(31 downto 0);
    WriteRegW : out std_logic_vector(4 downto 0);
    WriteRegM_HU: out std_logic_vector(4 downto 0);
    RegWriteM_HU, MemToRegM_HU : out std_logic;
    ALUOutM_Output : out std_logic_vector(31 downto 0)
  );
  end component;

  component WB_Stage
  port
  (

    RegWriteW, MemToRegW : in std_logic;
    Read_DataW, ALU_OutW : in std_logic_vector(31 downto 0);
    WriteRegW : in std_logic_vector(4 downto 0);

    RegWriteW_Out : out std_logic; --for Hazard Unit
    ResultW : out std_logic_vector(31 downto 0);
    WriteRegW_Out : out std_logic_vector(4 downto 0) --for Hazard Unit
  );
  end component;

  component hazard_unit
  port
  (

      WriteRegW, WriteRegM, WriteRegE: IN STD_LOGIC_VECTOR (4 downto 0);
      RegWriteM, RegWriteW, RegWriteE : IN STD_LOGIC;
      MemtoRegM, MemtoRegE : IN STD_LOGIC;

      RsE, RtE: IN STD_LOGIC_VECTOR (4 downto 0);
      RsD, RtD: IN STD_LOGIC_VECTOR (4 downto 0);
      BranchD: IN STD_LOGIC;

      Stall_ID: OUT STD_LOGIC;
      Stall_IF: OUT STD_LOGIC;
      FlushE: OUT STD_LOGIC;

      ForwardAE: OUT STD_LOGIC_VECTOR (1 downto 0);	 --mux1 selection execution stage
      ForwardBE: OUT STD_LOGIC_VECTOR (1 downto 0);	 ----mux2 selection execution stage

      ForwardBD: OUT STD_LOGIC;	 --mux1 selection decode stage
      ForwardAD: OUT STD_LOGIC	 ----mux2 selection for decode stage

  );
  end component;


  --Signals for IF Stage
  signal stallIF, stallID, PCSrcD, jump : std_logic;
  signal PCBranchD, RD1, InstrD, PCPlus3D : std_logic_vector(31 downto 0);

  --Signals for ID Stage
  signal FlushE, ForwardAD, ForwardBD, RegWriteW_Out,
         RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, BranchD :std_logic;
  signal ALUControlE : std_logic_vector(2 downto 0);
  signal WriteRegW_Out, RsE, RtE, RdE, RsD, RtD : std_logic_vector(4 downto 0);
  signal ResultW, ALUOut, Reg_Output1, Reg_Output2, SignImmdE : std_logic_vector(31 downto 0);

  --Signals for EX Stage
  signal RegWriteM, MemtoRegM, MemWriteM, RegWriteE_HU, MemtoRegE_HU : std_logic;
  signal ForwardAE, ForwardBE : std_logic_vector(1 downto 0);
  signal WriteRegE, WriteRegM, RsE_HU, RtE_HU : std_logic_vector(4 downto 0);
  signal ALU_OutM, WriteDataM : std_logic_vector(31 downto 0);

  --Signals for DM Stage
  signal RegWriteW, MemToRegW, RegWriteM_HU, MemToRegM_HU : std_logic;
  signal WriteRegW, WriteRegM_HU : std_logic_vector(4 downto 0);
  signal Read_DataW, ALU_OutW : std_logic_vector(31 downto 0);


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

    EXStage: EX_Stage port map ( Clock => Clock,
                                 RegWriteE => RegWriteE,
                                 MemtoRegE => MemtoRegE,
                                 MemWriteE => MemWriteE,
                                 ALUSrcE => ALUSrcE,
                                 RegDstE => RegDstE,
                                 ALUControlE => ALUControlE,
                                 MUX_3IN_Sel1 => ForwardAE,
                                 MUX_3IN_Sel2 => ForwardBE,
                                 Reg_Output1 => Reg_Output1,
                                 Reg_Output2 => Reg_Output2,
                                 SignImmdE => SignImmdE,
                                 ALUOut_DM => ALUOut,
                                 Result_WB => ResultW,
                                 RsE => RsE,
                                 RtE => RtE,
                                 RdE => RdE,
                                 RegWriteM => RegWriteM,
                                 MemtoRegM => MemtoRegM,
                                 MemWriteM => MemWriteM,
                                 RsE_HU => RsE_HU,
                                 RtE_HU => RtE_HU,
                                 RegWriteE_HU => RegWriteE_HU,
                                 MemtoRegE_HU => MemtoRegE_HU,
                                 ALU_OutM => ALU_OutM,
                                 WriteDataM => WriteDataM,
                                 WriteRegE => WriteRegE,
                                 WriteRegM => WriteRegM);

    DMStage: DM_Stage port map ( Clock => Clock,
                                 RegWriteM => RegWriteM,
                                 MemToRegM => MemtoRegM,
                                 MemWriteM => MemWriteM,
                                 ALUOutM => ALU_OutM,
                                 WriteDataM => WriteDataM,
                                 WriteRegM => WriteRegM,
                                 RegWriteW => RegWriteW,
                                 MemToRegW => MemToRegW,
                                 Read_DataW => Read_DataW,
                                 ALU_OutW => ALU_OutW,
                                 WriteRegW => WriteRegW,
                                 WriteRegM_HU => WriteRegM_HU,
                                 RegWriteM_HU => RegWriteM_HU,
                                 MemToRegM_HU => MemToRegM_HU,
                                 ALUOutM_Output => ALUOut);

    WBStage: WB_Stage port map ( RegWriteW => RegWriteW,
                                 MemToRegW => MemToRegW,
                                 Read_DataW => Read_DataW,
                                 ALU_OutW => ALU_OutW,
                                 WriteRegW => WriteRegW,
                                 RegWriteW_Out => RegWriteW_Out,
                                 ResultW => ResultW,
                                 WriteRegW_Out => WriteRegW_Out);

    HAZARDUNIT: hazard_unit port map ( WriteRegW => WriteRegW_Out,
                                       WriteRegM => WriteRegM_HU,
                                       WriteRegE => WriteRegE,
                                       RegWriteM => RegWriteM_HU,
                                       RegWriteW => RegWriteW_Out,
                                       RegWriteE => RegWriteE_HU,
                                       MemtoRegM => MemToRegM_HU,
                                       MemtoRegE => MemtoRegE_HU,
                                       RsE => RsE_HU,
                                       RtE => RtE_HU,
                                       RsD => RsD,
                                       RtD => RtD,
                                       BranchD => BranchD,

                                       Stall_ID => stallID,
                                       Stall_IF => stallIF,
                                       FlushE => FlushE,
                                       ForwardAE => ForwardAE,
                                       ForwardBE => ForwardBE,
                                       ForwardBD => ForwardBD,
                                       ForwardAD => ForwardAD);

  end MIPS_arch;
