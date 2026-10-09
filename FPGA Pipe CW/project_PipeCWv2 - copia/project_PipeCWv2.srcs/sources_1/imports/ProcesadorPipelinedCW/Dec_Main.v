
module Main_Decoder(input wire [6:0]  op,

		   		    output wire [1:0] ResultSrcD,
		    		output wire       MemWriteD, BranchD,ALUSrcD, RegWriteD,JumpD,
		    		output wire [1:0] ImmSrcD, ALUop);

    reg [10:0] 			      control_signals;
   
    always@(*)
        case(op)
        //RegWriteD_ImmSrcD_ALUSrcD_MemWriteD_ResultSrcD_BranchD_ALUop_JumpD
            7'b0000011: control_signals = 11'b1_00_1_0_01_0_00_0;//LW 
            7'b0100011: control_signals = 11'b0_01_1_1_00_0_00_0;//SW 
            7'b0110011: control_signals = 11'b1_xx_0_0_00_0_10_0;//R-type 
            7'b0010011: control_signals = 11'b1_00_1_0_00_0_10_0;//I-type ALU 
            7'b1100011: control_signals = 11'b0_10_0_0_00_1_01_0;//B-type Branch
            7'b1101111: control_signals = 11'b1_11_0_0_10_0_00_1;//jal
            7'b1100111: control_signals = 11'b1_00_1_0_10_0_00_1;//jalr
            7'b0110111: control_signals = 11'b1_00_1_0_00_0_11_0;//U-type lui
            7'b0010111: control_signals = 11'b1_00_1_0_00_0_01_0;//U-type AUIPC
            7'b0000000: control_signals = 11'b0_00_0_0_00_0_00_0;//RESET condition

         default:    control_signals = 11'bx_xx_x_x_xx_x_xx_x;
        endcase

   assign {RegWriteD,ImmSrcD,ALUSrcD,MemWriteD,ResultSrcD,BranchD,ALUop,JumpD} = control_signals;	
   
endmodule