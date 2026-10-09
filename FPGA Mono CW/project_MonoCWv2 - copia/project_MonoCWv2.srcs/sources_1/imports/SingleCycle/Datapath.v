`include "FlipFlops.v"
`include "Adder.v"
`include "Multiplexer.v"
`include "RegFile.v"
`include "ExtendUnit.v"
`include "Alu.v"

module datapath(input wire clk, reset,

        		output wire Zero,   
               	input wire  PCSrc, ALUSrc, RegWrite,
               	input wire [1:0] ImmSrc, ResultSrc,
               	input wire [3:0] ALUControl,
               
               	output wire [31:0] PC,
               	input wire [31:0] Instr,

               	output wire [31:0] ALUResult, WriteData,
               	input wire [31:0] ReadData,
               	output wire [31:0] PC_Plus4);

   	wire [31:0] PCNext, PCPlus4, PCTarget;
   	wire [31:0] ImmExt;
   	wire [31:0] SrcA, SrcB;
   	wire [31:0] Result;


    // next PC wire
   	flopr32 pcreg(.clk(clk), .reset(reset), .d(PCNext), .q(PC));

   	adder pcadd4(.a(PC), .b(32'd4), .y(PCPlus4));

   	adder pcaddbranch(.a(PC), .b(ImmExt), .y(PCTarget));

   	mux2_32 pcmux(.d0(PCPlus4), .d1(PCTarget), .s(PCSrc), .y(PCNext));
	
    assign PC_Plus4 = PCPlus4;  

    // register file wire

   	regfile rf(.clk(clk), .WE3(RegWrite),
			.RA1(Instr[19:15]),.RA2(Instr[24:20]),.WA3(Instr[11:7]),
			.WD3(Result),.RD1(SrcA),.RD2(WriteData));

   	extend ext(.instr(Instr[31:7]),.immsrc(ImmSrc),.immext(ImmExt));



    // ALU wire
   	mux2_32 srcbmux(.d0(WriteData), .d1(ImmExt), .s(ALUSrc), .y(SrcB));

   	alu alu(.SrcA(SrcA), .SrcB(SrcB), .AluControl(ALUControl), .Zero(Zero), .Result(ALUResult));

   	mux3_32 resultmux(.d0(ALUResult), .d1(ReadData), .d2(PCPlus4), .s(ResultSrc), .y(Result));
	


endmodule