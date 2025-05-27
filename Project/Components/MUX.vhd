-- Multiplexer Component

library ieee;
use ieee.std_logic_1164.all;

entity MUX is
	port (
			I0	: in std_logic_vector(31 downto 0);
			I1	: in std_logic_vector(31 downto 0);
			sl	: in std_logic;
			Y	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of MUX is
--	constant oth : std_logic_vector(31 downto 0) :=(others => 'X');
begin
	with sl select
		Y <= 
			I0 when '0',
			I1 when '1',
			(others => 'X') when others;
--			oth when others;
end architecture;