`include "Core.v"
`include "Mem_Instr.v"
`include "Mem_Data.v"
//`include "Wrapper_Nexys.v"

module Top(
    input  clk_100MHz,
    input  reset,        
    //input  sw_mode,
    //input  btn_toggle,
    //input  sw_count,
    //output wire program_exec_ob,

    output wire StallF_OBS,
    output wire StallD_OBS,
    output wire FlushD_OBS,
    output wire FlushE_OBS,
    output wire [31:0] InstrE_OBS//,
    //output wire [31:0] PCPlus4EOB,
    //output wire [6:0] Seg7_fpga,
    //output wire [7:0] AnodosSeg_fpga
    );

    //wire program_exec;
    //program_detector pd(.clk(clk_100MHz), .reset(reset), .InstrE(InstrE), .program_executing(program_exec));

    //assign program_exec_ob = program_exec;

    // Reloj TOOO COMENTAO pq PRUEBAS EN EL ICARUUUUS
    wire clk_80MHz;
    wire locked;
    clk_wiz_0 clk_wiz_inst (
        .clk_in1(clk_100MHz),
        .reset(reset),
        .clk_out1(clk_80MHz),
        .locked(locked)
    );

    // Se�ales internas del procesador
    wire MemWriteM;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultM_ob;
    wire [31:0] RDDM_ob;
    wire [31:0] PCF_ob;
    wire [31:0] RDIM_ob;
    wire StallF_ob, StallD_ob, FlushD_ob, FlushE_ob;
    wire [31:0] InstrE;
    
    wire [31:0] PCPlus4EOB;

    // Asignaciones para observaci�n (simulaci�n)
    assign StallF_OBS = StallF_ob;
    assign StallD_OBS = StallD_ob;
    assign FlushD_OBS = FlushD_ob;
    assign FlushE_OBS = FlushE_ob;
    assign InstrE_OBS = InstrE;

    // Instancia del Core
    Core Core_Unit (
        .clk          (clk_80MHz), //clk_80MHz para las true pruebas
        .reset        (reset),
        .RDIM         (RDIM_ob),
        .RDDM         (RDDM_ob),
        .MemWriteM    (MemWriteM),
        .StallF       (StallF_ob),
        .StallD       (StallD_ob),
        .FlushD       (FlushD_ob),
        .FlushE       (FlushE_ob),
        .PCF          (PCF_ob),
        .ALUResultM   (ALUResultM_ob),
        .WriteDataM   (WriteDataM),
        .InstrE       (InstrE),
        .PCPlus4EoB   (PCPlus4EOB)
    );
    
        // Memoria de datos
    Data_Memory Data_Mem (
        .clk (clk_80MHz),
        .WE  (MemWriteM),
        .A   (ALUResultM_ob),
        .WD  (WriteDataM),
        .RD  (RDDM_ob)
    );

    // Memoria de instrucciones
    Instruction_Memory Instruction_Mem (
        .A (PCF_ob),
        .RD(RDIM_ob)
    );

   
    
endmodule