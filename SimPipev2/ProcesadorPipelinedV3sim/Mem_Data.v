module Data_Memory(input wire 	      clk, WE,
		   		   input wire [31:0]  A, WD,
		   		   output wire [31:0] RD);

    reg [31:0] 			      RAM[63:0];

    assign RD = RAM[A[7:2]]; // Alineado a Bytes, ignora direcciones que van a bytes intermedio, entra a la palabra
    // Considerando que son 64 espacios, se acortará la direccion de entrada para que no acceda mal

    initial begin
                RAM[0]  = 32'h00000000;
                RAM[1]  = 32'h00000002; 
                RAM[2]  = 32'h00000003;
                RAM[3]  = 32'hFFFFFFAC;
                RAM[4]  = 32'hFFFFFFAC;
                RAM[5]  = 32'h00000000;
                RAM[6]  = 32'h00000000;
                RAM[7]  = 32'h00000000;
                RAM[8]  = 32'h00000000;
                RAM[9]  = 32'h00000000;
                RAM[10]  = 32'h00000000;
                RAM[11]  = 32'hFFFFFFAA;
                RAM[12]  = 32'h00000000;
                RAM[13]  = 32'h00000000;
                RAM[14]  = 32'h00000000;
                RAM[15]  = 32'h00000000;
                RAM[16]  = 32'h00000000;
                RAM[17]  = 32'h00000000;
                RAM[18]  = 32'h00000000;
                RAM[19]  = 32'h00000000;

                RAM[20]  = 32'h00000000;
                RAM[21]  = 32'h00000000;
                RAM[22]  = 32'h00000000;
                RAM[23]  = 32'h00000000;
                RAM[24]  = 32'h00000000;
                RAM[25]  = 32'h00000000;
                RAM[26]  = 32'h00000000;
                RAM[27]  = 32'h00000000;
                RAM[28]  = 32'h00000000;
                RAM[29]  = 32'h00000000;

                RAM[30]  = 32'h00000000;
                RAM[31]  = 32'h00000000;
                RAM[32]  = 32'h00000000;
                RAM[33]  = 32'h00000000;
                RAM[34]  = 32'h00000000;
                RAM[35]  = 32'h00000000;
                RAM[36]  = 32'h00000000;
                RAM[37]  = 32'h00000000;
                RAM[38]  = 32'h00000000;
                RAM[39]  = 32'h00000000;

                RAM[40]  = 32'h00000000;
                RAM[41]  = 32'h00000000;
                RAM[42]  = 32'hFFFFFFAA;
                RAM[43]  = 32'h00000000;
                RAM[44]  = 32'h00000000;
                RAM[45]  = 32'h00000000;
                RAM[46]  = 32'h00000000;
                RAM[47]  = 32'h00000000;
                RAM[48]  = 32'h00000000;
                RAM[49]  = 32'h00000000;

                RAM[50]  = 32'h00000000;
                RAM[51]  = 32'h00000000;
                RAM[52]  = 32'h00000000;
                RAM[53]  = 32'h00000000;
                RAM[54]  = 32'h00000000;
                RAM[55]  = 32'h00000000;
                RAM[56]  = 32'h00000000;
                RAM[57]  = 32'h00000000;
                RAM[58]  = 32'h00000000;
                RAM[59]  = 32'h00000000;

                RAM[60]  = 32'h00000000;
                RAM[61]  = 32'h00000000;
                RAM[62]  = 32'h00000000;
                RAM[63] = 32'h00000063; 
            end



   always @(posedge clk)
        if (WE)
            RAM[A[31:2]] <= WD;

endmodule