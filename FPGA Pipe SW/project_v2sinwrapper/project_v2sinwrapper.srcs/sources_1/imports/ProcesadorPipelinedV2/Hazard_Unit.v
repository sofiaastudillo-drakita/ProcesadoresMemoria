module stall_u (input wire [4:0] Rs1D, Rs2D, RdE, 
                  input wire ResultSrcE0,
                  
                  output wire lwStall);

    wire F1DE;
    wire F2DE;

    assign F1DE = (Rs1D == RdE);
    assign F2DE = (Rs2D == RdE);

    assign lwStall = ResultSrcE0 & (F1DE | F2DE);
endmodule

module flush_u (input wire lwStall, PCSrcE,
                output wire FlushD, FlushE);
    assign FlushD = PCSrcE;
    assign FlushE = (lwStall | PCSrcE);
endmodule

module forwarding_u (input wire [4:0] Rs1E, Rs2E, RdM, RdW, 
                     input wire RegWriteM, RegWriteW,
                     output wire [3:0] ForwardAEBE);
                       
    wire F1EM;
    wire F1EW;
    wire F2EM;
    wire F2EW;
    wire F1EN0;
    wire F2EN0;
    assign F1EM = (Rs1E==RdM);
    assign F2EM = (Rs2E==RdM);
    assign F1EW = (Rs1E==RdW);
    assign F2EW = (Rs2E==RdW);
    assign F1EN0 = (Rs1E != 5'b00000);
    assign F2EN0 = (Rs2E != 5'b00000);

    wire FwdAM;
    wire FwdAW;
    assign FwdAM = (F1EM & RegWriteM & F1EN0);
    assign FwdAW = (F1EW & RegWriteW & F1EN0);

    wire FwdBM;
    wire FwdBW;
    assign FwdBM = (F2EM & RegWriteM & F2EN0);
    assign FwdBW = (F2EW & RegWriteW & F2EN0);

    assign ForwardAEBE = {FwdAM,FwdAW,FwdBM,FwdBW};
    
endmodule


module Hazard_unit (input wire ResultSrcE0, RegWriteM, RegWriteW, PCSrcE,
                input wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,

                output wire StallF, StallD, FlushD, FlushE,
                output wire [1:0] ForwardAE, ForwardBE);


    wire StallUnion;
    wire [3:0] ForwardingUnion;

    stall_u STUv2(.Rs1D(Rs1D), .Rs2D(Rs2D), .RdE(RdE), .ResultSrcE0(ResultSrcE0),
                   .lwStall(StallUnion));

    flush_u FLUv2(.lwStall(StallUnion), .PCSrcE(PCSrcE), .FlushD(FlushD), .FlushE(FlushE));

    forwarding_u FWUv2(.Rs1E(Rs1E), .Rs2E(Rs2E), .RdM(RdM), .RdW(RdW), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
                        .ForwardAEBE(ForwardingUnion));

    assign StallF = StallUnion;
    assign StallD = StallUnion;
    assign ForwardAE = ForwardingUnion[3:2];
    assign ForwardBE = ForwardingUnion[1:0];

endmodule