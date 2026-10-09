module regfile (input wire 	clk, WE3,
		     	input wire [4:0] 	RA1,RA2,WA3,
		      	input wire [31:0] 	WD3,

		     	output wire [31:0] RD1,RD2);

    reg [31:0] 				Reg_File_Block[31:0];

    initial begin
        Reg_File_Block[0]  = 32'h00000000;
        Reg_File_Block[1]  = 32'h00000000; 
        Reg_File_Block[2]  = 32'h00000000;
        Reg_File_Block[3]  = 32'h00000000;
        Reg_File_Block[4]  = 32'h00000000;
        Reg_File_Block[5]  = 32'h00000000;
        Reg_File_Block[6]  = 32'h00000000;
        Reg_File_Block[7]  = 32'h00000000;

        Reg_File_Block[8]  = 32'h00000000;
        Reg_File_Block[9]  = 32'h00000000;
        Reg_File_Block[10]  = 32'h00000000;
        Reg_File_Block[11]  = 32'h00000000;
        Reg_File_Block[12]  = 32'h00000000;
        Reg_File_Block[13]  = 32'h00000000;
        Reg_File_Block[14]  = 32'h00000000;
        Reg_File_Block[15]  = 32'h00000000;

        Reg_File_Block[16]  = 32'h00000000;
        Reg_File_Block[17]  = 32'h00000000;
        Reg_File_Block[18]  = 32'h00000000;
        Reg_File_Block[19]  = 32'h00000000;
        Reg_File_Block[20]  = 32'h00000000;
        Reg_File_Block[21]  = 32'h00000000;
        Reg_File_Block[22]  = 32'h00000000;
        Reg_File_Block[23]  = 32'h00000000;

        Reg_File_Block[24]  = 32'h00000000;
        Reg_File_Block[25]  = 32'h00000000;
        Reg_File_Block[26]  = 32'h00000000;
        Reg_File_Block[27]  = 32'h00000000;
        Reg_File_Block[28]  = 32'h00000000;
        Reg_File_Block[29]  = 32'h00000000;
        Reg_File_Block[30]  = 32'h00000000;
        Reg_File_Block[31]  = 32'h00000000;

            end

    always@(posedge clk)
        begin
	        if(WE3)
	            Reg_File_Block[WA3] <= WD3;
        end

    assign RD1 = (RA1 != 0) ? Reg_File_Block[RA1] : 0;
    assign RD2 = (RA2 != 0) ? Reg_File_Block[RA2] : 0;

endmodule