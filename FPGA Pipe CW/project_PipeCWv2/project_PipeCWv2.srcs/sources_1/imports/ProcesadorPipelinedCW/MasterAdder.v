module PC_Target(input wire [31:0]  PCE,ImmExtE,

		 		 output wire [31:0] PCTargetE);

	assign PCTargetE = PCE + ImmExtE;

endmodule

module PC_Plus_4(input wire [31:0]  PCF,

		 		 output wire [31:0] PCPlus4F);

    assign PCPlus4F = PCF + 32'd4;

endmodule