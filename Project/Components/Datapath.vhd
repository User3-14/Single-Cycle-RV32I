-- Complete Datapath

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ALU_operations.all;

entity Datapath is
	port (
			clk	: in std_logic;
			reset	: in std_logic := '1'
		);
end entity;

architecture behavioral of Datapath is

	constant pc_inc	: std_logic_vector(31 downto 0) := (2 => '1', others => '0');

	--Components
	component PC is
		port (
				clk		: in std_logic;
				reset		: in std_logic;
				pc_next	: in std_logic_vector(31 downto 0);
				pc_value	: out std_logic_vector(31 downto 0)
			);
	end component;

	component Instr_memory is
		port (
				address	: in std_logic_vector(31 downto 0);
				instr		: out std_logic_vector(31 downto 0)
			);
	end component;
	
	component Decode is
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
	end component;

	component Control_Unit is
		port (
				opcode		: in std_logic_vector(6 downto 0);
				func3			: in std_logic_vector(2 downto 0);
				func7			: in std_logic_vector(6 downto 0);
				ALU_op		: out ALU_operation;
				ALU_src		: out std_logic;
				reg_write	: out std_logic;
				mem_write	: out std_logic;
				mem_to_reg	: out std_logic;
				branch		: out std_logic;
				offset		: out std_logic_vector(1 downto 0)
			);
	end component;

	component RegisterFile is
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
	end component;

	component ALU is
		port (
				A		: in std_logic_vector(31 downto 0);
				B		: in std_logic_vector(31 downto 0);
				Op		: in ALU_operation;
				R		: out std_logic_vector(31 downto 0)
			);
	end component;

	component Data_memory is
		port (
				clk			: in std_logic;
				write_en		: in std_logic;
				offset		: in std_logic_vector(1 downto 0);
				address		: in std_logic_vector(31 downto 0);
				write_data	: in std_logic_vector(31 downto 0);
				read_data	: out std_logic_vector(31 downto 0)
			);
	end component;
	
	component adder is
		port (
				A	: in std_logic_vector(31 downto 0);
				B	: in std_logic_vector(31 downto 0);
				Y	: out std_logic_vector(31 downto 0)
			);
	end component;

	component MUX is
		port (
				I0	: in std_logic_vector(31 downto 0);
				I1	: in std_logic_vector(31 downto 0);
				sl	: in std_logic;
				Y	: out std_logic_vector(31 downto 0)
			);
	end component;
	
	-- Constants
	constant pc_4 : std_logic_vector(31 downto 0) := (2 => '1', others => '0');
	
	--Signals
	signal immediate	: std_logic_vector(31 downto 0);
	signal pc_in		: std_logic_vector(31 downto 0);
	signal pc_out		: std_logic_vector(31 downto 0);
	signal instr_sig	: std_logic_vector(31 downto 0);
	signal opcode_sig	: std_logic_vector(6 downto 0);
	signal func3_sig	: std_logic_vector(2 downto 0);
	signal func7_sig	: std_logic_vector(6 downto 0);
	signal rs1_addr	: std_logic_vector(4 downto 0);
	signal rs2_addr	: std_logic_vector(4 downto 0);
	signal rd_addr		: std_logic_vector(4 downto 0);
	signal imm_sig		: std_logic_vector(11 downto 0);
	signal ALU_op_sig	: ALU_operation;
	signal ALU_src		: std_logic;
	signal reg_write	: std_logic;
	signal mem_write	: std_logic;
	signal mem_to_reg	: std_logic;
	signal branch		: std_logic;
	signal offset		: std_logic_vector(1 downto 0);
	signal reg_mux_out	: std_logic_vector(31 downto 0);
	signal ALU_A		: std_logic_vector(31 downto 0);
	signal ALU_B		: std_logic_vector(31 downto 0);
	signal ALU_mux_out	: std_logic_vector(31 downto 0);
	signal R_sig		: std_logic_vector(31 downto 0);
	signal reg_mux_in	: std_logic_vector(31 downto 0);
	signal pc_mux_i0	: std_logic_vector(31 downto 0);
	signal pc_mux_i1	: std_logic_vector(31 downto 0);
	signal pc_mux_sl	: std_logic;
	
begin

	branch_check: process(branch, R_sig)
	begin
		if (branch='1' AND R_sig(0)='0') then
			pc_mux_sl <= '1';
		else
			pc_mux_sl <= '0';
		end if;
	end process;
	
	pc_mux_i0 <= std_logic_vector(unsigned(pc_out) + 4);
	
	process(pc_out, immediate)
		variable pc_label : std_logic_vector(31 downto 0) := (others => '0');
	begin
		pc_label := std_logic_vector(unsigned(immediate) sll 1);
		pc_mux_i1 <= std_logic_vector(unsigned(pc_out) + to_integer(signed(pc_label)));
	end process;
	
	with pc_mux_sl select
		pc_in <= 
			pc_mux_i1 when '1',
			pc_mux_i0 when others;
	
	with ALU_src select
		ALU_mux_out <= 
			immediate when '1',
			ALU_B when others;
	
	with mem_to_reg select
		reg_mux_out <= 
			reg_mux_in when '1',
			R_sig when others;

	-- Port mapping
	Program_Counter: PC port map(clk, reset, pc_in, pc_out);
	Instruction_Memory: Instr_memory port map(pc_out, instr_sig);
	Instruction_Decode: Decode port map(instr_sig, opcode_sig, func3_sig, func7_sig, rs1_addr, rs2_addr, rd_addr, immediate);
	Main_Control_Unit: Control_Unit port map(opcode_sig, func3_sig, func7_sig, ALU_op_sig, ALU_src, reg_write, mem_write, mem_to_reg, branch, offset);
	Register_File: RegisterFile port map(clk, reg_write, rs1_addr, rs2_addr, rd_addr, reg_mux_out, ALU_A, ALU_B);
	AL_Unit: ALU port map(ALU_A, ALU_mux_out, ALU_op_sig, R_sig);
	DataMemory: Data_memory port map(clk, mem_write, offset, R_sig, ALU_B, reg_mux_in);
	
--	PC_Adder: adder port map(pc_out, pc_inc, pc_mux_i0);
--	Label_Adder: adder port map(pc_out, immediate, pc_mux_i1);
	
--	PC_MUX: MUX port map(pc_mux_i0, pc_mux_i1, pc_mux_sl, pc_in);
--	ALU_src_MUX: MUX port map(ALU_B, immediate, ALU_src, ALU_mux_out);
--	Register_src_MUX: MUX port map(R_sig, reg_mux_in, mem_to_reg, reg_mux_out);

end architecture;