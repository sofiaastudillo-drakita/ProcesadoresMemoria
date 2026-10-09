module extend(input wire [31:7] instr,
               input wire [1:0] immsrc,
               output wire [31:0] immext);

	reg [31:0] immextin;

   	always@(*)
        case(immsrc)                
         	2'b00:     immextin = {{20{instr[31]}}, instr[31:20]}; // I−type
                         
         	2'b01:     immextin = {{20{instr[31]}}, instr[31:25],  // S−type (stores)
                              instr[11:7]};
                         
         	2'b10:      immextin = {{20{instr[31]}}, instr[7],  // B−type (branches)
                              instr[30:25], instr[11:8], 1'b0};                                        
                         
         	2'b11:      immextin = {{12{instr[31]}}, instr[19:12],  // J−type (jal)
                              instr[20], instr[30:21], 1'b0};

         	default: immextin = 32'bx; // undefined
      	endcase

	assign immext = immextin;

endmodule