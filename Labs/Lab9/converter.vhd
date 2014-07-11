library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Converter is    
port(
    clk     :   IN  std_logic;    
    number  :   IN  unsigned(9 downto 0);          -- from '0' up to '999'
    valid   :   IN  std_logic;
    sign    :   IN  std_logic;
    seg     :   OUT std_ulogic_vector(31 downto 0)
);
end entity;

architecture behave of Converter is
    -- states
    type    cState  is  (Idle, Initialize, Convert);
    signal  state   :   cState  :=  Idle;
    -- shift register and array of decimal digits
    signal  reg     :   unsigned(9 downto 0)    := (others => '0');
    type    numT    is  array (2 downto 0) of unsigned(3 downto 0);
    signal  num     :   numT;
    -- array of ouput decimal digits
    -- -- TODO: add an array, implement 'Output' state
    -- carry
    signal  carry   :   unsigned(1 downto 0);
    -- sign output
    signal  num_sign:   unsigned(3 downto 0)    := x"F"; -- plus  
    -- counters
    signal  counter :   unsigned(3 downto 0);
    signal  digit   :   unsigned(1 downto 0);
    --
    signal  prev    :   unsigned(9 downto 0)    := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then    
            -- state
            case state is
                when Idle   =>
                    if number(9 downto 0) /= prev(9 downto 0) then
                        prev <= number;
                        -- set sign output
                        if sign = '1' then
                            num_sign <= x"A";
                        else
                            num_sign <= x"F";
                        end if;
                        state <= Initialize;
                    end if;
                when Initialize  =>
                    -- start loop for nonzero input values
                    if valid = '1' then
                        -- set decimal digits to zero
                        num(0)  <=  x"0";
                        num(1)  <=  x"0";
                        num(2)  <=  x"0";
                        -- buffer
                        reg     <=  number(9 downto 0);
                        -- carry
                        carry   <=  '0' & number(9);         
                        -- initialize shift-counter and digit-counter
                        counter <= to_unsigned(0, 4);
                        digit   <= to_unsigned(0, 2);
                        -- switch to loop state
                        state <=  Convert;
                    else
                        num(0)  <=  x"A";   -- set all digits to 'minus sign'
                        num(1)  <=  x"A";
                        num(2)  <=  x"A";
                        state   <= Idle;
                    end if;
                    
                when Convert =>
                    if counter <= reg'high then
                        -- switch between digits
                        if digit <= 2 then                            
                            if num(to_integer(digit)) >= 5 and num(to_integer(digit)) <= 9 then
                                num(to_integer(digit))  <=  (num(to_integer(digit)) - 5) * 2 + carry;
                                carry   <=  "01";
                            else
                                num(to_integer(digit))  <=  num(to_integer(digit)) * 2 + carry;
                                carry   <=  "00";
                            end if;  
                            digit   <=  digit + 1;
                        else    
                            -- get the carry
                            carry   <=  '0' & reg(8);
                            -- shift the register
                            reg     <=  reg(8 downto 0) & '0';
                            -- increment shift-counter
                            counter <=  counter + 1;
                            -- set digit-counter to zero
                            digit   <=  "00";
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
        o   =>  seg(6 downto 0)
    );
    
    seg_1   :   entity work.Segment
    port map(
        i   =>  num(1),
        o   =>  seg(14 downto 8)
    );
    
    seg_2   :   entity work.Segment
    port map(
        i   =>  num(2),
        o   =>  seg(22 downto 16)
    );
    
    seg_sign:   entity work.Segment
    port map(
        i   =>  num_sign,
        o   =>  seg(30 downto 24)
    );
    
    seg(31) <= '1';
    seg(23) <= '1';
    seg(15) <= '1';
    seg(7)  <= '1';
    
end architecture;
