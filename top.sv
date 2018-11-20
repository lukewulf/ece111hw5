// Create Date:     2017.11.05
// Latest rev date: 2017.11.06
// Created by:      J Eldon
// Design Name:     CSE141L
// Module Name:     top (top of sample microprocessor design) 
import definitions::*;

module top(
  input clk,  
        reset,
	init,
  output logic done
);
  parameter IW = 8;				// program counter / instruction pointer
  

  logic Halt;
  wire[IW-1:0] PC;                    // pointer to insr. mem
  wire[   8:0] InstOut;				// 9-bit machine code from instr ROM
  wire[   7:0] rt_val_o,			// reg_file data outputs to ALU
               rs_val_o,			// 
               result_o;			// ALU data output

  assign carry_clr = reset;


  logic      rf_sel;			   // conrol
  logic[7:0] reg_data_in;            // data bus

// Controller wires
  op_code ALUop;
  wire reg_write;
  wire set;
  wire bne;
  wire read_mem;
  wire write_mem;
  wire memToReg;
  wire bypass;
  wire slp;

// Register File Wires
 logic[1:0] rs_sel;		// output of 2:1 mux before rs_addr_i

// ALU Wires
 wire zero;
 wire parity;

// Bypass Wires
 logic[7:0] rs_slp;
 logic[7:0] slp_o;
 logic[7:0] bypass_o;

// Memory Wires
 wire [7:0] mem_data;

// WB wires
 wire[7:0] data_wb;

// IF wires
logic branch;// = 1'b0, // branch to "offset"


IF IF1(
  .branch (branch)  ,   // branch to "offset"
  .branch_adr   (rs_val_o )	 ,
  .Reset    (reset )	 ,
  .Halt     (init )	 ,
  .CLK      (clk     )	 ,
  .PC       (PC      )      // pointer to insr. mem
  );				 


InstROM #(.IW(8)) InstROM(
  .InstAddress (PC),	// address pointer
  .InstOut (InstOut));

Controller Controller1(
	.msb (InstOut[8]),			//MSB of instruction
	.opCode (InstOut[7:5]),		//opCode to decode
	.ALUop(ALUop),		//ALU operation to send to ALU
	.reg_write(reg_write),		//Register File Write Control
	.set(set),		//SET operation control for MUX's
	.bne(bne),		//BNE operation is called
	.read_mem(read_mem),		//Data Memory Read Control
	.write_mem(write_mem),		//Data Memory Write Control
	.memToReg(memToReg),		//Control to choose between memory and ALU output
	.bypass(bypass),		//Control to Bypass ALU 
	.slp(slp)		//Control to choose SLP over the bypass line
);

assign rs_sel = set ? 2'b00 : InstOut[4:3];
assign reg_data_in = set ? InstOut[7:0] : data_wb;	

reg_file #(.raw(2)) rf1	 (
  .clk		     (clk		    ),   // clock (for writes only)
  .rs_addr_i	 (rs_sel ),   // read pointer rs
  .rt_addr_i	 (InstOut[2:1]  ),   // read pointer rt
  .wen_i		 (reg_write	    ),   // write enable
  .level 	 (InstOut[0]),
  .write_data_i	 (reg_data_in   ),   // data to be written/loaded 
  .rs_val_o	     (rs_val_o	    ),   // data read out of reg file
  .rt_val_o		 (rt_val_o	    )
                );

alu alu1(.rs_i     (rs_val_o)     ,	
         .rt_i	   (rt_val_o)	  ,	
         .op_i   (ALUop)	  ,	
// outputs
         .result_o (result_o) ,
		 .zero    (zero   ) ,
		 .parity (parity ));

reg zero_reg;
reg parity_reg;
always @ (posedge clk)
begin
	zero_reg <= zero;
	parity_reg <= parity;
end

assign rs_slp = {rs_val_o[6:0], parity_reg};
assign slp_o = slp ? rs_slp : rs_val_o;
assign bypass_o = bypass ? slp_o : result_o; 	//Output of the Execute stage
assign branch = bne & ~zero_reg;

//Checked
data_mem data_mem(
   .CLK           (clk        ),        
   .DataAddress   (rt_val_o),	//All stores and loads choose from the second address
   .ReadMem       (read_mem     ), // read_mem from Controller 		
   .WriteMem      (write_mem ), // write_mem from Controller		
   .DataIn        (rs_val_o  ), // All data in is always the output of the reg file	
   .DataOut       (mem_data   )  // load  (to RF)
);

assign data_wb = memToReg ? mem_data : bypass_o;
assign done = (PC == 79) || (PC == 222);

endmodule