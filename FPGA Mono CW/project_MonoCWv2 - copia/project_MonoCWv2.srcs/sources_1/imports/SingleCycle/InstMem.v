module imem(input wire [31:0]  A,

		   	output wire [31:0] RD);

    reg [31:0] 			      Ins_Mem_Block[63:0];

    initial begin
                Ins_Mem_Block[0]  <= 32'h00000000; // 5 ciclos de llenado
                Ins_Mem_Block[1]  <= 32'h00000000;
                Ins_Mem_Block[2]  <= 32'h00000000;
                Ins_Mem_Block[3]  <= 32'h00000000;
                Ins_Mem_Block[4]  <= 32'h00000000;
                Ins_Mem_Block[5]  <= 32'h0FF00113; // ADDI sp x0, x0FF
                Ins_Mem_Block[6]  <= 32'h00000293; // ADDI t0, x0, 0 i=0
                Ins_Mem_Block[7]  <= 32'h00000313; // ADDI t1, x0, 0 i*4
                Ins_Mem_Block[8]  <= 32'h00000413; // ADDI s0, x0, 0 adress a dar
                Ins_Mem_Block[9]  <= 32'hFAC00493; // ADDI s1, x0, 0xFAC valor a encontrar
                Ins_Mem_Block[10]  <= 32'h00000393; // ADDI t2, x0, 0 valor a comparar
                // LOOP:
                Ins_Mem_Block[11]  <= 32'h00032383; // LW t2, 0(t1) 
                Ins_Mem_Block[12]  <= 32'h00938E63; // BEQ t2, s1, ACIERTO
                Ins_Mem_Block[13]  <= 32'h00128293; // ADDI t0, t0, 1    i+1
                Ins_Mem_Block[14]  <= 32'h00229313; // SLLI t1, t0, 2    i*4
                Ins_Mem_Block[15]  <= 32'h00228263; // BEQ SP, t1, FALLO
                Ins_Mem_Block[16]  <= 32'hFEDFF0EF; // J LOOP
                //FALLO:
                Ins_Mem_Block[17]  <= 32'h00002303; // LW t1, 0(x0)
                Ins_Mem_Block[18]  <= 32'h00032023; // SW s0, 0(x0)
                //ACIERTO:
                Ins_Mem_Block[19]  <= 32'h00832023; // SW s0, 0(t1)

                Ins_Mem_Block[20]  <= 32'h00000000; //Final pruebas Hazard
                
                //MAS PRUEBAS:
                Ins_Mem_Block[21]  <= 32'h40910E33; // SUB x28 x2 x9
                Ins_Mem_Block[22]  <= 32'h002E2EB3; // SLT x29 x28 x2
                Ins_Mem_Block[23]  <= 32'h008ECF33; // XOR x30 x29 x8
                Ins_Mem_Block[24]  <= 32'h40535333; // SRA x6 x6 x5
                Ins_Mem_Block[25]  <= 32'h00535333; // SRL x6 x6 x5
                Ins_Mem_Block[26]  <= 32'h002EEF13; // ORI x30 x29 x2
                Ins_Mem_Block[27]  <= 32'h01DF7EB3; // AND x29 x30 x29
                Ins_Mem_Block[28]  <= 32'h01D29333; // SLL x6 x5 x29
                Ins_Mem_Block[29]  <= 32'h00000000; 

                Ins_Mem_Block[30]  <= 32'h00000000;
                Ins_Mem_Block[31]  <= 32'h00000000;
                Ins_Mem_Block[32]  <= 32'h00000000;
                Ins_Mem_Block[33]  <= 32'h00000000;
                Ins_Mem_Block[34]  <= 32'h00000000;
                Ins_Mem_Block[35]  <= 32'h00000000;
                Ins_Mem_Block[36]  <= 32'h00000000;
                Ins_Mem_Block[37]  <= 32'h00000000;
                Ins_Mem_Block[38]  <= 32'h00000000;
                Ins_Mem_Block[39]  <= 32'h00000000;

                Ins_Mem_Block[40]  <= 32'h00000000;
                Ins_Mem_Block[41]  <= 32'h00000000;
                Ins_Mem_Block[42]  <= 32'h00000000;
                Ins_Mem_Block[43]  <= 32'h00000000;
                Ins_Mem_Block[44]  <= 32'h00000000;
                Ins_Mem_Block[45]  <= 32'h00000000;
                Ins_Mem_Block[46]  <= 32'h00000000;
                Ins_Mem_Block[47]  <= 32'h00000000;
                Ins_Mem_Block[48]  <= 32'h00000000;
                Ins_Mem_Block[49]  <= 32'h00000000;

                Ins_Mem_Block[50]  <= 32'h00000000;
                Ins_Mem_Block[51]  <= 32'h00000000;
                Ins_Mem_Block[52]  <= 32'h00000000;
                Ins_Mem_Block[53]  <= 32'h00000000;
                Ins_Mem_Block[54]  <= 32'h00000000;
                Ins_Mem_Block[55]  <= 32'h00000000;
                Ins_Mem_Block[56]  <= 32'h00000000;
                Ins_Mem_Block[57]  <= 32'h00000000;
                Ins_Mem_Block[58]  <= 32'h00000000;
                Ins_Mem_Block[59]  <= 32'h00000000;

                Ins_Mem_Block[60]  <= 32'h00000000;
                Ins_Mem_Block[61]  <= 32'h00000000;
                Ins_Mem_Block[62]  <= 32'h00000000;
                Ins_Mem_Block[63]  <= 32'h00000000; 
            end

    assign RD = Ins_Mem_Block[A[31:2]]; // Alineado a Bytes, ignora direcciones que van a bytes intermedio, entra a la palabra

endmodule
