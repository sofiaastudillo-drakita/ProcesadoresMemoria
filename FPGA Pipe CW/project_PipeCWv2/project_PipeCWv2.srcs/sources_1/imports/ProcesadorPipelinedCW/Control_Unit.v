`include "Dec_ALU.v"
`include "Dec_Main.v"
module Control_Unit(input wire [6:0]  op,
					input wire [2:0]  funct3,
					input wire	      funct7b5,

					output wire [1:0] ResultSrcD,
					output wire	      MemWriteD, BranchD, ALUSrcD, RegWriteD, JumpD,
					output wire [1:0] ImmSrcD,
					output wire [3:0] ALUControlD);

   	wire [1:0]			      ALUop;
   
   	Main_Decoder Main_Dec (.op(op),
			     		  .ResultSrcD(ResultSrcD),
			     		  .MemWriteD(MemWriteD),
			     		  .BranchD(BranchD),
  			     		  .ALUSrcD(ALUSrcD),
			     		  .RegWriteD(RegWriteD),
  			     		  .JumpD(JumpD),
			     		  .ImmSrcD(ImmSrcD),
			     		  .ALUop(ALUop) );
   
    ALU_Decoder ALU_Dec (.opb5(op[5]),
			   		   .funct3(funct3),
			   		   .funct7b5(funct7b5),
			   		   .ALUOp(ALUop),
			   		   .ALUControlD(ALUControlD) );
    
endmodule