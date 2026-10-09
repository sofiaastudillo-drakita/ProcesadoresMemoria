`timescale 1ns / 1ps

module Pipelined_TB();

reg clk = 0;
reg reset;
wire [31:0] InstrE_OB;
wire StallF_OB, StallD_OB, FlushD_OB, FlushE_OB;
//wire program_exec_OB;

// Reloj 100 MHz (periodo 10 ns)
always #5 clk = ~clk;

// Instancia del top
Top Pipelined_Top (
    .clk_100MHz(clk),
    .reset(reset),
    //.program_exec_ob(program_exec_OB),
    .StallF_OBS(StallF_OB),
    .StallD_OBS(StallD_OB),
    .FlushD_OBS(FlushD_OB),
    .FlushE_OBS(FlushE_OB),
    .InstrE_OBS(InstrE_OB)
);

// Inicialización y estímulos
initial begin
    // Generar VCD para waveforms
    $dumpfile("sim.vcd");
    $dumpvars(0, Pipelined_TB);

    // Reset inicial
    reset = 0;
    #10;           // esperar un ciclo
    reset = 1;     // activar reset
    #10;           // mantener reset 3 ciclos
    reset = 0;     // desactivar

    // Simular por más tiempo (ej. 1000 ns)
    #1000;
    $finish;
end

// Mostrar estado en cada flanco de reloj (mejor usar $display que $monitor)
always @(posedge clk) begin
    $display("Time = %t, InstrE = %h, StallF = %b, StallD = %b, FlushD = %b, FlushE = %b",
              $time, InstrE_OB, StallF_OB, StallD_OB, FlushD_OB, FlushE_OB);
end

endmodule