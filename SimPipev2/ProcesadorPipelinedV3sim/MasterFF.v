module ff_RE(input wire clk, reset, en, //flipflop_reset_enable
             input wire [31:0] d,

             output wire [31:0] q);
             
    reg [31:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 31'b0;
            
        else if (en)
            qout <= d;

    assign q = qout;
endmodule

module ff_SRE(input wire clk, reset, stall, //flipflop_stall_flush_reset_enable
               input wire [31:0] dd,

               output wire [31:0] qq);

    wire enableStall;
    assign enableStall = ~stall;

    ff_RE ff_RE_interior(.clk(clk), .reset(reset), .en(enableStall), .d(dd), .q(qq));

endmodule

module ff_SFRE(input wire clk, reset, stall, flush, //flipflop_stall_flush_reset_enable
               input wire [31:0] dd,

               output wire [31:0] qq);

    wire enableStall;
    wire resetflush;

    assign enableStall = ~stall; 
    assign resetflush = reset|flush;

    ff_RE ff_RE_interior(.clk(clk), .reset(resetflush), .en(enableStall), .d(dd), .q(qq));

endmodule


module ff_R1b(input wire clk, reset, //flipflop_reset_1bit
              input wire d,

              output wire q);
             
    reg qout;
    always@(posedge clk)
        if (reset)
            qout <= 1'b0;
        else
            qout <= d;

    assign q = qout;
endmodule

module ff_R2b(input wire clk, reset, //flipflop_reset_2bits
              input wire [1:0] d,

              output wire [1:0] q);
             
    reg [1:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 2'b0;
        else
            qout <= d;

    assign q = qout;
endmodule

module ff_R4b(input wire clk, reset, //flipflop_reset_4bits
              input wire [3:0] d,

              output wire [3:0] q);
             
    reg [3:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 4'b0;
        else
            qout <= d;

    assign q = qout;
endmodule

module ff_R5b(input wire clk, reset, //flipflop_reset_5bits
              input wire [4:0] d,

              output wire [4:0] q);
             
    reg [4:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 5'b0;
        else
            qout <= d;

    assign q = qout;
endmodule

module ff_R32b(input wire clk, reset, //flipflop_reset_32bits
               input wire [31:0] d,

               output wire [31:0] q);
             
    reg [31:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 32'b0;
        else
            qout <= d;

    assign q = qout;
endmodule

module ff_D(input wire [31:0] RD, PCF, PCPlus4F,
            input wire StallD, FlushD, clk, reset, PCSrcE,

            output wire [31:0] InstrD, PCD, PCPlus4D);

    wire localStall;
    assign localStall = (StallD|PCSrcE);

    ff_SFRE ff_RDIM (.clk(clk),
                     .reset(reset),
                     .stall(localStall),
                     .flush(FlushD),
                     .dd(RD),            
                     .qq(InstrD));

    ff_SFRE ff_PCF (.clk(clk),
                    .reset(reset),
                    .stall(localStall),
                    .flush(FlushD),
                    .dd(PCF),            
                    .qq(PCD));

    ff_SFRE ff_PCPlus4F (.clk(clk),
                         .reset(reset),
                         .stall(localStall),
                         .flush(FlushD),
                         .dd(PCPlus4F),            
                         .qq(PCPlus4D));

endmodule

module ff_E(input wire RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD, clk, reset, FlushE,
            input wire [1:0] ResultSrcD,
            input wire [3:0] AluControlD,
            input wire [4:0] Rs1D, Rs2D, RdD,
            input wire [31:0] PCD, RD1, RD2, ImmExtD, PCPlus4D, InstrD,

            output wire RegWriteE, MemWriteE, JumpE, BranchE, AluSrcE,
            output wire [1:0] ResultSrcE,
            output wire [3:0] AluControlE,
            output wire [4:0] Rs1E, Rs2E, RdE,
            output wire [31:0] PCE, RD1E, RD2E, ImmExtE, PCPlus4E, InstrE);
    
    wire resetLocal;
    assign resetLocal = (FlushE|reset);

    ff_R32b ff_PCE (.clk(clk),
                    .reset(resetLocal),
                    .d(PCD),
                    .q(PCE));
    
    ff_R32b ff_RD1E (.clk(clk),
                     .reset(resetLocal),
                     .d(RD1),
                     .q(RD1E));
    
    ff_R32b ff_RD2E (.clk(clk),
                     .reset(resetLocal),
                     .d(RD2),
                     .q(RD2E));
    
    ff_R32b ff_ImmExtE (.clk(clk),
                        .reset(resetLocal),
                        .d(ImmExtD),
                        .q(ImmExtE));
    
    ff_R32b ff_PCPlus4E (.clk(clk),
                         .reset(resetLocal),
                         .d(PCPlus4D),
                         .q(PCPlus4E));

    ff_R32b ff_InstrE (.clk(clk),
                         .reset(resetLocal),
                         .d(InstrD),
                         .q(InstrE));

    ff_R1b ff_RegWriteE (.clk(clk),
                         .reset(resetLocal),
                         .d(RegWriteD),
                         .q(RegWriteE));

    ff_R1b ff_MemWriteE (.clk(clk),
                         .reset(resetLocal),
                         .d(MemWriteD),
                         .q(MemWriteE));

    ff_R1b ff_JumpE (.clk(clk),
                     .reset(resetLocal),
                     .d(JumpD),
                     .q(JumpE));

    ff_R1b ff_BranchE (.clk(clk),
                       .reset(resetLocal),
                       .d(BranchD),
                       .q(BranchE));

    ff_R1b ff_ALUSrcE (.clk(clk),
                       .reset(resetLocal),
                       .d(AluSrcD),
                       .q(AluSrcE));

    ff_R2b ff_ResultSrcE (.clk(clk),
                          .reset(resetLocal),
                          .d(ResultSrcD),
                          .q(ResultSrcE));

    ff_R4b ff_AluControlE (.clk(clk),
                            .reset(resetLocal),
                            .d(AluControlD),
                            .q(AluControlE));

    ff_R5b ff_Rd1E (.clk(clk),
                   .reset(resetLocal),
                   .d(Rs1D),
                   .q(Rs1E));

    ff_R5b ff_Rd2E (.clk(clk),
                    .reset(resetLocal),
                    .d(Rs2D),
                    .q(Rs2E));

    ff_R5b ff_RdE (.clk(clk),
                   .reset(resetLocal),
                   .d(RdD),
                   .q(RdE));

endmodule



module ff_M(input wire RegWriteE, MemWriteE, clk, reset,
            input wire [1:0] ResultSrcE,
            input wire [4:0] RdE,
            input wire [31:0] AluResultE, WriteDataE, PCPlus4E,
            input wire [31:0] PCTargetE,
            

            output wire RegWriteM, MemWriteM,
            output wire [1:0] ResultSrcM,
            output wire [4:0] RdM,
            output wire [31:0] AluResultM, WriteDataM, PCPlus4M,
            output wire [31:0] PCTargetM);

    ff_R32b ff_PCTargetM (.clk(clk),
                           .reset(reset),
                           .d(PCTargetE),
                           .q(PCTargetM));

    ff_R32b ff_AluResultM (.clk(clk),
                           .reset(reset),
                           .d(AluResultE),
                           .q(AluResultM));
    
    ff_R32b ff_WriteDataM (.clk(clk),
                          .reset(reset),
                          .d(WriteDataE),
                          .q(WriteDataM));

    ff_R32b ff_PCPlus4M (.clk(clk),
                         .reset(reset),
                         .d(PCPlus4E),
                         .q(PCPlus4M));

    ff_R1b ff_RegWriteM (.clk(clk),
                         .reset(reset),
                         .d(RegWriteE),
                         .q(RegWriteM));

    ff_R1b ff_MemWriteM (.clk(clk),
                         .reset(reset),
                         .d(MemWriteE),
                         .q(MemWriteM));

    ff_R2b ff_ResultSrcM (.clk(clk),
                          .reset(reset),
                          .d(ResultSrcE),
                          .q(ResultSrcM));


    ff_R5b ff_RdM (.clk(clk),
                   .reset(reset),
                   .d(RdE),
                   .q(RdM));

endmodule

module ff_W(input wire RegWriteM, clk, reset,
            input wire [1:0] ResultSrcM,
            input wire [4:0] RdM,
            input wire [31:0] AluResultM, RD, PCPlus4M,

            output wire RegWriteW,
            output wire [1:0] ResultSrcW,
            output wire [4:0] RdW,
            output wire [31:0] AluResultW, ReadDataW, PCPlus4W);

    ff_R32b ff_AluResultW (.clk(clk),
                           .reset(reset),
                           .d(AluResultM),
                           .q(AluResultW));
    
    ff_R32b ff_ReadDataW (.clk(clk),
                          .reset(reset),
                          .d(RD),
                          .q(ReadDataW));

    ff_R32b ff_PCPlus4W (.clk(clk),
                         .reset(reset),
                         .d(PCPlus4M),
                         .q(PCPlus4W));

    ff_R1b ff_RegWriteW (.clk(clk),
                         .reset(reset),
                         .d(RegWriteM),
                         .q(RegWriteW));

    ff_R2b ff_ResultSrcW (.clk(clk),
                          .reset(reset),
                          .d(ResultSrcM),
                          .q(ResultSrcW));

    ff_R5b ff_RdW (.clk(clk),
                   .reset(reset),
                   .d(RdM),
                   .q(RdW));

endmodule

module invCLK (input wire CLK,
               output wire invCLK);

    assign invCLK = ~CLK;

endmodule