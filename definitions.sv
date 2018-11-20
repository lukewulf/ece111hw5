//This file defines the parameters used in the alu
package definitions;
    
typedef enum logic[1:0] {

//Our operations
  OR = 2'b00,
  AND = 2'b01,
  ADD = 2'b10,
  SUB = 2'b11
	 } op_code;
	 
endpackage // defintions
