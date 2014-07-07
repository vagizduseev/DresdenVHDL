library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity debouncing is
    port(
        clk	    : in std_logic;
        button  : in std_logic;
        display : out std_logic_vector( 0 to 6 );
        led	    : out std_logic
    );	
end entity;

architecture debouncing_arc of debouncing is	
    signal clock_counter : unsigned( 17 downto 0 )  := (others => '0');
    signal press_counter : unsigned( 3 downto 0 )   := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Button pressed
            if button = '0' and clock_counter < 150000 then
                -- Tun on led 0
                led <= '1';
                clock_counter <= clock_counter + 1;
                if clock_counter = 150000 - 1 then
					
                    case press_counter is
                        when "0000"=> display <="0000001"; -- '0'
                        when "0001"=> display <="1001111"; -- '1'
                        when "0010"=> display <="0010010"; -- '2'
                        when "0011"=> display <="0000110"; -- '3'
                        when "0100"=> display <="1001100"; -- '4'
                        when "0101"=> display <="0100100"; -- '5'
                        when "0110"=> display <="0100000"; -- '6'
                        when "0111"=> display <="0001111"; -- '7'
                        when "1000"=> display <="0000000"; -- '8'
                        when "1001"=> display <="0000100"; -- '9'	
                        when "1010"=> display <="0001000"; -- 'A'
                        when "1011"=> display <="1100000"; -- 'B'
                        when "1100"=> display <="0110001"; -- 'C'
                        when "1101"=> display <="1000010"; -- 'D'
                        when "1110"=> display <="0110000"; -- 'E'
                        when "1111"=> display <="0111000"; -- 'F'
                        --nothing is displayed when a number more than 9 is given as input.
                        when others => display <="1111111";
                    end case;
					
                    press_counter <= press_counter + 1;					
                end if;
            elsif button = '1' then
                led <= '0';
                clock_counter <= (others => '0');
            end if;
        end if;
    end process;
end architecture;