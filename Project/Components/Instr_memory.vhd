-- Instruction Memory

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instr_memory is
	port (
			address	: in std_logic_vector(31 downto 0);
			instr		: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of Instr_memory is
	type ROM256x8 is array (255 downto 0) of std_logic_vector(7 downto 0);
	signal instr_mem : ROM256x8 :=(others => (others => '0'));
begin
	
	-- Program load
	instr_mem(8) <= "10010011";
	instr_mem(9) <= "00000000";
	instr_mem(10) <= "01010000";
	instr_mem(11) <= "00000000";
	instr_mem(12) <= "00010011";
	instr_mem(13) <= "00000001";
	instr_mem(14) <= "10100000";
	instr_mem(15) <= "00000000";
	instr_mem(16) <= "10110011";
	instr_mem(17) <= "10000001";
	instr_mem(18) <= "00100000";
	instr_mem(19) <= "00000000";
	instr_mem(20) <= "00110011";
	instr_mem(21) <= "10000010";
	instr_mem(22) <= "00010001";
	instr_mem(23) <= "01000000";
	instr_mem(24) <= "00100011";
	instr_mem(25) <= "00100000";
	instr_mem(26) <= "01000000";
	instr_mem(27) <= "00000000";
	instr_mem(28) <= "10000011";
	instr_mem(29) <= "00100010";
	instr_mem(30) <= "00000000";
	instr_mem(31) <= "00000000";
	instr_mem(32) <= "01100011";
	instr_mem(33) <= "00000100";
	instr_mem(34) <= "01010010";
	instr_mem(35) <= "00000000";
	instr_mem(36) <= "00010011";
	instr_mem(37) <= "00000011";
	instr_mem(38) <= "00010000";
	instr_mem(39) <= "00000000";
	instr_mem(40) <= "00010011";
	instr_mem(41) <= "00000000";
	instr_mem(42) <= "00000000";
	instr_mem(43) <= "00000000";

	
	process(address)
		variable aligned_address : std_logic_vector(31 downto 0);
	begin
		aligned_address := address(31 downto 2) & "00";
		
		instr(7 downto 0) <= instr_mem(to_integer(unsigned(aligned_address)) + 0);
		instr(15 downto 8) <= instr_mem(to_integer(unsigned(aligned_address) + 1));
		instr(23 downto 16) <= instr_mem(to_integer(unsigned(aligned_address) + 2));
		instr(31 downto 24) <= instr_mem(to_integer(unsigned(aligned_address) + 3));
	end process;
end architecture;
