-- Data Memory Controller - Load/Store operations

library ieee;
use ieee.std_logic_1164.all;

entity DataMem_Control is
	port (
			clk		: in std_logic;
			wr_en		: in std_logic;
			offset	: in std_logic_vector(1 downto 0);
			opcode	: in std_logic_vector(6 downto 0);
			func3		: in std_logic_vector(2 downto 0);
			address	: in std_logic_vector(31 downto 0);
			wr_data	: in std_logic_vector(31 downto 0);
			re_data	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of DataMem_Control is
	signal 
begin
	
	write_proc: process(clk)
	begin
		if rising_edge(clk) then
			if (opcode="0100011") then
				
			end if;
		end if;
	end process;
	
	read_proc: process(opcode, func3, address, offset)
	begin
		case offset is
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