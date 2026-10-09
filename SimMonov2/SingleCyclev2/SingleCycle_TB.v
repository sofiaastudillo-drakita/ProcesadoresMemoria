`timescale 1ns / 1ps

module SingleCycle_TB();

reg clk = 0;
reg reset;
wire [31:0] PC, Instr, DataAdr, ReadData, WriteData;

// Reloj 100 MHz (periodo 10 ns)
always #5 clk = ~clk;

// Instancia del top
top Single_Cycle_top    (.clk(clk), .reset(reset),
                        .PC(PC), .Instr(Instr),
                        .DataAdr(DataAdr), .ReadData(ReadData), .WriteData(WriteData));

// Inicialización y estímulos
initial begin
    // Generar VCD para waveforms
    $dumpfile("sim.vcd");
    $dumpvars(0, SingleCycle_TB);

    // Reset inicial
    reset = 0;
    #10;           // esperar un ciclo
    reset = 1;     // activar reset
    #30;           // mantener reset 3 ciclos
    reset = 0;     // desactivar

    // Simular por más tiempo (ej. 1000 ns)
    #1000;
    $finish;
end

// Mostrar estado en cada flanco de reloj (mejor usar $display que $monitor)
always @(posedge clk) begin
    $display("Time = %t, PC = %h, Instr = %h, DataAdr = %h, ReadData= %h, WriteData = %h",
              $time, PC, Instr, DataAdr, ReadData, WriteData);
end

endmodule