----------------------------------------------------------------------------------
--
-- Author: Todd Blackmon
--
-- Description:
-- Module which converts the binary digit(3:0) input to a 7-segment display 
-- cathode drive array. This version uses a process instead of CSA.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity seg7_hex is
    Port ( digit : in std_logic_vector (3 downto 0);
           seg7 : out std_logic_vector (7 downto 0));
end seg7_hex;

architecture Behavioral of seg7_hex is
begin
    process (digit)
    begin
        case digit is
            when x"0" =>   seg7 <= "11000000";
            when x"1" =>   seg7 <= "11111001"; 
            when x"2" =>   seg7 <= "10100100"; 
            when x"3" =>   seg7 <= "10110000"; 
            when x"4" =>   seg7 <= "10011001"; 
            when x"5" =>   seg7 <= "10010010"; 
            when x"6" =>   seg7 <= "10000010"; 
            when x"7" =>   seg7 <= "11111000"; 
            when x"8" =>   seg7 <= "10000000"; 
            when x"9" =>   seg7 <= "10010000"; 
            when x"A" =>   seg7 <= "10001000"; 
            when x"B" =>   seg7 <= "10000011"; 
            when x"C" =>   seg7 <= "11000110"; 
            when x"D" =>   seg7 <= "10100001"; 
            when x"E" =>   seg7 <= "10000110"; 
            when others => seg7 <= "10001110"; 
        end case;    
    end process;

end Behavioral;
