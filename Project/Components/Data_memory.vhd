-- Data Memory (with built-in memory controller for load/store operations)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
	port (
		clk			: in std_logic;
		write_en		: in std_logic := '0';
		read_en		: in std_logic := '1';
		offset		: in std_logic_vector(1 downto 0) := "00";
		address		: in std_logic_vector(31 downto 0) := (others => '0');
		write_data	: in std_logic_vector(31 downto 0);
		read_data	: out std_logic_vector(31 downto 0)
	);
end entity data_memory;

architecture behavioral of data_memory is
	
	type memory_array is array(31 downto 0) of std_logic_vector(7 downto 0);
	signal memory : memory_array := (others => (others => '0'));
	signal update : std_logic := '0';

begin

	process(clk)
		variable aligned_address_std : std_logic_vector(31 downto 0) := (others => '0');
		variable aligned_address : natural := 0;
	begin
		if rising_edge(clk) then
			if write_en = '1' then
				case offset is
					when "00" =>	-- Word Access (sw)
						aligned_address_std := address and "11111111111111111111111111111100";
						aligned_address := to_integer(unsigned(aligned_address_std));
						memory(aligned_address + 0) <= write_data(7 downto 0);
						memory(aligned_address + 1) <= write_data(15 downto 8);
						memory(aligned_address + 2) <= write_data(23 downto 16);
						memory(aligned_address + 3) <= write_data(31 downto 24);
					when "01" => -- Halfword Access (sh)
						aligned_address_std := address and "11111111111111111111111111111110";
						aligned_address := to_integer(unsigned(aligned_address_std));
						memory(aligned_address + 0) <= write_data(7 downto 0);
						memory(aligned_address + 1) <= write_data(15 downto 8);
					when "10" => -- Signed Byte Access (sb)
						aligned_address_std := address;
						aligned_address := to_integer(unsigned(aligned_address_std));
						memory(aligned_address) <= write_data(7 downto 0);
					when others => 
				end case;
				update <= '1';
			end if;
		end if;
	end process;

	process(read_en, address, offset, write_en, write_data)
		variable aligned_address_std : std_logic_vector(31 downto 0) := (others => '0');
		variable aligned_address : natural := 0;
	begin
		if (read_en='1') then
		case offset is
			when "00" => -- Word Access (lw)
				aligned_address_std := address and "11111111111111111111111111111100";
				aligned_address := to_integer(unsigned(aligned_address_std));
				read_data(7 downto 0)	<= memory(aligned_address + 0);
				read_data(15 downto 8)	<= memory(aligned_address + 1);
				read_data(23 downto 16)	<= memory(aligned_address + 2);
				read_data(31 downto 24)	<= memory(aligned_address + 3);
			when "01" => -- Halfword Access (lh)
				aligned_address_std := address and "11111111111111111111111111111110";
				aligned_address := to_integer(unsigned(aligned_address_std));
				read_data(7 downto 0)	<= memory(aligned_address + 0);
				read_data(15 downto 8)	<= memory(aligned_address + 1);
				read_data(31 downto 16)	<= (others => '0');
			when "10" => -- Signed Byte Access (lb)
				aligned_address_std := address;
				aligned_address := to_integer(unsigned(aligned_address_std));
				read_data(7 downto 0)	<= memory(aligned_address);
				read_data(31 downto 8)	<= (others => read_data(7));
			when "11" => -- Unsigned Byte Access (lbu)
				aligned_address_std := address;
				aligned_address := to_integer(unsigned(aligned_address_std));
				read_data(7 downto 0)	<= memory(aligned_address);
				read_data(31 downto 8)	<= (others => '0');
			when others => 
		end case;
		update <= '0';
		end if;
	end process;

end architecture;
