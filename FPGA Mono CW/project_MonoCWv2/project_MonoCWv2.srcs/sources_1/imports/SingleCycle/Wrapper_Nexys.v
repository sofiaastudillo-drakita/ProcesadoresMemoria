`include "TopSC.v"

module count_inst (input clk,
            input reset,
            input program_executing,
            input [31:0] InstrE, PCPlus_4E,
            output [31:0] count_instructions_ex);

    reg [31:0] count;      // contador de instrucciones
    reg [31:0] prev_PC;    // PCPlus_4E del ciclo anterior

    always @(posedge clk) begin
        if (reset) begin
            count   <= 32'd0;
            prev_PC <= 32'hFFFFFFFF;   // valor distinto al primer PC
        end else begin
            // Guardar el PC actual para la comparaciï¿½n del prï¿½ximo ciclo
            prev_PC <= PCPlus_4E;

            // Condiciï¿½n de conteo
            if (program_executing && (InstrE != 32'b0) && (PCPlus_4E != prev_PC)) begin
                count <= count + 1'b1;
            end
        end
    end

    assign count_instructions_ex = count;

endmodule


module count_ciclos (input clk, reset, program_executing,
            output [31:0] count_cycles_ex);

    reg [31:0] count_out;
    always@(posedge clk)
        if (reset)
            count_out <= 31'b0;
            
        else if (program_executing)
            count_out <= count_out + 32'd1;

    assign count_cycles_ex = count_out;
endmodule

module select_count (input wire swt_count,
                    input wire [31:0] counter_instr_ej, counter_ciclos_ej,
                    output wire [31:0] counter_select);

    assign counter_select = swt_count ? counter_instr_ej : counter_ciclos_ej;

endmodule

module program_detector (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] InstrE,
    output wire        program_executing
);

    reg        program_started;
    reg        program_ended;
    reg  [3:0] zero_count;

    wire is_nonzero = (InstrE != 32'b0);

    always @(posedge clk) begin
        if (reset) begin
            program_started <= 1'b0;
            program_ended   <= 1'b0;
            zero_count      <= 4'd0;
        end
        else if (is_nonzero) begin
            // Cualquier instrucción no nula => programa activo
            program_started <= 1'b1;
            zero_count      <= 4'd0;
        end
        else if (program_started && !program_ended) begin
            // Instrucción nula: cuenta ceros consecutivos
            if (zero_count < 4'd10)
                zero_count <= zero_count + 4'd1;

            // Al 10º cero consecutivo se marca fin de programa
            if (zero_count == 4'd9)
                program_ended <= 1'b1;
        end
    end

    // Salida combinacional: se activa EL MISMO ciclo en que llega la 1ª instr.
    assign program_executing = (program_started || is_nonzero) && !program_ended;

endmodule

module Memory_for_FPGA(input wire 	clk,
                        input wire WE3,
		     		    input wire [6:0] RA1,//Direccion de salida 
                        input wire [6:0] WA3,//Direccion entrada (countermem)
		      		    input wire [31:0] WD3,//Entrada a guardar (InstrE)

		     		    output wire [31:0] RD1);//Instruccion a salir

    reg [31:0] 				Reg_File_Block[63:0];

    //wire WE3;
    //assign WE3 = (WA3 < 64);
    

    initial begin
        Reg_File_Block[0]  = 31'h00000000;
        Reg_File_Block[1]  = 31'h00000000; 
        Reg_File_Block[2]  = 31'h00000000;
        Reg_File_Block[3]  = 31'h00000000;
        Reg_File_Block[4]  = 31'h00000000;
        Reg_File_Block[5]  = 31'h00000000;
        Reg_File_Block[6]  = 31'h00000000;
        Reg_File_Block[7]  = 31'h00000000;

        Reg_File_Block[8]  = 31'h00000000;
        Reg_File_Block[9]  = 31'h00000000;
        Reg_File_Block[10]  = 31'h00000000;
        Reg_File_Block[11]  = 31'h00000000;
        Reg_File_Block[12]  = 31'h00000000;
        Reg_File_Block[13]  = 31'h00000000;
        Reg_File_Block[14]  = 31'h00000000;
        Reg_File_Block[15]  = 31'h00000000;

        Reg_File_Block[16]  = 31'h00000000;
        Reg_File_Block[17]  = 31'h00000000;
        Reg_File_Block[18]  = 31'h00000000;
        Reg_File_Block[19]  = 31'h00000000;
        Reg_File_Block[20]  = 31'h00000000;
        Reg_File_Block[21]  = 31'h00000000;
        Reg_File_Block[22]  = 31'h00000000;
        Reg_File_Block[23]  = 31'h00000000;

        Reg_File_Block[24]  = 31'h00000000;
        Reg_File_Block[25]  = 31'h00000000;
        Reg_File_Block[26]  = 31'h00000000;
        Reg_File_Block[27]  = 31'h00000000;
        Reg_File_Block[28]  = 31'h00000000;
        Reg_File_Block[29]  = 31'h00000000;
        Reg_File_Block[30]  = 31'h00000000;
        Reg_File_Block[31]  = 31'h00000000;
        Reg_File_Block[32]  = 31'h00000000;
        Reg_File_Block[33]  = 31'h00000000; 
        Reg_File_Block[34]  = 31'h00000000;
        Reg_File_Block[35]  = 31'h00000000;
        Reg_File_Block[31]  = 31'h00000000;
        Reg_File_Block[37]  = 31'h00000000;
        Reg_File_Block[38]  = 31'h00000000;
        Reg_File_Block[39]  = 31'h00000000;

        Reg_File_Block[40]  = 31'h00000000;
        Reg_File_Block[41]  = 31'h00000000;
        Reg_File_Block[42]  = 31'h00000000;
        Reg_File_Block[43]  = 31'h00000000;
        Reg_File_Block[44]  = 31'h00000000;
        Reg_File_Block[45]  = 31'h00000000;
        Reg_File_Block[46]  = 31'h00000000;
        Reg_File_Block[47]  = 31'h00000000;

        Reg_File_Block[48]  = 31'h00000000;
        Reg_File_Block[49]  = 31'h00000000;
        Reg_File_Block[50]  = 31'h00000000;
        Reg_File_Block[51]  = 31'h00000000;
        Reg_File_Block[52]  = 31'h00000000;
        Reg_File_Block[53]  = 31'h00000000;
        Reg_File_Block[54]  = 31'h00000000;
        Reg_File_Block[55]  = 31'h00000000;

        Reg_File_Block[56]  = 31'h00000000;
        Reg_File_Block[57]  = 31'h00000000;
        Reg_File_Block[58]  = 31'h00000000;
        Reg_File_Block[59]  = 31'h00000000;
        Reg_File_Block[60]  = 31'h00000000;
        Reg_File_Block[61]  = 31'h00000000;
        Reg_File_Block[62]  = 31'h00000000;
        Reg_File_Block[63]  = 31'h00000000;
        Reg_File_Block[64]  = 31'h00000000;
        Reg_File_Block[65]  = 31'h00000000;
        Reg_File_Block[66]  = 31'h00000000;
        Reg_File_Block[67]  = 31'h00000000;

        Reg_File_Block[68]  = 31'h00000000;
        Reg_File_Block[69]  = 31'h00000000;
        Reg_File_Block[70]  = 31'h00000000;
        Reg_File_Block[71]  = 31'h00000000;
        Reg_File_Block[72]  = 31'h00000000;
        Reg_File_Block[73]  = 31'h00000000;
        Reg_File_Block[74]  = 31'h00000000;
        Reg_File_Block[75]  = 31'h00000000;

        Reg_File_Block[76]  = 31'h00000000;
        Reg_File_Block[77]  = 31'h00000000;
        Reg_File_Block[78]  = 31'h00000000;
        Reg_File_Block[79]  = 31'h00000000;
        Reg_File_Block[80]  = 31'h00000000;
        Reg_File_Block[81]  = 31'h00000000;
        Reg_File_Block[82]  = 31'h00000000;
        Reg_File_Block[83]  = 31'h00000000;

        Reg_File_Block[84]  = 31'h00000000;
        Reg_File_Block[85]  = 31'h00000000;
        Reg_File_Block[86]  = 31'h00000000;
        Reg_File_Block[87]  = 31'h00000000;
        Reg_File_Block[88]  = 31'h00000000;
        Reg_File_Block[89]  = 31'h00000000;
        Reg_File_Block[90]  = 31'h00000000;
        Reg_File_Block[91]  = 31'h00000000;
        Reg_File_Block[92]  = 31'h00000000;
        Reg_File_Block[93]  = 31'h00000000; 
        Reg_File_Block[94]  = 31'h00000000;
        Reg_File_Block[95]  = 31'h00000000;
        Reg_File_Block[96]  = 31'h00000000;
        Reg_File_Block[97]  = 31'h00000000;
        Reg_File_Block[98]  = 31'h00000000;
        Reg_File_Block[99]  = 31'h00000000;

        Reg_File_Block[100]  = 31'h00000000;
        Reg_File_Block[101]  = 31'h00000000;
        Reg_File_Block[102]  = 31'h00000000;
        Reg_File_Block[103]  = 31'h00000000;
        Reg_File_Block[104]  = 31'h00000000;
        Reg_File_Block[105]  = 31'h00000000;
        Reg_File_Block[106]  = 31'h00000000;
        Reg_File_Block[107]  = 31'h00000000;

        Reg_File_Block[108]  = 31'h00000000;
        Reg_File_Block[109]  = 31'h00000000;
        Reg_File_Block[100]  = 31'h00000000;
        Reg_File_Block[111]  = 31'h00000000;
        Reg_File_Block[112]  = 31'h00000000;
        Reg_File_Block[113]  = 31'h00000000;
        Reg_File_Block[114]  = 31'h00000000;
        Reg_File_Block[115]  = 31'h00000000;

        Reg_File_Block[116]  = 31'h00000000;
        Reg_File_Block[117]  = 31'h00000000;
        Reg_File_Block[118]  = 31'h00000000;
        Reg_File_Block[119]  = 31'h00000000;
        Reg_File_Block[120]  = 31'h00000000;
        Reg_File_Block[121]  = 31'h00000000;
        Reg_File_Block[122]  = 31'h00000000;
        Reg_File_Block[123]  = 31'h00000000;
        Reg_File_Block[124]  = 31'h00000000;
        Reg_File_Block[125]  = 31'h00000000;
        Reg_File_Block[126]  = 31'h00000000;
        Reg_File_Block[127]  = 31'h00000000;

        end

    always@(posedge clk)
        begin
	        if(WE3)
	            Reg_File_Block[WA3] <= WD3;
        end

    assign RD1 = (RA1 != 0) ? Reg_File_Block[RA1] : 0;

endmodule






module button_debounce_counter (
    input wire clk,
    input wire reset,
    input wire button,
    output wire [6:0] countty
);

    localparam CYCLES = 1600000;   // 20 ms para 80 MHz (aj?stalo)

    reg button_sync1, button_sync2;
    reg button_stable;
    reg [21:0] debounce_cnt;
    reg button_prev;
    reg [6:0] count;

    always @(posedge clk) begin
        if (reset) begin
            button_sync1 <= 0;
            button_sync2 <= 0;
        end else begin
            button_sync1 <= button;
            button_sync2 <= button_sync1;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            debounce_cnt <= 0;
            button_stable <= 0;
        end else begin
            if (button_sync2 != button_stable)
                debounce_cnt <= 0;
            else if (debounce_cnt < CYCLES)
                debounce_cnt <= debounce_cnt + 1;

            if (debounce_cnt == CYCLES)
                button_stable <= button_sync2;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            button_prev <= 0;
            count <= 0;
        end else begin
            button_prev <= button_stable;
            if (button_stable && !button_prev)
                count <= count + 1;
        end
    end

    assign countty = count;
endmodule



module Seven_seg_dec_n_mux (
    input wire clk,
    input wire [31:0] input32b,
    output wire [6:0] segments,
    output wire [7:0] anodes
);
    reg [2:0] Posicion;
    wire [3:0] Hex_a_bit;
    reg [6:0] segm;
    reg [7:0] anod;

    always @(posedge clk) begin
        if (Posicion == 3'd7)
            Posicion <= 3'd0;
        else
            Posicion <= Posicion + 1;
    end

    assign Hex_a_bit = input32b[Posicion * 4 +: 4];

    always @(*) begin
        case (Hex_a_bit)
            4'h0: segm = 7'b0000001;
            4'h1: segm = 7'b1001111;
            4'h2: segm = 7'b0010010;
            4'h3: segm = 7'b0000110;
            4'h4: segm = 7'b1001100;
            4'h5: segm = 7'b0100100;
            4'h6: segm = 7'b0100000;
            4'h7: segm = 7'b0001111;
            4'h8: segm = 7'b0000000;
            4'h9: segm = 7'b0000100;
            4'hA: segm = 7'b0001000;
            4'hB: segm = 7'b1100000;
            4'hC: segm = 7'b0110001;
            4'hD: segm = 7'b1000010;
            4'hE: segm = 7'b0110000;
            4'hF: segm = 7'b0111000;
            default: segm = 7'b1111111;
        endcase
    end

    assign segments = segm;

    always @(*) begin
        anod = 8'b11111111;
        anod[Posicion] = 1'b0;
    end

    assign anodes = anod;
endmodule


module Clock_divider_1000Hz (
    input wire clk,
    input wire reset,
    output wire clk_out
);
    reg [18:0] counter = 0;
    reg clk_int = 0;
    // Para 80 MHz -> 1 kHz: medio per?odo = 40000 ciclos
    localparam LIMIT = 39999;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            clk_int <= 0;
        end else if (counter == LIMIT) begin
            counter <= 0;
            clk_int <= ~clk_int;
        end else begin
            counter <= counter + 1;
        end
    end

    assign clk_out = clk_int;
endmodule




module counter_butt_mem (
    input wire clk,
    input wire reset,
    input wire button,
    output wire [6:0] countty_for_mem);
    
    wire [6:0] countty;

    button_debounce_counter butt_deb (
        .clk(clk),
        .reset(reset),
        .button(button),
        .countty(countty));
    
    assign countty_for_mem = countty;
    
endmodule


module counter_program_cycles_instr (input wire clk, reset, swt_count, swt_mode, button,
                                    input wire [31:0] InstrE, PCPlus_4E,
                                    output wire [31:0] counter_select_x2);

    wire programmy_on;
    wire [31:0] countty_instructions;
    wire [31:0] countty_cycles;
    wire [6:0] button_est;
    wire [31:0] counter_select;
    wire [31:0] InstrE_from_mem;

    program_detector detecty (.clk(clk), .reset(reset), .InstrE(InstrE), .program_executing(programmy_on));

    count_inst countty_inst (.clk(clk), .reset(reset), .program_executing(programmy_on), .InstrE(InstrE), .PCPlus_4E(PCPlus_4E), .count_instructions_ex(countty_instructions));

    count_ciclos countty_cyc (.clk(clk), .reset(reset), .program_executing(programmy_on), .count_cycles_ex(countty_cycles));

    select_count select_countty (.swt_count(swt_count), .counter_instr_ej(countty_instructions), .counter_ciclos_ej(countty_cycles), .counter_select(counter_select));

    select_count select_moddy (.swt_count(swt_mode), .counter_instr_ej(counter_select), .counter_ciclos_ej(InstrE_from_mem), .counter_select(counter_select_x2));

    Memory_for_FPGA Memmy(.clk(clk),.WE3(programmy_on),.RA1(button_est),.WA3(countty_cycles[6:0]), .WD3(InstrE), .RD1(InstrE_from_mem));

    counter_butt_mem count_for_mem (.clk(clk), .reset(reset), .button(button), .countty_for_mem(button_est));

endmodule
