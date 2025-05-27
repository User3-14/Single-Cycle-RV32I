-- Decoder

library ieee;
use ieee.std_logic_1164.all;

entity Decode is
	port (
			instruction	: in std_logic_vector(31 downto 0);
			opcode		: out std_logic_vector(6 downto 0);
			func3			: out std_logic_vector(2 downto 0);
			func7			: out std_logic_vector(6 downto 0);
			rs1_addr		: out std_logic_vector(4 downto 0);
			rs2_addr		: out std_logic_vector(4 downto 0);
			rd_addr		: out std_logic_vector(4 downto 0);
			immediate	: out std_logic_vector(31 downto 0)
		);
end entity;

architecture behavioral of Decode is
begin
	opcode <= instruction(6 downto 0);
	func3 <= instruction(14 downto 12);
	func7 <= instruction(31 downto 25);
	rs1_addr <= instruction(19 downto 15);
	rs2_addr <= instruction(24 downto 20);
	rd_addr <= instruction(11 downto 7);

	decode: process(instruction)
	begin
		case instruction(6 downto 2) is
			-- U-type: LUI, AUIPC
			when b"01101" | b"00101" =>
				-- imm[31:12] = instruction[31:12], imm[11:0] = 0
				immediate <= instruction(31 downto 12) & (11 downto 0 => '0');

			-- UJ-type: JAL
			when b"11011" =>
				-- imm[20|10:1|11|19:12] << 1, sign-extended
				immediate <= (31 downto 20 => instruction(31)) &    -- sign extension (imm[31:20])
				             instruction(19 downto 12) &             -- imm[19:12]
				             instruction(20) &                       -- imm[11]
				             instruction(30 downto 21) &             -- imm[10:1]
				             '0';                                    -- imm[0]

			-- I-type: JALR, LOAD, OP-IMM, SYSTEM
			when b"11001" | b"00000" | b"00100" | b"11100" =>
				-- imm[11:0] = instruction[31:20], sign-extended
				immediate <= (31 downto 11 => instruction(31)) & instruction(30 downto 20);

			-- SB-type: Branch instructions
			when b"11000" =>
				-- imm[12|10:5|4:1|11] << 1, sign-extended
				immediate <= (31 downto 13 => instruction(31)) &  -- sign extension (imm[31:13])
				             instruction(7) &                      -- imm[11]
				             instruction(30 downto 25) &          -- imm[10:5]
				             instruction(11 downto 8) &           -- imm[4:1]
				             '0';                                  -- imm[0]

			-- S-type: Store instructions
			when b"01000" =>
				-- imm[11:5] = instruction[31:25], imm[4:0] = instruction[11:7], sign-extended
				immediate <= (31 downto 11 => instruction(31)) & 
				             instruction(30 downto 25) &
				             instruction(11 downto 7);

			-- Default fallback
			when others =>
				immediate <= (others => '0');
		end case;
	end process decode;
end architecture;