`include "CoreSC.v"
`include "InstMem.v"
`include "DataMem.v"

module top( input wire clk, reset,
            output wire [31:0] PC, Instr,
            output wire [31:0] DataAdr, ReadData, WriteData);

    wire MemWrite;

    // instantiate processor and memories.
    riscvsingle rvsingle( .clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .MemWrite(MemWrite), 
                          .ALUResult(DataAdr),  .WriteData(WriteData), .ReadData(ReadData));

    imem imem(.A(PC),.RD(Instr));

    dmem dmem(.clk(clk), .WE(MemWrite), .A(DataAdr), .WD(WriteData), .RD(ReadData));

endmodule