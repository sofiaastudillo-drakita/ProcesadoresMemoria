module aludec( input wire opb5,
               input wire [2:0] funct3,
               input wire funct7b5,
               input wire [1:0] ALUOp,
               output wire [3:0] ALUControl);

     wire RtypeSub;
     reg [3:0] ALUControlIN;
     assign RtypeSub = funct7b5 & opb5;  // TRUE for R–type subtract

     always@(*)
          case(ALUOp)
                    2'b00:  ALUControlIN = 4'b0000; //Suma
                    2'b01: // Branch
                         case(funct3)
                              3'b000, 3'b001: ALUControlIN = 4'b0001; // beq, bne  → resta (Zero)
                              3'b100, 3'b101: ALUControlIN = 4'b0101; // blt, bge  → slt (signed)
                              3'b110, 3'b111: ALUControlIN = 4'b0110; // bltu,bgeu → sltu (unsigned)
                              default:        ALUControlIN = 4'bxxxx;
                         endcase
                    2'b10: //ALUOp = 2'b10
                         case(funct3)//R-type or I-type ALU
                              3'b000:    
                                   if (RtypeSub) ALUControlIN = 4'b0001; //sub
                                   else ALUControlIN = 4'b0000; //add,addi
                              3'b001: ALUControlIN = 4'b1010; //sll, slli; 
                              3'b010: ALUControlIN = 4'b0101; //slt,slti
                              3'b100: ALUControlIN = 4'b0100; //xor
                              3'b101: 
                                   if (funct7b5) ALUControlIN = 4'b1011; //sra 
                                   else ALUControlIN = 4'b1100; // srl 
                              3'b110: ALUControlIN = 4'b0011; //or,ori
                              3'b111: ALUControlIN = 4'b0010; //and,andi
                              default: ALUControlIN = 4'bxxx; 
                         endcase
                    2'b11:
                         case(funct3)
                              default: ALUControlIN = 4'bxxxx;
                         endcase
                    default: ALUControlIN = 4'bxxxx;      
          endcase
          

     assign ALUControl = ALUControlIN;

endmodule