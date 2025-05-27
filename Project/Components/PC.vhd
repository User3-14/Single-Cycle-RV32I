-- Program Counter

library ieee;
use ieee.std_logic_1164.all;

entity PC is
	port (
		clk		: in std_logic;
		reset		: in std_logic;
		pc_next	: in std_logic_vector(31 downto 0);
		pc_value	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of PC is
	signal PC_REG : std_logic_vector(31 downto 0) := (others => '0');
begin
	process(clk, reset)
	begin
		if reset='1' then
			PC_REG <= (others => '0');
		else
			if rising_edge(clk) then
				PC_REG <= pc_next;
			end if;
		end if;
	end process;
	pc_value <= PC_REG;
end architecture;