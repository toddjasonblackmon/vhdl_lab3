----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Basic testbench to check the pulse generator.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity test_pulse_generator_tb is
end test_pulse_generator_tb;

architecture Testbench of test_pulse_generator_tb is

signal clk : std_logic;
signal rst : std_logic;
signal period : unsigned (26 downto 0) := to_unsigned (100000, 27);
signal pulse_out : std_logic;
signal clk_count : natural := 0;

begin

    rst <= '0', '1' after 20 ns, '0' after 95 ns;
    
    process
    begin
        if (rst = '0') then
            clk_count <= clk_count + 1;
        end if;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end process;

    dut : entity work.pulse_generator port map (
        clk => clk,
        rst => rst,
        period => period,
        pulse_out => pulse_out
    );


end Testbench;
