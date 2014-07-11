library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Converter is    
port(
    clk     :   IN std_ulogic;    
    i       :   IN  signed(10 downto 0);          -- 0 to 1023 plus sign bit
    seg0    :   OUT std_ulogic_vector(7 downto 0);
    seg1    :   OUT std_ulogic_vector(7 downto 0);
    seg2    :   OUT std_ulogic_vector(7 downto 0);
    seg3    :   OUT std_ulogic_vector(7 downto 0)
);
end entity;

architecture behave of Converter is
    type    cState      is  (Rec, Mult, Add, Output);
    signal  state       :   cState                  := Rec;
    signal  n0, n1, n2  :   unsigned(3 downto 0)    := x"0";
    signal  c0, c1, c2, c3  :   std_ulogic          := '0';
    signal  s           :   unsigned(3 downto 0)    := x"F";
    signal  reg         :   unsigned(9 downto 0)    := x"0";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when Rec  =>
                    reg <=  i(9 downto 0);
                    n0  <=  x"0";
                    n1  <=  x"0";
                    n2  <=  x"0";
                    c0  <=  '0';
                    c1  <=  '0';
                    c2  <=  '0';
                    c3  <=  '0';
                    
                    if reg(10) = '1' then
                        s   <=  x"A";   -- minus
                    else
                        s   <=  x"F";   -- plus
                    end if;                    
                    state   <=  Mult;
                    
                when Mult =>
                    if reg = 0 then
                        state   <=  Output;
                    else
                        c0      <=  reg(9);
                        reg(9)  <=  reg(8 downto 0) & '0';  -- shifting
                        
                        if n0 > 4 and n0 < 10 then
                            c1  <=  '1';    -- carry
                            n0  <=  (n0 - 5) * 2;
                        else
                            c1  <=  '0';
                            n0  <=  n0 * 2;
                        end if;                        
                        
                        if n1 > 4 and n1 < 10 then
                            c2  <=  '1';    -- carry
                            n1  <=  (n1 - 5) * 2;
                        else
                            c2  <=  '0';
                            n1  <=  n1 * 2;
                        end if;                        
                        
                        if n2 > 4 and n2 < 10 then
                            c3  <=  '1';    -- carry
                            n2  <=  (n2 - 5) * 2;
                        else
                            c3  <=  '0';
                            n2  <=  n2 * 2;
                        end if;
                        
                        state   <=  Add;
                    end if;
                    
                when Add    =>                
                    if c3 = '1' then    -- incorrect output, number is too big
                        n0  <= x"A";      -- minus sign
                        n1  <= x"A";      -- minus sign
                        n2  <= x"A";      -- minus sign
                        s   <= x"A";      -- minus sign
                        state   <=  Rec;
                    else
                        if c0 = '1' then
                            n0  <= n0 + 1;
                        end if;
                        if c1 = '1' then
                            n1  <= n1 + 1;
                        end if;
                        if c2 = '1' then
                            n2  <= n2 + 1;
                        end if;
                        state   <=  Mult;
                    end if;
            end case;
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
