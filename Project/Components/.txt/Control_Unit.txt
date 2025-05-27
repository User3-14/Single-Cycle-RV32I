-- ALU Control Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ALU_operations.all;

entity Control_Unit is
	port (
			opcode		: in std_logic_vector(6 downto 0);
			func3			: in std_logic_vector(2 downto 0);
			func7			: in std_logic_vector(6 downto 0);
			ALU_op		: out ALU_operation;
			ALU_src		: out std_logic;
			reg_write	: out std_logic;
			mem_write	: out std_logic;
			mem_to_reg	: out std_logic;
			branch		: out std_logic;
			offset		: out std_logic_vector(1 downto 0)
		);
end entity;

architecture behavioral of Control_Unit is
begin
	process(opcode, func3, func7)
	begin
		if (opcode="0000000") then				-- nop
			ALU_op <= ALU_NOP;
			ALU_src <= '0';
			reg_write <= '0';
			mem_write <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			offset <= "00";
			
		elsif (opcode="0000011") then			-- I-format (Load)
			ALU_op <= ALU_ADD;
			ALU_src <= '1';
			reg_write <= '1';
			mem_write <= '0';
			mem_to_reg <= '1';
			branch <= '0';
			if (func3="000") then				-- lb
				offset <= "10";
			elsif (func3="001") then			-- lh
				offset <= "01";
			elsif (func3="010") then			-- lw
				offset <= "00";
			elsif (func3="100") then			-- lbu
				offset <= "11";
			else
				ALU_op <= ALU_INVALID;
			end if;
		elsif (opcode="0010011") then			-- I-format (Arithmetic)
			ALU_src <= '1';
			reg_write <= '1';
			mem_write <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then				-- addi
				ALU_op <= ALU_ADD;
			elsif (func3="001") then			-- slli
				ALU_op <= ALU_SLL;
			else
				ALU_op <= ALU_INVALID;
			end if;
		elsif (opcode="0100011") then			-- S-format (Store)
			ALU_op <= ALU_ADD;
			ALU_src <= '1';
			reg_write <= '0';
			mem_write <= '1';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then				-- sb
				offset <= "10";
			elsif (func3="001") then			-- sh
				offset <= "01";
			elsif (func3="010") then			-- sw
				offset <= "00";
			else
				ALU_op <= ALU_INVALID;
			end if;
		elsif (opcode="0110011") then			-- R-format (Arithmetic/Logic)
			ALU_src <= '0';
			reg_write <= '1';
			mem_write <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then
				if (func7="0000000") then		-- add
					ALU_op <= ALU_ADD;
				elsif (func7="0000001") then	-- sub
					ALU_op <= ALU_SUB;
				else
					ALU_op <= ALU_INVALID;
				end if;
			elsif (func3="001") then			-- sll
				ALU_op <= ALU_SLL;
			elsif (func3="100") then			-- xor
				ALU_op <= ALU_XOR;
			elsif (func3="101") then
				if (func7="0000000") then		-- srl
					ALU_op <= ALU_SRL;
				elsif (func7="0000001") then	-- sra
					ALU_op <= ALU_SRA;
				else
					ALU_op <= ALU_INVALID;
				end if;
			elsif (func3="110") then			-- or
				ALU_op <= ALU_OR;
			elsif (func3="111") then			-- and
				ALU_op <= ALU_AND;
			else
				
			end if;
		elsif (opcode="1100011") then			-- SB-format (Branch)
			ALU_src <= '0';
			reg_write <= '0';
			mem_write <= '0';
			mem_to_reg <= '0';
			branch <= '1';
			if (func3="000") then				-- beq
				ALU_op <= ALU_SUB;
			elsif (func3="100") then			-- blt
				ALU_op <= ALU_BLT;
			elsif (func3="101") then			-- bge
				ALU_op <= ALU_BGE;
			elsif (func3="110") then			-- bltu
				ALU_op <= ALU_BLTU;
			elsif (func3="111") then			-- bgeu
				ALU_op <= ALU_BGEU;
			else
				ALU_op <= ALU_INVALID;
			end if;
		else
			ALU_op <= ALU_INVALID;
			ALU_src <= 'X';
			reg_write <= 'X';
			mem_write <= 'X';
			mem_to_reg <= 'X';
			branch <= 'X';
			offset <= "XX";
		end if;
	end process;
end architecture;