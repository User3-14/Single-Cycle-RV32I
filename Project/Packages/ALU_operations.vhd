-- ALU operations package

library ieee;
use ieee.std_logic_1164.all;

package ALU_operations is

	-- Available ALU operations
	type alu_operation is (
			ALU_AND, ALU_OR, ALU_XOR,
			ALU_ADD, ALU_SUB,
			ALU_SRL, ALU_SLL, ALU_SRA,
			ALU_BLT, ALU_BGE, ALU_BLTU, ALU_BGEU,
			ALU_NOP, ALU_RESET, ALU_INVALID
		);
		
	function to_std_logic(input : in boolean) return std_logic;
	
end package;

package body ALU_operations is

	function to_std_logic(input : in boolean) return std_logic is
	begin
		if input then
			return '1';
		else
			return '0';
		end if;
	end function to_std_logic;
	
end package body;