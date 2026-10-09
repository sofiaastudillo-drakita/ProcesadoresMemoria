module Extend(input wire [31:7]  InstrD,
	      	  input wire [1:0] 	 ImmSrcD, 
              
	      	  output wire [31:0] ImmExtD );
   
    reg [31:0] 			 ImmExtReg;
   
    always@(*)
        case(ImmSrcD)
        //I-type
            2'b00: ImmExtReg = {{20{InstrD[31]}},InstrD[31:20]};
        //S-type
            2'b01: ImmExtReg = {{20{InstrD[31]}},InstrD[31:25],InstrD[11:7]};
        //B-type
            2'b10: ImmExtReg = {{20{InstrD[31]}},InstrD[7],InstrD[30:25],InstrD[11:8],1'b0};
        //J-type
            2'b11: ImmExtReg = {{12{InstrD[31]}},InstrD[19:12],InstrD[20],InstrD[30:21],1'b0};
            default: ImmExtReg = 32'bx; 
        endcase
   
   assign ImmExtD = ImmExtReg;

endmodule