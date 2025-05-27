-- Decoder component

library ieee;
use ieee.std_logic_1164.all;

entity CU_decode is
	port (
			instr		: in std_logic_vector(31 downto 0);
			rs1		: out std_logic_vector(4 downto 0);
			rs2		: out std_logic_vector(4 downto 0);
			rd			: out std_logic_vector(4 downto 0);
			imm		: out std_logic_vector(11 downto 0);
			ALU_op	: out std_logic_vector(3 downto 0);
			ALU_src	: out std_logic;
			reg_write	: out std_logic;
			mem_write	: out std_logic;
--			mem_read 	: out std_logic;
			mem_to_reg	: out std_logic;
			branch		: out std_logic
		);
end entity;

architecture behavioral of CU_decode is

	signal opcode	: std_logic_vector(6 downto 0);
	signal func3	: std_logic_vector(2 downto 0);
	signal func7	: std_logic_vector(6 downto 0);
	
begin

	opcode <= instr(6 downto 0);
	
	control: process(opcode, func3)
	begin
		if (opcode="0000000") then	-- reset
			ALU_op <= "1111";
			ALU_src <= '0';
			reg_write <= '0';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
		elsif (opcode="0010011") then	-- nop
			ALU_op <= "0011";
			ALU_src <= '1';
			reg_write <= '0';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
		elsif (opcode="0000011") then
			ALU_src <= '1';
			reg_write <= '1';
			mem_write <= '0';
--			mem_read <= '1';
			mem_to_reg <= '1';
			branch <= '0';
			if (func3="000") then		-- lb
				ALU_op <= "0011";
			elsif (func3="001") then	-- lh
				ALU_op <= "0011";
			elsif (func3="010") then	-- lw
				ALU_op <= "0011";
			elsif (func3="100") then	-- lbu
				ALU_op <= "0011";
			else
				ALU_op <= "XXXX";
			end if;
		elsif (opcode="0010011") then
			ALU_src <= '1';
			reg_write <= '1';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then		-- addi
				ALU_op <= "0011";
			elsif (func3="001") then	-- slli
				ALU_op <= "0101";
			else
				ALU_op <= "XXXX";
			end if;
		elsif (opcode="0100011") then
			ALU_src <= '1';
			reg_write <= '0';
			mem_write <= '1';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then		-- sb
				ALU_op <= "0011";
			elsif (func3="001") then	-- sh
				ALU_op <= "0011";
			elsif (func3="010") then	-- sw
				ALU_op <= "0011";
			else
				ALU_op <= "XXXX";
			end if;
		elsif (opcode="0110011") then
			ALU_src <= '0';
			reg_write <= '1';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
			if (func3="000") then
				if (func7="0000000") then		-- add
					ALU_op <= "0011";
				elsif (func7="0000001") then	-- sub
					ALU_op <= "0100";
				else
					ALU_op <= "XXXX";
				end if;
			elsif (func3="001") then	-- sll
				ALU_op <= "0101";
			elsif (func3="100") then	-- xor
				ALU_op <= "0010";
			elsif (func3="101") then
				if (func7="0000000") then		-- srl
					ALU_op <= "0110";
				elsif (func7="0000001") then	-- sra
					ALU_op <= "0111";
				else
					ALU_op <= "XXXX";
				end if;
			elsif (func3="110") then	-- or
				ALU_op <= "0001";
			elsif (func3="111") then	-- and
				ALU_op <= "0000";
			else
				
			end if;
		elsif (opcode="1100011") then
			ALU_src <= '0';
			reg_write <= '0';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '1';
			if (func3="000") then		-- beq
				ALU_op <= "0100";
			elsif (func3="100") then	-- blt
				ALU_op <= "1000";
			elsif (func3="101") then	-- bge
				ALU_op <= "1001";
			elsif (func3="110") then	-- bltu
				ALU_op <= "1010";
			elsif (func3="111") then	-- bgeu
				ALU_op <= "1011";
			else
				ALU_op <= "XXXX";
			end if;
--		elsif (opcode="1100111") then
--			ALU_op <= ;
--			ALU_src <= ;
--			reg_write <= ;
--			mem_write <= ;
--			mem_read <= ;
--			mem_to_reg <= ;
--			branch <= ;
--			if (func3="000") then		-- jalr
--				ALU_op <= "
--			else
--				ALU_op <= "XXXX";
--			end if;
--		elsif (opcode="1101111") then	-- jal
--			ALU_op <= ;
--			ALU_src <= ;
--			reg_write <= ;
--			mem_write <= ;
--			mem_read <= ;
--			mem_to_reg <= ;
--			branch <= ;
		else
			ALU_op <= "XXXX";
			ALU_src <= '0';
			reg_write <= '0';
			mem_write <= '0';
--			mem_read <= '0';
			mem_to_reg <= '0';
			branch <= '0';
		end if;
	end process;
end architecture;