library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Converter is    
port(
    --clk     :   IN std_ulogic;    
    i       :   IN  signed(10 downto 0);          -- 0 to 1023 plus sign bit
    seg0    :   OUT std_ulogic_vector(7 downto 0);
    seg1    :   OUT std_ulogic_vector(7 downto 0);
    seg2    :   OUT std_ulogic_vector(7 downto 0);
    seg3    :   OUT std_ulogic_vector(7 downto 0)
);
end entity;

architecture behave of Converter is
    signal  n0, n1, n2  :   unsigned(3 downto 0)    := 0;
    signal  s           :   unsigned(3 downto 0)    := "1111";
begin
    converter_sys   :   process(bin)
        constant    PLUS    :   unsigned(3 downto )     := "1111";
        constant    MINUS   :   unsigned(3 downto )     := "1010";
        variable    num0, num1, num2    :   unsigned(4 downto 0)    := 0;
        variable    car0, car1, car2    :   std_ulogic              := '0';
        variable    reg     :   unsigned(9 downto 0)    := 0;
    begin
        if i > 999 | i < -999 then  -- undisplayable number
            num0    <=  MINUS;
            num1    <=  MINUS;
            num2    <=  MINUS;
            sign    <=  MINUS;
        else
            if  i(10) = '0' then    -- sign determing
                sign    :=  PLUS;
            else
                sign    :=  MINUS;
            end if;
            
            reg :=  i(9 downto 0);
            for k in 0 to 9 loop
                if num0 > 4 then    -- 5 .. 9
                    car0    := '1';
                    num0    :=  num0 * 2 - 10;
                else
                    num0    :=  num0;
                end if;
                
                if num1 > 4 then    -- 5 .. 9
                    car1    := '1';
                    num1    :=  num1 * 2 - 10;
                else
                    num1    :=  num1;
                end if;
                
                if num2 > 4 then    -- 5 .. 9
                    car2    := '1';
                    num2    :=  num2 * 2 - 10;
                else
                    num2    :=  num2;
                end if;
                
            end loop;
        end if;
    end process;
    
    seg_0   :   entity work.Segment
    port map(
        i   =>  n0,
        o   =>  seg0
    );
    
    seg_1   :   entity work.Segment
    port map(
        i   =>  n1,
        o   =>  seg1
    );
    
    seg_2   :   entity work.Segment
    port map(
        i   =>  n2,
        o   =>  seg2
    );
    
    seg_sign:   entity work.Segment
    port map(
        i   =>  s,
        o   =>  seg3
    );
    
end architecture;
