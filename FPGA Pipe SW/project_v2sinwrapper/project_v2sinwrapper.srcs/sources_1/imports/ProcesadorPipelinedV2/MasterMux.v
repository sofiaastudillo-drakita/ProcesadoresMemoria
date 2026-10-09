module Mux_A(input wire [1:0] ForwardAE,
             input wire [31:0] RD1E, ResultW, AluResultM,

             output wire [31:0] SrcAE);
    reg [31:0] SrAE;

    always@(*)
        case(ForwardAE)
            2'b00: SrAE <= RD1E;
            2'b01: SrAE <= ResultW;
            2'b10: SrAE <= AluResultM;
            2'b11: SrAE <= 'bx;
            default: SrAE <= 'bx;
        endcase
    assign SrcAE = SrAE;
endmodule   

module Mux_B(input wire [1:0] ForwardBE,
             input wire [31:0] RD2E, ResultW, AluResultM,

             output wire [31:0] WriteDataE);
             
    reg [31:0] WrDaE;

    always@(*)
        case(ForwardBE)
            2'b00: WrDaE <= RD2E;
            2'b01: WrDaE <= ResultW;
            2'b10: WrDaE <= AluResultM;
            2'b11: WrDaE <= 'bx;
            default: WrDaE <= 'bx;
        endcase

    assign WriteDataE = WrDaE;
endmodule 

module ALU_Mux (input wire [31:0]  WriteDataE, ImmExtE,
		        input wire	   ALUSrcE,
				
		        output wire [31:0] SrcBE);

   assign SrcBE = ALUSrcE ? ImmExtE : WriteDataE;

endmodule

//module Mux_F2(input wire [1:0] PCSrcJB,
//              input wire [31:0] PCPlus4F, PCTargetM, PCJ,

//              output wire [31:0] PC_NextF);
             
//    reg [31:0] PCnF;

//   always@(*)
//       case(PCSrcJB)
//            2'b01: PCnF <= PCTargetM; // Si es un Branch viene desde Execute
//            2'b10: PCnF <= PCJ; // Un Jump que viene desde la Supp_Jump
//            2'b11: PCnF <= PCTargetM; //La Branch tiene prioridad porque significa que el J
//            default: PCnF <= 'bx;
//        endcase

//    assign PC_NextF = PCnF;
//endmodule 

module Mux_F(input wire PCSrcE,
              input wire [31:0] PCPlus4F, PCTargetE,

              output wire [31:0] PC_NextF);
             
    reg [31:0] PCnF;

    always@(*)
        case(PCSrcE)
            2'b0: PCnF <= PCPlus4F;
            2'b1: PCnF <= PCTargetE;
            default: PCnF <= 'bx;
        endcase

    assign PC_NextF = PCnF;
endmodule 

module Mux_W(input wire [1:0] ResultSrcW,
             input wire [31:0] AluResultW, ReadDataW, PCPlus4W,

             output wire [31:0] ResultW);

    reg  [31:0] Res;
    
    always@(*)
        begin
            case(ResultSrcW)
                2'b00: Res = AluResultW;
                2'b01: Res = ReadDataW;
                2'b10: Res = PCPlus4W;
                2'b11: Res = 32'bx;
                default: Res = 32'bx;
            endcase
        end
    assign ResultW = Res;
endmodule