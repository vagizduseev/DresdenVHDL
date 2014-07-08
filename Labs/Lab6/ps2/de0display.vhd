library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.DE0_DISPLAY.all;

entity de0display is    
    port(
        clk : in std_logic;
        -- input 4-bit numbers for each LED
        num	: in input_numbers;
        -- output vetors to actual LED ports
        dsp : out displays
    );
end entity;

architecture DE0_DISPLAY_ARC of de0display is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            for i in 0 to LED_COUNT-1 loop    
                dsp(i) <= converter(num(i));
            end loop;
        end if;
    end process;
end architecture;
