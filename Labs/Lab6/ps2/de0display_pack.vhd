library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package DE0_DISPLAY is
    constant LED_COUNT : natural := 4;
    type input_numbers is array(LED_COUNT-1 downto 0) of unsigned(5 downto 0);
    type displays is array(LED_COUNT-1 downto 0) of std_logic_vector(6 downto 0);  
    function converter(number : unsigned(5 downto 0)) return std_logic_vector;    
end package;

package body DE0_DISPLAY is
    function converter(number : unsigned(5 downto 0)) return std_logic_vector is
    begin
        case number is
            when 6x"0" =>   return "1000000"; -- 0
            when 6x"1" =>   return "1111001"; -- 1
            when 6x"2" =>   return "0100100"; -- 2
            when 6x"3" =>   return "0110000"; -- 3
            when 6x"4" =>   return "0011001"; -- 4
            when 6x"5" =>   return "0010010"; -- 5
            when 6x"6" =>   return "0000010"; -- 6
            when 6x"7" =>   return "1111000"; -- 7
            when 6x"8" =>   return "0000000"; -- 8
            when 6x"9" =>   return "0010000"; -- 9
            when 6x"A" =>  return "0001000"; -- A
            when 6x"B" =>  return "0000011"; -- b
            when 6x"C" =>  return "1000110"; -- C
            when 6x"D" =>  return "0100001"; -- d
            when 6x"E" =>  return "0000110"; -- E
            when 6x"F" =>  return "0001110"; -- F
            when 6x"11" =>  return "0001001"; -- H
            when 6x"12" =>  return "1001111"; -- I
            when 6x"15" =>  return "1000111"; -- L
            when 6x"19" =>  return "0001100"; -- P
            when 6x"1C" =>  return "0010010"; -- S
            when 6x"1E" =>  return "1000001"; -- U
            when 6x"22" =>  return "0010001"; -- y
            when others => return "1111111";
        end case;
    end;
end DE0_DISPLAY;