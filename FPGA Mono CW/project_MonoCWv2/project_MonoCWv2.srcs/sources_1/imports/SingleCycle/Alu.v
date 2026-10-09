module alu(input wire signed [31:0] SrcA, SrcB, // tiene que estar signed para sra
	        input wire signed [3:0] AluControl,

	        output wire signed	Zero,
	        output wire signed [31:0] Result);

    reg [31:0]		      ResultReg;
    wire [31:0]		      temp, Sum;
    wire			      slt, stlu; 

    
    assign temp = AluControl[0] ? ~SrcB:SrcB; //SrcB si AluControl[0] es 1 , es para suSrcbtraction (R Type).
    
    assign Sum = SrcA + temp + AluControl[0]; // Suma de A+SrcB+0 o es la resta de A+~SrcB+1 (complemento de 2)
    
    assign slt = (SrcA[31] == SrcB[31]) ? (SrcA < SrcB) : SrcA[31]; 
                        //Logica de SLT, si A es + y SrcB es - entonces A no es menor que SrcB, slt=0
                        //Si A es - y SrcB es +, A es menor que SrcB, slt=1

    assign sltu = $unsigned(SrcA) < $unsigned(SrcB); //for unsigned number comparison, this will give a boolean output (true - 1, false - 0)
   
    always@(*)
        case(AluControl)
            4'b0000: ResultReg <= Sum; //add 
            4'b0001: ResultReg <= Sum; //suSrcb 
            4'b0010: ResultReg <= SrcA&SrcB; //and 
            4'b0011: ResultReg <= SrcA|SrcB; //or 
            4'b0100: ResultReg <= SrcA^SrcB; //xor
            4'b0101: ResultReg <= {31'b0,slt}; //slt      
            
            4'b0110: ResultReg <= {31'b0,sltu}; //stlu
            4'b0111: ResultReg <= {SrcA[31:12],12'b0}; //lui
            4'b1000: ResultReg <= SrcA + {SrcB[31:12],12'b0}; // AUIPC
            4'b1001: ResultReg <= {SrcB[31:12],12'b0}; // LUI
            
            4'b1010: ResultReg <= SrcA << SrcB; // sll, slli
            4'b1011: ResultReg <= SrcA >>> SrcB; // sra
            4'b1100: ResultReg <= SrcA >> SrcB; // srl

            default:  ResultReg <= 'bx;

        endcase

    assign Zero = (ResultReg == 32'b0);
    assign Result = ResultReg;

endmodule