----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Pulse generator that generates a pulse of one clk period per period cycles.
-- The lowest frequency possible is 1 Hz with a 100 MHz input signal
-- The rising edge of the pulse is coincident with the internal counter reset.
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_generator is
    Port ( clk : in std_logic;
           rst : in std_logic;
           period : in unsigned (26 downto 0);
           pulse_out : out std_logic);
end pulse_generator;

architecture Behavioral of pulse_generator is
    signal pulse_count : unsigned (26 downto 0);
    signal next_count : unsigned (26 downto 0);
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            pulse_count <= (others => '0');
        elsif (rising_edge(clk)) then
            if (pulse_count = (period-1)) then
                pulse_count <= (others => '0');
            else
                pulse_count <= pulse_count + 1;
            end if;
        end if;
    end process;

    pulse_out <= '1' when pulse_count = (period-1) else '0';                   
 

end Behavioral;
