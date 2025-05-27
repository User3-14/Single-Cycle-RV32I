-- Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	port (
		A	: in std_logic_vector(31 downto 0);
		B	: in std_logic_vector(31 downto 0);
		Y	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of adder is
begin
	Y <= std_logic_vector(unsigned(A) + unsigned(B));
end architecture;