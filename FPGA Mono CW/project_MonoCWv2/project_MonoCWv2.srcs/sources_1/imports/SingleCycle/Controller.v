`include "AluDec.v"
`include "MainDec.v"

module controller(    input wire [6:0] op,
                      input wire [2:0] funct3,
                      input wire funct7b5,

                      input  wire Zero,
                      input  wire ALUResult0,
                      output wire [1:0] ResultSrc,
                      output wire MemWrite,
                      output wire PCSrc, ALUSrc,
                      output wire RegWrite, Jump,
                      output wire [1:0] ImmSrc,
                      output wire [3:0] ALUControl);

    wire [1:0] ALUOP;
    wire Branch;

    wire BrBase = funct3[2] ? ALUResult0 : Zero;
    
    maindec md(.op(op), .ResultSrc(ResultSrc), .MemWrite(MemWrite), .Branch(Branch),
                   .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump), .ImmSrc(ImmSrc), .ALUOp(ALUOP));

    aludec ad(.opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5), .ALUOp(ALUOP), .ALUControl(ALUControl));

    wire BrTaken = Branch & (BrBase ^ funct3[0]);
    assign PCSrc = BrTaken | Jump;

endmodule