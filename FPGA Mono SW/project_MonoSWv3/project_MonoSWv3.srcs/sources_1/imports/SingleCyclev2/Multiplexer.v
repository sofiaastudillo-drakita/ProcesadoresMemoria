module mux2_32 (input wire [31:0] d0, d1,
               input wire s,
               output wire [31:0] y);

     assign y = s ? d1 : d0;

endmodule

module mux3_32 (input wire [31:0] d0, d1, d2,
               input wire [1:0] s,
               output wire [31:0] y);

     assign y = s[1] ? d2 : (s[0] ? d1 : d0);

endmodule