// Create Date:    2017.05.05
// Latest rev:     2017.10.26s
// Created by:     J Eldon
// Design Name:    CSE141L
// Module Name:    Reg File

// register file with asynchronous read and synchronous write
// parameter raw = "RF address width" -- default is 4 bits,
//   for 16 words in the RF
// generic version has two separate read addresses and an
//  independent write address
// these may be strapped together or decoded in any way,
//  to save instruction or decoder bits
// reads are always enabled, hence no read enable control
module reg_file #(parameter raw = 5)
    (	input clk,
	input [raw-1:0] rs_addr_i,
        input [raw-1:0] rt_addr_i,
	input [raw-1:0] rd_addr_i,
   	input  wen_i,	  			  // write enable
  	input [31:0] write_data_i,	  // data to be written/loaded 
	output logic [31:0] rs_val_o,	  // data read out of reg file
  	output logic [31:0] rt_val_o
     );

logic [31:0] RF [2**raw];				  // core itself
initial 
begin
	$readmemb("Zeroes.bin", RF);
end
// two simultaneous, continuous, combinational reads supported

assign rs_val_o = RF [rs_addr_i];
assign rt_val_o = RF [rt_addr_i];

// synchronous (clocked) write to selected RF content "bin"
always_ff @ (posedge clk)
	begin
	RF[rd_addr_i] = (wen_i) ? RF[rd_addr_i] : write_data_i;
	end
endmodule

