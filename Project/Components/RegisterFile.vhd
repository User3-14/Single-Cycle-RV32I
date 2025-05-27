library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
	port (
			clk	: in std_logic;
			wr_en	: in std_logic;
			rs1	: in std_logic_vector(4 downto 0);
			rs2	: in std_logic_vector(4 downto 0);
			rd		: in std_logic_vector(4 downto 0);
			in_d	: in std_logic_vector(31 downto 0);
			out_1	: out std_logic_vector(31 downto 0);
			out_2	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture Behavioral of RegisterFile is

	type regfile_32x32 is array(0 to 31) of std_logic_vector(31 downto 0);
	signal registers : regfile_32x32 :=(others =>(others => '0'));
	
begin
	out_1 <= registers(to_integer(unsigned(rs1)));
	out_2 <= registers(to_integer(unsigned(rs2)));
	
	write_proc: process(clk, wr_en)
	begin
		if rising_edge(clk) then
			if (wr_en='1' AND rd/="00000") then
				registers(to_integer(unsigned(rd))) <= in_d;
			end if;
		end if;
	end process;
end architecture;