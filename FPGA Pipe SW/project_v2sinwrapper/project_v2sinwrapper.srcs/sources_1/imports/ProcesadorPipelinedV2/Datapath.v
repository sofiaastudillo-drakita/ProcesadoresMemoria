`include "MasterAdder.v"
`include "MasterMux.v"
`include "MasterFF.v"
`include "Extend.v"
`include "Reg_File.v"
`include "ALU.v"

module Datapath (input clk, reset,

                 input wire [31:0] RDIM,

                 input wire StallF, StallD, FlushD, FlushE,
                 input wire [1:0] ForwardAE, ForwardBE,

                 input wire [1:0] ResultSrcD,
				 input wire MemWriteD, BranchD, ALUSrcD, RegWriteD, JumpD,
			     input wire [1:0] ImmSrcD,
				 input wire [3:0] ALUControlD,

                 input wire [31:0] RDDM,


                 output wire [31:0] PCF,

                 output wire PCSrcE, ResultSrcE0, RegWriteM, RegWriteW,
                 output wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,

                 output wire [31:0] InstrD,

				 output wire MemWriteM,
                 output wire [31:0] ALUResultM, WriteDataM,
				 output wire [31:0] PCPlus_4FOB, PCPlus4EOB, PCTargetEOB,
				 output wire [31:0] PCPlus4D, InstrE,
				 output wire ZeroE,
				 output wire [31:0] SrcAE,
				 output wire [31:0] SrcBE,
				 output wire [31:0] PCTargetM,
				 output wire [31:0] PCFNext);

    // FETCH

	wire [31:0] PCPlus_4F;
	wire [31:0] PCTargetE;
	wire [31:0] PCPlus4E;
	assign PCPlus_4FOB = PCPlus_4F;
	assign PCTargetEOB = PCTargetE;
	assign PCPlus4EOB = PCPlus4E;

    ff_SRE ff_Fetch(.clk(clk), .reset(reset), .stall(StallF), .dd(PCFNext), .qq(PCF));

    PC_Plus_4 Adder_Fetch(.PCF(PCF),.PCPlus4F(PCPlus_4F) );

    Mux_F Mux_Fetch(.PCSrcE(PCSrcE),.PCPlus4F(PCPlus_4F), .PCTargetE(PCTargetE), .PC_NextF(PCFNext));


    // DECODE

	wire [31:0] PCD;
	wire [31:0] ImmExtD; 
	wire [31:0] ResultW;
	wire [31:0] RD1;
	wire [31:0] RD2;

	wire RegClock;
	invCLK RegCLK(.CLK(clk), .invCLK(RegClock));

    ff_D ff_Decode (.RD(RDIM), .PCF(PCF), .PCPlus4F(PCPlus_4F), .StallD(StallD), 
                   .FlushD(FlushD), .clk(clk), .reset(reset),.PCSrcE(PCSrcE), .InstrD(InstrD), 
                   .PCD(PCD), .PCPlus4D(PCPlus4D));

	Extend ext_unit(.InstrD(InstrD[31:7]), .ImmSrcD(ImmSrcD), .ImmExtD(ImmExtD));

	Register_File reg_file_int(.clk(RegClock), .WE3(RegWriteW),.RA1(InstrD[19:15]),.RA2(InstrD[24:20]),
							.WA3(RdW),.WD3(ResultW),.RD1(RD1),.RD2(RD2));


    // EXECUTE

	wire RegWriteE; 
	wire MemWriteE; 
	wire JumpE; 
	wire BranchE;  
	wire ALUSrcE;
	wire [1:0] ResultSrcE;
	wire [3:0] AluControlE;
	wire [31:0] PCE; 
	wire [31:0] RD1E; 
	wire [31:0] RD2E; 
	wire [31:0] ImmExtE;
	 
	wire [4:0] RdD;
	wire [31:0] AluResultE;
	wire [31:0] WriteDataE;
	
	assign Rs1D = InstrD[19:15];
	assign Rs2D = InstrD[24:20];
	assign RdD = InstrD[11:7];

    ff_E ff_Execute(.RegWriteD(RegWriteD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD), .AluSrcD(ALUSrcD), .clk(clk),
			.reset(reset), .FlushE(FlushE), .ResultSrcD(ResultSrcD), .AluControlD(ALUControlD), .Rs1D(Rs1D), 
			.Rs2D(Rs2D), .RdD(RdD), .PCD(PCD), .RD1(RD1), .RD2(RD2), .ImmExtD(ImmExtD), .PCPlus4D(PCPlus4D), .InstrD(InstrD),
            .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .JumpE(JumpE), .BranchE(BranchE), .AluSrcE(ALUSrcE), .ResultSrcE(ResultSrcE), 
			.AluControlE(AluControlE), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE), .PCE(PCE), 
			.RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E), .InstrE(InstrE));

	Mux_A MuxA(.ForwardAE(ForwardAE),.RD1E(RD1E), .ResultW(ResultW), .AluResultM(ALUResultM), .SrcAE(SrcAE));

	Mux_B MuxB(.ForwardBE(ForwardBE),.RD2E(RD2E), .ResultW(ResultW), .AluResultM(ALUResultM), .WriteDataE(WriteDataE));

	ALU_Mux MuxAlu(.WriteDataE(WriteDataE), .ImmExtE(ImmExtE), .ALUSrcE(ALUSrcE),.SrcBE(SrcBE));

	PC_Target Adder_Execute(.PCE(PCE), .ImmExtE(ImmExtE), .PCTargetE(PCTargetE));

	ALU_u Alu_Unit(.SrcAE(SrcAE), .SrcBE(SrcBE), .AluControlE(AluControlE), .Zero(ZeroE), .Result(AluResultE));

	wire [2:0] funct3 = InstrE[14:12] ;
	wire ALUResult0 = AluResultE[0] ;
	wire BrBase = funct3[2] ? ALUResult0 : ZeroE;
	wire BrTaken = BranchE & (BrBase ^ funct3[0]);
    assign PCSrcE = BrTaken | JumpE;
    
	assign ResultSrcE0 = ResultSrcE[0];

    // MEMORY

	wire [1:0] ResultSrcM;
	wire [31:0] PCPlus4M;

    ff_M ff_Memory (.RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .clk(clk), .reset(reset), .ResultSrcE(ResultSrcE),
            .RdE(RdE),.AluResultE(AluResultE), .WriteDataE(WriteDataE), .PCPlus4E(PCPlus4E), .PCTargetE(PCTargetE), 
			.RegWriteM(RegWriteM), .MemWriteM(MemWriteM), .ResultSrcM(ResultSrcM), .RdM(RdM), .AluResultM(ALUResultM), 
			.WriteDataM(WriteDataM), .PCPlus4M(PCPlus4M), .PCTargetM(PCTargetM));

    

    //WRITEBACK

	wire [1:0] ResultSrcW;
	wire [31:0] AluResultW;
	wire [31:0] ReadDataW; 
	wire [31:0] PCPlus4W;

    ff_W ff_Writeback (.RegWriteM(RegWriteM), .clk(clk), .reset(reset), .ResultSrcM(ResultSrcM), .RdM(RdM),
					   .AluResultM(ALUResultM), .RD(RDDM), .PCPlus4M(PCPlus4M), .RegWriteW(RegWriteW),
					   .ResultSrcW(ResultSrcW), .RdW(RdW), .AluResultW(AluResultW), 
					   .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W));

	Mux_W MuxWriteback (.ResultSrcW(ResultSrcW),.AluResultW(AluResultW), .ReadDataW(ReadDataW), 
					   .PCPlus4W(PCPlus4W),.ResultW(ResultW));

endmodule