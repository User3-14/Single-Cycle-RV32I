-- Byte-offset controller - Load

library ieee;
use ieee.std_logic_1164.all;

entity Load_Control is
	port (
			ofs	: in std_logic_vector(1 downto 0);
			d_in	: in std_logic_vector(31 downto 0);
			d_out	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of Load_Control is
begin
	process(ofs, d_in)
	begin
		case ofs is
			when "00" =>
				d_out <= d_in;
			when "01" =>
				d_out <= "0000000000000000" & d_in(15 downto 0);
			when "10" =>
				d_out <= "000000000000000000000000" & d_in(7 downto 0);
			when "11" =>
				d_out <= "111111111111111111111111" & d_in(7 downto 0);
			when others =>
				d_out <= (others => '0');
		end case;
	end process;
end architecture;