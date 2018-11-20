//This file defines the parameters used in the alu
package definitions;
    
typedef enum logic[1:0] {
//Our operations
  OR = 2'b00,
  AND = 2'b01,
  ADD = 2'b10,
  SUB = 2'b11
} op_code;

typedef enum logic {
  ENABLE  = 1'b1,
  DISABLE = 1'b0
} Signal;

parameter RegAddrWidth = 5;

typedef logic[RegAddrWidth-1:0]  RegAddr;
typedef logic[31:0] Register;

typedef logic[7:0]  ProgramCounter;
typedef logic[31:0] Instruction;
typedef logic[5:0]  OpCode;
typedef logic[4:0]  ShAmt;
typedef logic[15:0] Immediate;
typedef logic[25:0] JumpAddr;

// decompose an Instruction into R-Type components
typedef struct packed {
  OpCode   opcode;
  RegAddr rs;
  RegAddr rt;
  RegAddr rd;
  ShAmt    shamt;
  OpCode   funct;
} RType;

// decompose an Instruction into I-Type components
typedef struct packed {
  OpCode    opcode;
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
