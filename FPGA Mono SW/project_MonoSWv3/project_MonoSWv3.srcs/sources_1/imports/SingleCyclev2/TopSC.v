`include "CoreSC.v"
`include "InstMem.v"
`include "DataMem.v"

module top( input wire clk_100MHz, reset,
            output wire [31:0] PC, Instr);
    wire [31:0] DataAdr, ReadData, WriteData;

    wire MemWrite;
    
    wire clk;
    wire locked;
    clk_wiz_0 clk_wiz_inst (
        .clk_in1(clk_100MHz),
        .reset(reset),
        .clk_out1(clk),
        .locked(locked)
    );
    
    // instantiate processor and memories.
    riscvsingle rvsingle( .clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .MemWrite(MemWrite), 
                          .ALUResult(DataAdr),  .WriteData(WriteData), .ReadData(ReadData));

    imem imem(.A(PC),.RD(Instr));

    dmem dmem(.clk(clk), .WE(MemWrite), .A(DataAdr), .WD(WriteData), .RD(ReadData));

endmodule