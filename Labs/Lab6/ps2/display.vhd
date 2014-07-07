library IEEE;
use IEEE.std_logic_1164.all;

entity display is
    port(
        -- synchronising 50 MHz clock signal 
        clk	: in std_logic;
        -- input 4-bit numbers for each LED
        num0, num1, num2, num3 	: in unsigned(3 downto 0);
        -- output vetors to actual LED ports
        dsp0, dsp1, dsp2, dsp3	: out std_logic_vector(6 downto 0)
    );
end entity;

architecture DISPLAY_ARC of display is
    signal out0, out1, out2, out3 : std_logic_vector(6 downto 0) := (others => '1');
    procedure converter(
        signal number : in unsigned(3 downto 0);
        signal led : out std_logic_vector(6 downto 0)) is
    begin
        case number is
            when 0  =>  
                led <= "1000000";   -- 0
            when 1  =>
                led <= "1111001";   -- 1
            when 2  =>
                led <= "0100100";   -- 2
            when 3  =>
                led <= "0110000";   -- 3
            when 4  =>
                led <= "0011001";   -- 4
            when 5  =>
                led <= "0010010";   -- 5
            when 6  =>
                led <= "0000010";   -- 6
            when 7  =>
                led <= "1111000";   -- 7
            when 8  =>
                led <= "0000000";   -- 8
            when 9  =>
                led <= "0010000";   -- 9
            when 10 =>
                led <= "0001000";   -- A
            when 11 =>
                led <= "0000011";   -- b
            when 12 =>
                led <= "1000110";   -- C
            when 13 =>
                led <= "0000110";   -- d
            when 14 =>
                led <= "0100001";   -- E
            when 15 =>
                led <= "0001110";   -- F
            when 17 =>
                led <= "0001001";   -- H
            when 18 =>
                led <= "1001111";   -- I
            when 21 =>
                led <= "1000111";   -- L
            when 25 =>
                led <= "0001100";   -- P
            when 28 =>
                led <= "0010010";   -- S
            when 30 =>
                led <= "1000001";   -- U
            when 34 =>
                led <= "0010001";   -- y
            when others =>
                led <= (others => '1');
        end case;
    end procedure;
begin
    dsp0 <= out0;
    dsp1 <= out1;
    dsp2 <= out2;
    dsp3 <= out3;
    process(clk)
    begin
        if rising_edge(clk) then    -- TODO: rewrite this ugly stuff
            converter(num0, out0);
            converter(num1, out1);
            converter(num2, out2);
            converter(num3, out3);
        end if;
    end process;
end architecture;