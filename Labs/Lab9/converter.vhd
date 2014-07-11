library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Converter is    
port(
    clk     :   IN  std_ulogic;    
    number  :   IN  unsigned(9 downto 0);          -- from '0' up to '999'
    sign    :   IN  std_logic,
    seg     :   OUT std_ulogic_vector(31 downto 0);
);
end entity;

architecture behave of Converter is
    -- states
    type    cState  is  (Idle, Convert);
    signal  state   :   cState  :=  Idle;
    -- shift register and array of decimal digits
    signal  reg     :   unsigned(9 downto 0)    := x"0";
    signal  num     :   array(2 downto 0) of unsigned(3 downto 0);
    -- array of ouput decimal digits
    -- -- TODO: add an array, implement 'Output' state
    -- carry
    signal  carry   :   std_logic;
    -- sign output
    signal  num_sign:   unsigned(3 downto 0)    := x"F"; -- plus  
    -- counters
    signal  counter :   unsigned(3 downto 0);
    signal  digit   :   unsigned(1 downto 0);
begin
    
    -- sign ouput
    if sign = '1' then
        num_sign <= x"A";
    else
        num_sign <= x"F";
    end if;

    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when Idle  =>
                    -- start loop for nonzero input values
                    if number > 999 then
                        num(0)  <=  x"A";   -- set all digits to 'minus sign'
                        num(1)  <=  x"A";
                        num(2)  <=  x"A";
                    else
                        -- set decimal digits to zero
                        num(0)  <=  x"0";
                        num(1)  <=  x"0";
                        num(2)  <=  x"0";
                        -- buffer
                        reg     <=  i(9 downto 0);
                        -- carry
                        carry   <=  i(9);         
                        -- initialize shift-counter and digit-counter
                        counter <= 0;
                        digit   <= 0;
                        -- switch to loop state
                        state <=  Convert;
                    end if;
                    
                when Convert =>
                    if counter <= reg'high then
                        -- switch between digits
                        if digit <= 2 then                            
                            if num(to_integer(digit)) >= 5 and num(to_integer(digit)) <= 9 then
                                num(to_integer(digit))  <=  (num(to_integer(digit)) - 5) * 2 + carry;
                                carry   <=  '1';
                            else
                                num(to_integer(digit))  <=  num(to_integer(digit)) * 2 + carry;
                                carry   <=  '0';
                            end if;  
                            digit   <=  digit + 1;
                        else    
                            -- get the carry
                            carry   <=  i(8);
                            -- shift the register
                            reg     <=  reg(8 downto 0) & '0';
                            -- increment shift-counter
                            counter <=  counter + 1;
                            -- set digit-counter to zero
                            digit   <=  0;
                        end if;
                    else
                        state   <=  Idle;
                    end if;                
            end case;
        end if;
    end process;
    
    seg_0   :   entity work.Segment
    port map(
        i   =>  num(0),
        o   =>  seg(7 downto 0)
    );
    
    seg_1   :   entity work.Segment
    port map(
        i   =>  num(1),
        o   =>  seg(15 downto 8)
    );
    
    seg_2   :   entity work.Segment
    port map(
        i   =>  num(2),
        o   =>  seg(23 downto 16)
    );
    
    seg_sign:   entity work.Segment
    port map(
        i   =>  num_sign,
        o   =>  seg(31 downto 24)
    );
    
end architecture;
