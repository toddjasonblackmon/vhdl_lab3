----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Top level testbench module for lab3_top.
--
----------------------------------------------------------------------------------


library IEEE;
library utility;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use work.utility.all;

entity lab3_top_tb is
end lab3_top_tb;

architecture testbench of lab3_top_tb is
    type sample is record
        btnc : std_logic;
        sw : std_logic_vector (15 downto 0);
        disp_char : string (1 to 8);
        wait_cycles : natural;

    end record;
    type sample_array is array (natural range <>) of sample;
    
    -- We want to sim faster, so make a 1 ms = 1 us
    constant MS_WAIT : integer := 100;
    constant test_data : sample_array :=
        ( -- btnc   sw      disp_char  wait
            ('1', X"1234", "       0", 0),
            ('0', X"1234", "       0", 10),
            
            -- Check that each character displays as 0.
            ('0', X"1234", "      00", MS_WAIT-1),
            ('0', X"1234", "     000", MS_WAIT-1),
            ('0', X"1234", "    0000", MS_WAIT-1),
            ('0', X"1234", "   00000", MS_WAIT-1),
            ('0', X"1234", "  000000", MS_WAIT-1),
            ('0', X"1234", " 0000000", MS_WAIT-1),
            ('0', X"1234", "00000000", MS_WAIT-1),
            
            -- Wait until display cycle *before* the '4' will shift in.
            -- Check that all characters still display as 0.
            ('0', X"1234", "00000000", (1000 - 15) * MS_WAIT - 1),    -- one before character shifted in
            ('0', X"1234", "00000000", (7) * MS_WAIT-1),
            
            -- This should be the cycle where the '4' shifts in.
            ('0', X"1234", "00000004", MS_WAIT-1),
            
            -- Wait until display cycle *before* the 'd' shifts in.
            -- Check that all characters haven't changed.
            ('0', X"123d", "00000004", (1000 - 1) * MS_WAIT-1),    -- one before character shifted in
            
            -- This should be the cycle where the 'D' shifts in.
            -- Then should be '4', then 0s again.
            ('0', X"123d", "0000000D", MS_WAIT-1),
            ('0', X"123d", "0000004D", MS_WAIT-1),
            ('0', X"123d", "0000004D", (6) * MS_WAIT-1),
            
            ('0', X"123d", "000004DD", 1000 * MS_WAIT),
            ('0', X"123d", "00004DDD", 1000 * MS_WAIT),
            ('0', X"123d", "0004DDDD", 1000 * MS_WAIT),
            ('0', X"123d", "004DDDDD", 1000 * MS_WAIT),
            ('0', X"123d", "04DDDDDD", 1000 * MS_WAIT),
            ('0', X"123d", "4DDDDDDD", 1000 * MS_WAIT),
            ('0', X"123d", "DDDDDDDD", 1000 * MS_WAIT)
        );
        
    signal CLK100MHZ : std_logic;
    signal BTNC : std_logic;
    signal sw : std_logic_vector (15 downto 0);
    signal LED : std_logic_vector (15 downto 0);
    signal SEG7_CATH : std_logic_vector (7 downto 0);
    signal AN : std_logic_vector (7 downto 0);
    signal clock_count : natural; 
    signal test_vector : natural;
    signal persist_disp : string (1 to 8);
    type time_array is array (1 to 8) of time;
    
    signal last_seen : time_array;
begin
    -- Models persistence as seen by a human.
    persist_proc: process (an, seg7_cath)
    begin
        for i in 1 to 8 loop
            -- If this character active, update timestamp and character
            if (an(8-i) = '0') then
                persist_disp(i) <= seg7_to_char(seg7_cath);
                last_seen(i) <= now;
                
            -- If not, did it time out?
            elsif ((now - last_seen(i)) > 100 ms) then
                persist_disp(i) <= ' ';
            end if;
        end loop;            
    end process;

    sim_proc: process
    begin
        clock_count <= 0;
        for i in test_data'range loop
            test_vector <= i;
            -- Wait for a bit.
            if test_data(i).wait_cycles > 0 then
                for j in 0 to test_data(i).wait_cycles loop
                    CLK100MHZ <= '0';
                    wait for 5 ns; 
                    CLK100MHZ <= '1';
                    wait for 5 ns;
                end loop;
            end if;
            
            -- Setup the inputs
            btnc <= test_data(i).btnc;
            sw <= test_data(i).sw;
            
            -- One clock and see the output
            CLK100MHZ <= '0';
            wait for 5 ns; 
            CLK100MHZ <= '1';
            wait for 5 ns;
            
            assert (persist_disp = test_data(i).disp_char)
                report "iteration " & integer'image(i) & ": disp_char is wrong!" severity failure;
            assert std_match(led, sw)
                report "iteration " & integer'image(i) & ": output led is wrong!" severity failure;
        end loop;
        report "Simulation successful";
        wait;
    end process;

    CUT: entity lab3_top
        generic map (100000,  100)
        port map (CLK100MHZ, BTNC, SW, LED, SEG7_CATH, AN);

end testbench;
