----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Shifting 7 segment decoder. The values of SW(3 downto 0) are propagated from
-- right to left on the 8 seven segment displays at a 1 Hz rate. 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;

entity lab3_top is
    generic (shift_ticks: natural := 100000000;
             refresh_ticks: natural := 100000);    -- Default is 1 sec shifts
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           SEG7_CATH : out STD_LOGIC_VECTOR (7 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end lab3_top;

architecture Behavioral of lab3_top is
    signal rst, clk : std_logic;
    
    -- Holds the current 32-bit value to be displayed.
    signal display_value : std_logic_vector (31 downto 0);
    signal do_shift : std_logic;
    
begin
    -- Rename for readability.
    clk <= CLK100MHZ;
    rst <= BTNC;    

    -- Generate the 1 Hz pulse to shift on.
    pulse_1hz : entity pulse_generator port map (
        clk => clk,
        rst => rst,
        period => to_unsigned (shift_ticks, 27),
        pulse_out => do_shift
    );

    -- Shift one left per pulse_1hz output.
--    process (clk, rst)
--    begin
--        if (rst = '1') then
--            display_value <= (others => '0');

--        elsif (rising_edge(clk)) then
--            if (do_shift = '1') then
--                -- Shift left filling with the switch values
--                display_value <= display_value (27 downto 0) & SW (3 downto 0);
--            end if;
--        end if;
--    end process;

    display_value <= (others => '0') when rst = '1' else
                     display_value (27 downto 0) & SW (3 downto 0) when (do_shift = '1' and rising_edge(clk));


    -- Display the 8 characters on the 7 segment banks.  
    seg7 : entity seg7_controller
        generic map (refresh_ticks => refresh_ticks) 
        port map (
            clk => clk,
            rst => rst,
            display_value => display_value,
            an => AN,
            cath => SEG7_CATH
        ); 
    
    -- LEDs just show switch states
    LED <= SW;

end Behavioral;
