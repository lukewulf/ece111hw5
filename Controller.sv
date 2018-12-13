// Create Date:    2018.05.10
// Latest rev:     2018.05.10
// Created by:     Luke Wulf and Jasmine Simmons
// Design Name:    CSE141L
// Module Name:    controller.sv
/*Function: 	Decodes the opCode from the first 4 bits of the instruction and sends the necessary control signals
		to the rest of the processor
*/
import definitions::*;

module Controller(
	input [5:0] opCode,		//opCode to decode
	output DX_ctrl signals
);

alu_control_signals ALUop;		//ALU operation to send to ALU
Signal aluSrc;
Signal reg_dst;		//Control to Choose which reg to write to

Signal reg_write;		//Register File Write Control
Signal read_mem;		//Data Memory Read Control
Signal write_mem;		//Data Memory Write Control
Signal memToReg;		//Control to choose between memory and ALU output
Signal jmp;		//Control to Jump
Signal branch;

// FPU Signals
Signal fpu_write; 		// FP Reg File write control ADD.S and LWC1
Signal fpu_to_mem;		// Store fpu register to memory SWC1
Signal fpu_start;

WB_ctrl wb_ctrl;
assign wb_ctrl.reg_write  = reg_write;
assign wb_ctrl.mem_to_reg = memToReg;
assign wb_ctrl.fpu_write  = fpu_write;

M_ctrl m_ctrl;
assign m_ctrl.read_mem = read_mem;
assign m_ctrl.write_mem = write_mem;
assign m_ctrl.branch = branch;
assign m_ctrl.jmp = jmp;
assign m_ctrl.fpu_to_mem = fpu_to_mem;

MW_ctrl mw_ctrl;
assign mw_ctrl.wb = wb_ctrl;

X_ctrl x_ctrl;
assign x_ctrl.alu_op = ALUop;
assign x_ctrl.alu_src = aluSrc;
assign x_ctrl.reg_dst = reg_dst;

XM_ctrl xm_ctrl;
assign xm_ctrl.mw = mw_ctrl;
assign xm_ctrl.m  = m_ctrl;

FPU_ctrl fpu_ctrl;
assign fpu_ctrl.start = fpu_start;

DX_ctrl dx_ctrl;
assign dx_ctrl.xm = xm_ctrl;
assign dx_ctrl.x = x_ctrl;
assign dx_ctrl.fpu = fpu_ctrl;

assign signals = dx_ctrl;

always_comb								  // no registers, no clocks
  begin
 	 case (opCode)   			   // case statement for opCode

		// ADD, SUB, AND, OR, XOR
		6'b00_0000: begin		// R Type
				ALUop = ALU_RTYPE;			
				aluSrc = DISABLE;
				reg_write = ENABLE;		// writing to a register
				read_mem = DISABLE;		// reading from mem
				write_mem = DISABLE;
				memToReg = DISABLE;		// porting mem data to register
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = ENABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;
			end
		// ADDI
		6'b00_1000: begin	
				ALUop = ALU_ADD;			
				aluSrc = ENABLE;
				reg_write = ENABLE;		
				read_mem = DISABLE;		
				write_mem = DISABLE;
				memToReg = DISABLE;		
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;	
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;	
			end
		// BEQ
		6'b00_0100: begin	
				ALUop = ALU_SUB;				
				aluSrc = DISABLE;
				reg_write = DISABLE;		
				read_mem = DISABLE;		
				write_mem = DISABLE;
				memToReg = DISABLE;		
				jmp = DISABLE;
				branch = ENABLE;
				reg_dst = ENABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;
			end
		// LW
		6'b10_0011: begin					
				ALUop = ALU_ADD;		
				aluSrc = ENABLE;
				reg_write = ENABLE;		
				read_mem = ENABLE;		
				write_mem = DISABLE;
				memToReg = ENABLE;		
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;

			end
		// SW
		6'b10_1011: begin					
				ALUop = ALU_ADD;		
				aluSrc = ENABLE;
				reg_write = DISABLE;		
				read_mem = DISABLE;		
				write_mem = ENABLE;
				memToReg = DISABLE;		
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;

			end

		// J
		6'b00_0010: begin
				ALUop = ALU_ADD;
				aluSrc = DISABLE;
				reg_write = DISABLE;
				read_mem = DISABLE;
				write_mem = DISABLE;
				memToReg = DISABLE;
				jmp = ENABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;
		end
		// ADD.S
		6'b01_0001: begin
				ALUop = ALU_ADD;
				aluSrc = DISABLE;
				reg_write = DISABLE;
				read_mem = DISABLE;
				write_mem = DISABLE;
				memToReg = DISABLE;
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = ENABLE;
				fpu_write = ENABLE;
				fpu_to_mem = DISABLE;
				fpu_start = ENABLE;
		end
		// LWC1
		6'b11_0001: begin
				ALUop = ALU_ADD;
				aluSrc = ENABLE;
				reg_write = DISABLE;
				read_mem = ENABLE;
				write_mem = DISABLE;
				memToReg = ENABLE;
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = ENABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;
		end
		// SWC1
		6'b11_1001: begin
				ALUop = ALU_ADD;
				aluSrc = ENABLE;
				reg_write = DISABLE;
				read_mem = DISABLE;
				write_mem = ENABLE;
				memToReg = DISABLE;
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = DISABLE;
				fpu_to_mem = ENABLE;
				fpu_start = DISABLE;
		end
		
		default: begin
				ALUop = ALU_ADD;
				aluSrc = DISABLE;
				reg_write = DISABLE;
				read_mem = DISABLE;
				write_mem = DISABLE;
				memToReg = DISABLE;
				jmp = DISABLE;
				branch = DISABLE;
				reg_dst = DISABLE;
				fpu_write = DISABLE;
				fpu_to_mem = DISABLE;
				fpu_start = DISABLE;
			end
   	 endcase

  end

endmodule 