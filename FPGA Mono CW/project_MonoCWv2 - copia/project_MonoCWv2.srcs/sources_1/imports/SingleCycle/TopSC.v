`include "CoreSC.v"
`include "InstMem.v"
`include "DataMem.v"

module top( input wire clk, reset,
            output wire [31:0] Instr, PC_Plus4); //,
            //output wire [31:0] PC, DataAdr, ReadData, WriteData);

    wire MemWrite;
    wire [31:0] PC, DataAdr, ReadData, WriteData;
    // instantiate processor and memories.
    riscvsingle rvsingle( .clk(clk), .reset(reset), .PC(PC), .Instr(Instr), .MemWrite(MemWrite), 
                          .ALUResult(DataAdr),  .WriteData(WriteData), .ReadData(ReadData),
                          .PC_Plus4(PC_Plus4));

    imem imem(.A(PC),.RD(Instr));

    dmem dmem(.clk(clk), .WE(MemWrite), .A(DataAdr), .WD(WriteData), .RD(ReadData));

endmodule