`timescale 1ns / 1ps
`include "WrapperTopv2.v"
module Wrapper_TB();

reg clk = 0;
reg reset;

//wire StallF_OB, StallD_OB, FlushD_OB, FlushE_OB;
//wire program_exec_OB;

// Reloj 100 MHz (periodo 10 ns)
always #5 clk = ~clk;


reg swt_count = 0; 
reg swt_mode = 0; 
reg button = 0;

wire [31:0] CI_OB, CC_OB;
wire PO_OB;
wire [6:0] Seg7_fpga;
wire [7:0] AnodosSeg_fpga;
wire [31:0] InstrE_OB;

// Instancia del top
wrapper_nexys_topv2 Wrapper_Top (
    .clk_100MHz(clk),
    .reset(reset),
    //.program_exec_ob(program_exec_OB),
    //.StallF_OBS(StallF_OB),
    //.StallD_OBS(StallD_OB),
    //.FlushD_OBS(FlushD_OB),
    //.FlushE_OBS(FlushE_OB),    
    .swt_count(swt_count), .swt_mode(swt_mode), .button(button),

    .CI_OB(CI_OB), .CC_OB(CC_OB),
    .Instr_OB(InstrE_OB),
    .PO_OB(PO_OB),

    .Seg7_fpga(Seg7_fpga),
    .AnodosSeg_fpga(AnodosSeg_fpga)
);

// Inicialización y estímulos
initial begin
    // Generar VCD para waveforms
    $dumpfile("sim.vcd");
    $dumpvars(0, Wrapper_TB);

    // Reset inicial
    reset = 0;
    #10;           // esperar un ciclo
    reset = 1;     // activar reset
    #10;           // mantener reset 3 ciclos
    reset = 0;     // desactivar

    //swt_count = ;
    //swt_mode = ;
    //button = ;

    // Simular por más tiempo (ej. 1000 ns)
    #1000;
    $finish;
end

// Mostrar estado en cada flanco de reloj (mejor usar $display que $monitor)
always @(posedge clk) begin
    $display("Time = %t, InstrE = %h, ProgramOn= %b, CountInstructions= %d, CountCiclos= %d,  7Seg= %h, Anodos= %h",
              $time, InstrE_OB, PO_OB, CI_OB, CC_OB,  Seg7_fpga, AnodosSeg_fpga);
end

endmodule