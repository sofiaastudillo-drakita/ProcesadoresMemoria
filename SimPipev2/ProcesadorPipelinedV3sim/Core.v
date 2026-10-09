`include "Datapath.v"
`include "Control_Unit.v"
`include "Hazard_Unit.v"
module Core (input clk, reset, //Necesarios
             input wire [31:0] RDIM, RDDM, //Necesarios

             output wire MemWriteM, StallF, StallD, FlushD, FlushE, //Necesarios
             output wire [31:0] PCF, ALUResultM, WriteDataM, InstrE, PCPlus4EoB,//Necesarios

             //output wire [1:0] ResultSrcD,
             output wire [1:0] ForwardAE, ForwardBE);
             //output wire MemWriteD, BranchD, ALUSrcD, RegWriteD, JumpD, 
             //output wire [1:0] ImmSrcD,
			 //output wire [3:0] ALUControlD,
             //output wire [31:0] InstrD,
             //output wire [31:0] PCPlus_4FoB, PCTargetEoB,

             //output wire PcSrcEOB, ResultSrcE0OB, RegWriteMOB, RegWriteWOB,
             //output wire [4:0] Rs1DOB, Rs2DOB, Rs1EOB, Rs2EOB, RdEOB, RdMOB, RdWOB,
             
             //output wire [31:0] PCPlus4DoB,
             //output wire PCSrcMOB,
             //output wire ZeroE,
			 //output wire [31:0] SrcAE,
			 //output wire [31:0] SrcBE);

    wire [1:0] ResultSrcD;
    //wire [1:0] ForwardAE, ForwardBE;
    wire MemWriteD, BranchD, ALUSrcD, RegWriteD, JumpD; 
    wire [1:0] ImmSrcD;
	wire [3:0] ALUControlD;
    wire [31:0] InstrD;
    wire [31:0] PCPlus_4FoB, PCTargetEoB;

    wire PcSrcEOB, ResultSrcE0OB, RegWriteMOB, RegWriteWOB;
    wire [4:0] Rs1DOB, Rs2DOB, Rs1EOB, Rs2EOB, RdEOB, RdMOB, RdWOB;
    wire [31:0] PCPlus4DoB; //,PCPlus4EoB;
    wire PCSrcMOB;
    wire ZeroE;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;


    wire [6:0] op;
    wire [2:0] funct3;
    wire funct7b5;
    wire [31:0] PCTargetM;
	wire [31:0] PCFNext;

    Datapath DatapathCore  (.clk(clk), .reset(reset), .RDIM(RDIM), .StallF(StallF), .StallD(StallD), 
                            .FlushD(FlushD), .FlushE(FlushE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), 
                            .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .BranchD(BranchD), 
                            .ALUSrcD(ALUSrcD), .RegWriteD(RegWriteD), .JumpD(JumpD),
			                .ImmSrcD(ImmSrcD), .ALUControlD(ALUControlD), .PCPlus_4FOB(PCPlus_4FoB), .PCPlus4EOB(PCPlus4EoB), .PCTargetEOB(PCTargetEoB),

                            .RDDM(RDDM),


                            .PCF(PCF),

                            .PCSrcE(PcSrcEOB), .ResultSrcE0(ResultSrcE0OB), .RegWriteM(RegWriteMOB), 
                            .RegWriteW(RegWriteWOB), .Rs1D(Rs1DOB), .Rs2D(Rs2DOB), .Rs1E(Rs1EOB), 
                            .Rs2E(Rs2EOB), .RdE(RdEOB), .RdM(RdMOB), .RdW(RdWOB),

                            .InstrD(InstrD),
                            
                            .MemWriteM(MemWriteM),
                            .ALUResultM(ALUResultM), .WriteDataM(WriteDataM),
                            .PCPlus4D(PCPlus4DoB), .InstrE(InstrE),
                            .ZeroE(ZeroE),
				            .SrcAE(SrcAE),
				            .SrcBE(SrcBE),
                            .PCTargetM(PCTargetM),
				            .PCFNext(PCFNext));

    assign op = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7b5 = InstrD[30];

    Control_Unit ControlUnit (.op(op), .funct3(funct3), .funct7b5(funct7b5),
                             .ResultSrcD(ResultSrcD), .MemWriteD(MemWriteD), .BranchD(BranchD), 
                             .ALUSrcD(ALUSrcD), .RegWriteD(RegWriteD), .JumpD(JumpD), .ImmSrcD(ImmSrcD),
					         .ALUControlD(ALUControlD));

    Hazard_unit HazardUnit (.ResultSrcE0(ResultSrcE0OB), .RegWriteM(RegWriteMOB), .RegWriteW(RegWriteWOB), .PCSrcE(PcSrcEOB),
                        .Rs1D(Rs1DOB),.Rs2D(Rs2DOB),.Rs1E(Rs1EOB),.Rs2E(Rs2EOB),.RdE(RdEOB),.RdM(RdMOB),.RdW(RdWOB),

                           .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE), 
                           .ForwardAE(ForwardAE), .ForwardBE(ForwardBE));
                           
endmodule