----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Utility package for my types
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package utility is
    -- vector of digits to show on the 7 segment display bank.
    type digit_vector is array (7 downto 0) of std_logic_vector (3 downto 0);
    
    function seg7_to_char (cath: std_logic_vector (7 downto 0))
                return character;
                
    function seg7_to_str (an, cath: std_logic_vector (7 downto 0))
                return string;
end package;

package body utility is
    function seg7_to_char (cath: std_logic_vector (7 downto 0))
            return character is
        variable result: character;
    begin
        case cath is
            when "11000000" => result := '0';
            when "11111001" => result := '1';
            when "10100100" => result := '2';
            when "10110000" => result := '3';
            when "10011001" => result := '4';
            when "10010010" => result := '5';
            when "10000010" => result := '6';
            when "11111000" => result := '7';
            when "10000000" => result := '8';
            when "10010000" => result := '9';
            when "10001000" => result := 'A';
            when "10000011" => result := 'B';
            when "11000110" => result := 'C';
            when "10100001" => result := 'D';
            when "10000110" => result := 'E';
            when "10001110" => result := 'F';
            when others => result := 'X';
        end case;
   
        return result;
    end function;

    -- Converts the anode/cathode signals to a string variable.
    function seg7_to_str (an, cath: std_logic_vector (7 downto 0))
            return string is
        variable result: string (1 to 8);
    begin
        for i in 1 to 8 loop
            if (an(8 - i) = '1') then
                result(i) := ' ';
            else
                result(i) := seg7_to_char(cath);
            end if;
        end loop;
        return result;
    end function;
end package body;

