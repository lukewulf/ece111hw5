//This file defines the parameters used in the alu
package definitions;
    
// typedef enum logic[1:0] {
// //Our operations
//   OR = 2'b00,
//   AND = 2'b01,
//   ADD = 2'b10,
//   SUB = 2'b11
// } op_code;

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
  SW    = 6'h2b
} OpCode;

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
	 
endpackage // defintions
