//This file defines the parameters used in the alu
package definitions;

typedef enum logic {
  ENABLE  = 1'b1,
  DISABLE = 1'b0
} Signal;

parameter MemAddrWidth = 4;

parameter RegAddrWidth = 5;

typedef logic[RegAddrWidth-1:0]  RegAddr;
typedef logic[31:0] Register;

typedef enum logic[5:0]{
  RTYPE = 6'h00,  // ADD, SUB, AND, OR
  J     = 6'h02,
  BEQ   = 6'h04,
  ADDI  = 6'h08,
  LW    = 6'h23,
  SW    = 6'h2b,
  ADDS  = 6'h11
} OpCode;

typedef enum logic[1:0]{
  ALU_RTYPE = 2'b00,
  ALU_ADD = 2'b01,
  ALU_SUB = 2'b10,
  ALU_DC = 2'b11
} alu_control_signals;

typedef enum logic[2:0]{
  ALU_O_ADD = 3'b000,
  ALU_O_SUB = 3'b001,
  ALU_O_AND = 3'b010,
  ALU_O_OR = 3'b011,
  ALU_O_XOR = 3'b100
} alu_operation;

typedef enum logic[5:0]{
  ADD = 6'h20,
  SUB = 6'h22,
  AND = 6'h24,
  OR  = 6'h25
} Funct;

typedef logic[7:0]  ProgramCounter;
typedef logic[31:0] Instruction;
typedef logic[4:0]  ShAmt;
typedef logic[15:0] Immediate;
typedef logic[25:0] JumpAddr;

// decompose an Instruction into R-Type components
typedef struct packed {
  OpCode  opcode;
  RegAddr rs;
  RegAddr rt;
  RegAddr rd;
  ShAmt   shamt;
  Funct   funct;
} RType;

// decompose an Instruction into I-Type components
typedef struct packed {
  OpCode   opcode;
  RegAddr  rs;
  RegAddr  rt;
  Immediate imm;
} IType;

// decompose an Instruction into J-Type components
typedef struct packed {
  OpCode   opcode;
  JumpAddr addr;
} JType;

typedef struct packed{
  OpCode opcode;
  ShAmt fmt;
  RegAddr ft;
  RegAddr fs;
  RegAddr fd;
  Funct funct;
} FRType;

typedef struct packed {
  Signal reg_write;
  Signal mem_to_reg;
  Signal fpu_write;
} WB_ctrl;

typedef struct packed {
  Signal read_mem;
  Signal write_mem;
  Signal branch;
  Signal jmp;
  Signal fpu_to_mem;
  Signal fpu_to_wb;
} M_ctrl;

typedef struct packed {
  WB_ctrl wb;
} MW_ctrl;

typedef struct packed {
  alu_control_signals alu_op;
  Signal  alu_src;
  Signal  reg_dst;
} X_ctrl;

typedef struct packed {
  MW_ctrl mw;
  M_ctrl  m;
} XM_ctrl;

typedef struct packed {
  XM_ctrl xm;
  X_ctrl  x;
} DX_ctrl;

typedef struct packed {
  // Data from Instruction Decode
  ProgramCounter pc;
  ProgramCounter pc_jmp;
  RegAddr  rs_a;
  Register rs_d;
  RegAddr  rt_a;
  Register rt_d;
  RegAddr  rd_a;
  RegAddr  fs_a;
  Register fs_d;
  RegAddr  ft_a;
  Register ft_d;
  RegAddr  fd_a;
  Register imm;
} DX_data;

typedef struct packed {
  Signal         stall;
  Signal         branch;
  Signal         alu_zero;
  Signal         jmp;
  ProgramCounter pc_branch;
  ProgramCounter pc_jmp;
} IF_input;

typedef struct packed {
  ProgramCounter pc;
} IF_output;

typedef struct packed {
  Signal write;
  Signal fp_write;
} D_control;

typedef struct packed {
  Register       rd;
  RegAddr        dst;
  Instruction    instr;
  ProgramCounter pc;
} D_input;

typedef struct packed {
  Register       rs;
  RegAddr        rs_a;
  Register       rt;
  RegAddr        rt_a;
  RegAddr        rd_a;
  Register       fs;
  RegAddr        fs_a;
  Register       ft;
  RegAddr        ft_a;
  RegAddr        fd_a;
  ProgramCounter pc_jmp;
} D_output;

typedef struct packed {
  X_ctrl          ctrl;
  ProgramCounter  pc;
  Register        imm;
  Register        rs;
  Register        rt;
  RegAddr         rs_addr;
  RegAddr         rt_addr;
  RegAddr         rd_addr;
} X_input;

typedef struct packed {
  Signal          zero;
  ProgramCounter  pc_branch;
  Register        alu;
  Register        rt;
  RegAddr         rt_addr;
  RegAddr         dst_addr;
} X_output;

typedef struct packed{
  Register        fs;
  Register        ft;
  ProgramCounter  pc;
  X_ctrl          ctrl;
  RegAddr 	  fs_addr;
  RegAddr 	  ft_addr;
  RegAddr 	  fd_addr;
} FPU_input;

typedef struct packed{
  Register	  ft;		// ft value for sw1c
  Register        fpu;		// fpu output
} FPU_output;

typedef struct packed {
  Register alu_addr;
  Register fpu_addr;
  Register alu_val; 
  Register fpu_val;
  RegAddr  dst;
  Signal   alu_zero;
  ProgramCounter pc_branch;
} XM_data;

typedef struct packed {
  Signal read;
  Signal write;
  Register addr;
  Register val;
  RegAddr dst;
} M_input;

typedef struct packed {
  Register val;
} M_output;

typedef struct packed {
  Register mem;
  Register alu;
  RegAddr  dst;
} WB_input;

typedef struct packed {
  Register val;
  RegAddr  dst;
} WB_output;

typedef struct packed{
  RegAddr Drs;
  RegAddr Drt;
  RegAddr Drd;
  RegAddr Xrs;
  RegAddr Xrt;
  RegAddr Xrd;
  RegAddr Mrs;
  RegAddr Mrt;
  RegAddr Mrd;
  Signal  read_mem;
} Hazard_input;

typedef struct packed{
  Signal fwdXX_rs;
  Signal fwdXX_rt;
  Signal fwdMX_rs;
  Signal fwdMX_rt;
  Signal fwdMM_rt;
  Signal stallD;
  Signal stallIF;
} Hazard_output;
	 
endpackage // defintions
