module ALU_u(input wire signed [31:0]  SrcAE, SrcBE, // tiene que estar signed para sra
	         input wire signed [3:0]   AluControlE,

	         output wire signed	      Zero,
	         output wire signed [31:0] Result);

    reg [31:0]		      ResultReg;
    wire [31:0]		      temp,Sum;
    wire			      slt, stlu; 

    
    assign temp = AluControlE[0] ? ~SrcBE:SrcBE; //SrcBE si AluControlE[0] es 1 , es para suSrcbEtraction (R Type).
    
    assign Sum = SrcAE + temp + AluControlE[0]; // Suma de A+SrcBE+0 o es la resta de A+~SrcBE+1 (complemento de 2)
    
    assign slt = (SrcAE[31] == SrcBE[31]) ? (SrcAE < SrcBE) : SrcAE[31]; 
                        //Logica de SLT, si A es + y SrcBE es - entonces A no es menor que SrcBE, slt=0
                        //Si A es - y SrcBE es +, A es menor que SrcBE, slt=1
    assign sltu = $unsigned(SrcAE) < $unsigned(SrcBE); //for unsigned number comparison, this will give a boolean output (true - 1, false - 0)
   
    always@(*)
        case(AluControlE)
            4'b0000: ResultReg <= Sum; //add 
            4'b0001: ResultReg <= Sum; //suSrcbE 
            4'b0010: ResultReg <= SrcAE&SrcBE; //and 
            4'b0011: ResultReg <= SrcAE|SrcBE; //or 
            4'b0100: ResultReg <= SrcAE^SrcBE; //xor
            4'b0101: ResultReg <= {31'b0,slt}; //slt      
            4'b0110: ResultReg <= {31'b0,sltu}; //stlu
            4'b1010: ResultReg <= SrcAE << SrcBE; // sll, slli
            4'b1011: ResultReg <= SrcAE >>> SrcBE; // sra
            4'b1100: ResultReg <= SrcAE >> SrcBE; // srl

            default:  ResultReg <= 'bx;

        endcase

    assign Zero = (ResultReg == 32'b0);
    assign Result = ResultReg;

endmodule