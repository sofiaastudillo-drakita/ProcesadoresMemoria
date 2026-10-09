module flopr32 (input wire clk, reset,
                input wire [31:0] d,
                output wire [31:0] q);

    reg [31:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 31'b0;
            
        else
            qout <= d;

    assign q = qout;

endmodule

module flopenr32  (input wire clk, reset, en,
                input wire [31:0] d,
                output wire [31:0] q);

    reg [31:0] qout;
    always@(posedge clk)
        if (reset)
            qout <= 31'b0;
            
        else if (en)
            qout <= d;

    assign q = qout;

endmodule