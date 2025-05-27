-- RV32I Datapath

library ieee;
use ieee.std_logic_1164.all;

entity Datapath is
	port (
			clk	: in std_logic;
			reset	: in std_logic
		);
end entity;

architecture structural of Datapath is
	
	component PC is
		port (
				clk		: in std_logic;
				reset		: in std_logic;
				pc_next	: in std_logic_vector(31 downto 0);
				pc_value	: buffer std_logic_vector(31 downto 0)
			);
	end component PC;
	
	component Instr_memory is
		port(
				address	: in std_logic_vector(31 downto 0);
				instr		: out std_logic_vector(31 downto 0)
			);
	end component Instr_memory;

	component CU_decode is
		port (
				instr		: in std_logic_vector(31 downto 0);
				rs1		: out std_logic_vector(4 downto 0);
				rs2		: out std_logic_vector(4 downto 0);
				rd			: out std_logic_vector(4 downto 0);
				imm		: out std_logic_vector(11 downto 0);
				ALU_op	: out std_logic_vector(3 downto 0);
				ALU_src	: out std_logic;
				reg_write	: out std_logic;
				mem_write	: out std_logic;
--				mem_read 	: out std_logic;
				mem_to_reg	: out std_logic;
				branch		: out std_logic
			);
	end component CU_decode;
	
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
	end component RegisterFile;
	
	component ALU is
		port (
				A		: in std_logic_vector(31 downto 0);
				B		: in std_logic_vector(31 downto 0);
				Op		: in std_logic_vector(3 downto 0);
				R		: out std_logic_vector(31 downto 0)
			);
	end component;

	component Writeback is
		port (
				clk		: in std_logic;
				wr_en		: in std_logic;
				address	: in std_logic_vector(31 downto 0);
				wr_data	: in std_logic_vector(31 downto 0);
				re_data	: out std_logic_vector(31 downto 0)
			);
	end component Writeback;

	component adder is
		port (
				A	: in std_logic_vector(31 downto 0);
				B	: in std_logic_vector(31 downto 0);
				Y	: out std_logic_vector(31 downto 0)
			);
	end component adder;

	component MUX is
		port (
				I0	: in std_logic_vector(31 downto 0);
				I1	: in std_logic_vector(31 downto 0);
				sl	: in std_logic;
				Y	: out std_logic_vector(31 downto 0)
			);
	end component MUX;
	
	constant pc_4	: std_logic_vector(31 downto 0) :="00000000000000000000000000000001";
	
	signal imm_extended	: std_logic_vector(31 downto 0);
	signal pc_in	: std_logic_vector(31 downto 0);
	signal pc_out	: std_logic_vector(31 downto 0);
	signal instr_sig	: std_logic_vector(31 downto 0);
	signal rs1_sig	: std_logic_vector(4 downto 0);
	signal rs2_sig	: std_logic_vector(4 downto 0);
	signal rd_sig	: std_logic_vector(4 downto 0);
	signal imm_sig	: std_logic_vector(11 downto 0);
	signal ALU_op_sig	: std_logic_vector(3 downto 0);
	signal ALU_src_sig	: std_logic;
	signal reg_write_sig	: std_logic;
	signal mem_write_sig	: std_logic;
--	signal mem_read_sig	: std_logic;
	signal mem_to_reg_sig	: std_logic;
	signal branch_sig	: std_logic;
	signal reg_mux_out : std_logic_vector(31 downto 0);
	signal ALU_A	: std_logic_vector(31 downto 0);
	signal ALU_B	: std_logic_vector(31 downto 0);
	signal ALU_mux_out	: std_logic_vector(31 downto 0);
	signal R_sig	: std_logic_vector(31 downto 0);
	signal reg_mux_in	: std_logic_vector(31 downto 0);
	signal pc_mux_i0	: std_logic_vector(31 downto 0);
	signal pc_mux_i1	: std_logic_vector(31 downto 0);
	signal pc_mux_sl	: std_logic;
	
begin

	imm_extended <= "00000000000000000000" & imm_sig;
	
	branch_check: process(branch_sig, R_sig)
	begin
		if (branch_sig='1' AND R_sig(0)='0') then
			pc_mux_sl <= '1';
		else
			pc_mux_sl <= '0';
		end if;
	end process;
	
	Program_Counter: PC port map(clk, reset, pc_in, pc_out);
	Instruction_Memory: Instr_memory port map(pc_out, instr_sig);
	Control_Unit: CU_decode port map(instr_sig, rs1_sig, rs2_sig, rd_sig, imm_sig, ALU_op_sig, ALU_src_sig, reg_write_sig, mem_write_sig, mem_to_reg_sig, branch_sig);
	Register_File: RegisterFile port map(clk, reg_write_sig, rs1_sig, rs2_sig, rd_sig, reg_mux_out, ALU_A, ALU_B);
	Arithmetic_Logic_Unit: ALU port map(ALU_A, ALU_mux_out, ALU_op_sig, R_sig);
	Data_Memory: Writeback port map(clk, mem_write_sig, R_sig, ALU_B, reg_mux_in);
	PC_Adder: adder port map(pc_out, pc_4, pc_mux_i0);
	Label_Adder: adder port map(pc_out, imm_extended, pc_mux_i1);
	PC_MUX: MUX port map(pc_mux_i0, pc_mux_i1, pc_mux_sl, pc_in);
	ALU_MUX: MUX port map(ALU_B, imm_extended, ALU_src_sig, ALU_mux_out);
	Reg_MUX: MUX port map(R_sig, reg_mux_in, mem_to_reg_sig, reg_mux_out);
	
end architecture;