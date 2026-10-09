`include "Wrapper_Nexys.v"

module wrapper_nexys_top (input wire clk_100MHz, reset, swt_count, swt_mode, button,
                      output wire [6:0] Seg7_fpga,
                      output wire [7:0] AnodosSeg_fpga);
    
    wire clk;
    wire locked;
    clk_wiz_0 clk_wiz_inst (
        .clk_in1(clk_100MHz),
        .reset(reset),
        .clk_out1(clk),
        .locked(locked));
    
    wire [31:0] Instr;
    wire [31:0] PC_Plus4;                  
    top toppyty (.clk(clk), .reset(reset), .Instr(Instr), .PC_Plus4(PC_Plus4));
    
    wire [31:0] countty_sel;        
    counter_program_cycles_instr cpci(.clk(clk), .reset(reset), .swt_count(swt_count), .swt_mode(swt_mode), .button(button),
                                  .InstrE(Instr), .PCPlus_4E(PC_Plus4),
                                  .counter_select_x2(countty_sel));
                                         
    wire clk_seven_seg;
    Clock_divider_1000Hz clk_sevenseg( .clk(clk), .reset(reset), .clk_out(clk_seven_seg) );
    
    wire [6:0] segments;
    wire [7:0] anodes;
    Seven_seg_dec_n_mux seven_deccy (
        .clk(clk_seven_seg),
        .input32b(countty_sel),
        .segments(segments),
        .anodes(anodes));
    assign Seg7_fpga = segments;
    assign AnodosSeg_fpga = anodes;                             
                                  
endmodule