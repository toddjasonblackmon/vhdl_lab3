----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Time multiplexed 7 segment LED driver.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity seg7_controller is
    generic (refresh_ticks: natural := 100000);
    Port ( clk : in std_logic;
           rst : in std_logic;
           
           -- 32-bit value to display
           display_value : in std_logic_vector (31 downto 0);
           
           -- an and cath are sequenced to show full display_value
           -- to the human eye on the 7-segment bank.
           an : out std_logic_vector (7 downto 0); 
           cath : out std_logic_vector (7 downto 0)
    );
end seg7_controller;

architecture Behavioral of seg7_controller is
    signal current_digit : std_logic_vector (3 downto 0);
    signal anode : std_logic_vector (7 downto 0); 
    signal khz_pulse : std_logic;
    
begin
    -- Generate a 1 kHz pulse to iterate through the anodes
    pulse_1khz : entity work.pulse_generator port map (
        clk => clk,
        rst => rst,
        period => to_unsigned (refresh_ticks, 27),
        pulse_out => khz_pulse
    );
    
    -- Now iterate through them at a 1 kHz rate
    -- Use one-hot style so anode doesn't have to be decoded for the an output
    process (clk, rst)
    begin
        if (rst = '1') then
            anode <= "11111110";
        elsif (rising_edge(clk)) then
            if (khz_pulse = '1') then
                anode <= anode (6 downto 0) & anode(7); -- rol
            end if;
        end if;
    end process;

--    current_digit <= 
--        display_value ( 3 downto  0) when std_match ("-------0", anode) else
--        display_value ( 7 downto  4) when std_match ("------0-", anode) else
--        display_value (11 downto  8) when std_match ("-----0--", anode) else
--        display_value (15 downto 12) when std_match ("----0---", anode) else
--        display_value (19 downto 16) when std_match ("---0----", anode) else
--        display_value (23 downto 20) when std_match ("--0-----", anode) else
--        display_value (27 downto 24) when std_match ("-0------", anode) else
--        display_value (31 downto 28);

    current_digit <= 
        display_value ( 3 downto  0) when anode(0) = '0' else
        display_value ( 7 downto  4) when anode(1) = '0' else
        display_value (11 downto  8) when anode(2) = '0' else
        display_value (15 downto 12) when anode(3) = '0' else
        display_value (19 downto 16) when anode(4) = '0' else
        display_value (23 downto 20) when anode(5) = '0' else
        display_value (27 downto 24) when anode(6) = '0' else
        display_value (31 downto 28);


    -- Use the internal anode signal to select amongst the 
    -- eight possible digit inputs.
--    process (display_value, anode)
--    begin
--        case anode is
--            when "11111110" =>  current_digit <= display_value( 3 downto  0);
--            when "11111101" =>  current_digit <= display_value( 7 downto  4); 
--            when "11111011" =>  current_digit <= display_value(11 downto  8);
--            when "11110111" =>  current_digit <= display_value(15 downto 12);
--            when "11101111" =>  current_digit <= display_value(19 downto 16);
--            when "11011111" =>  current_digit <= display_value(23 downto 20);
--            when "10111111" =>  current_digit <= display_value(27 downto 24);
--            when others =>      current_digit <= display_value(31 downto 28);
--        end case;    
--    end process;

    -- 7 segment encoder to encode the current input
    s7_hex : entity seg7_hex port map (
        digit => current_digit,
        seg7 => cath
    );
    
    -- Pass the internal anode signal out.
    an <= anode;


end Behavioral;
