library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ALU_operations.all;

entity ALU is
	port (
			A		: in std_logic_vector(31 downto 0);
			B		: in std_logic_vector(31 downto 0);
			Op		: in ALU_operation;
			R		: out std_logic_vector(31 downto 0)
		);
end entity;

architecture Behavioral of ALU is
begin
	process(Op, A, B)
	begin
	case (Op) is
		when ALU_AND =>
			R <= A and B;
		when ALU_OR =>
			R <= A or B;
		when ALU_XOR =>
			R <= A xor B;
		when ALU_ADD =>
			R <= std_logic_vector(unsigned(A) + unsigned(B));
		when ALU_SUB =>
			R <= std_logic_vector(unsigned(A) - unsigned(B));
		when ALU_SLL =>
			R <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));
		when ALU_SRL =>
			R <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));
		when ALU_SRA =>
			R <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
		when ALU_BLT =>
			R <= (0 => to_std_logic(signed(A) < signed(B)), others => '0');
		when ALU_BGE =>
			R <= (0 => to_std_logic(signed(A) > signed(B)), others => '0');
		when ALU_BLTU =>
			R <= (0 => to_std_logic(unsigned(A) < unsigned(B)), others => '0');
		when ALU_BGEU =>
			R <= (0 => to_std_logic(unsigned(A) > unsigned(B)), others => '0');
		when ALU_RESET | ALU_NOP =>
			R <= (others => '0');
		when ALU_INVALID =>
			R <= (others => 'X');
		when others =>
			R <= (others => 'U');
	end case;
	end process;
end architecture;