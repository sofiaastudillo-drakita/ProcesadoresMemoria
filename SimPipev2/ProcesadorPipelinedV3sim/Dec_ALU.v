module ALU_Decoder(input wire	    opb5, 
		   		   input wire [2:0] funct3,
		   		   input wire	    funct7b5, 
		   		   input wire [1:0] ALUOp,
                   
		   		   output reg [3:0] ALUControlD);

    wire				    RtypeSub;
    assign RtypeSub = funct7b5 & opb5; //TRUE para resta R-type

    always@(*)
        begin
            case(ALUOp)
                2'b00:  ALUControlD = 4'b0000; //Suma
                2'b01: // Branch
                    case(funct3)
                        3'b000, 3'b001: ALUControlD = 4'b0001; // sub (beq, bne)
                        3'b100, 3'b101: ALUControlD = 4'b0101; // slt (blt, bge)
                        3'b110, 3'b111: ALUControlD = 4'b0110; // sltu (bltu, bgeu)
                        default: ALUControlD = 4'bxxxx;
                    endcase
                2'b10: //ALUOp = 2'b10
                    case(funct3)//R-type or I-type ALU
                        3'b000:    
                            if (RtypeSub) ALUControlD = 4'b0001; //sub
                            else ALUControlD = 4'b0000; //add,addi
                        3'b001: ALUControlD = 4'b1010; //sll, slli;
                        3'b010: ALUControlD = 4'b0101; //slt,slti
                        3'b100: ALUControlD = 4'b0100; //xor
                        3'b101: 
                            if (funct7b5) ALUControlD = 4'b1011; //sra
                            else ALUControlD = 4'b1100; // srl
                        3'b110: ALUControlD = 4'b0011; //or,ori
                        3'b111: ALUControlD = 4'b0010; //and,andi
                        default: ALUControlD = 4'bxxx; 
                    endcase
                default: ALUControlD = 4'bxxxx;      
            endcase
        end
    

endmodule