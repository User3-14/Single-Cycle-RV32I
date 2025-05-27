-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RegisterFile_tb is
end;

architecture bench of RegisterFile_tb is

  component RegisterFile
  	port (
  		clk		: in std_logic;
  		we			: in std_logic;
  		rs1		: in std_logic_vector(4 downto 0);
  		rs2		: in std_logic_vector(4 downto 0);
  		rd			: in std_logic_vector(4 downto 0);
  		din		: in std_logic_vector(31 downto 0);
  		dout_1	: out std_logic_vector(31 downto 0);
  		dout_2	: out std_logic_vector(31 downto 0)
  		);
  end component;

  signal clk: std_logic;
  signal we: std_logic;
  signal rs1: std_logic_vector(4 downto 0);
  signal rs2: std_logic_vector(4 downto 0);
  signal rd: std_logic_vector(4 downto 0);
  signal din: std_logic_vector(31 downto 0);
  signal dout_1: std_logic_vector(31 downto 0);
  signal dout_2: std_logic_vector(31 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: RegisterFile port map ( clk    => clk,
                               we     => we,
                               rs1    => rs1,
                               rs2    => rs2,
                               rd     => rd,
                               din    => din,
                               dout_1 => dout_1,
                               dout_2 => dout_2 );

  stimulus: process
  begin
  
    -- Put initialisation code here


    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;