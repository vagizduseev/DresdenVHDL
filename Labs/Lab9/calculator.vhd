library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Calculator is  
port(
    clk_50, clk_kb, data_kb  :   IN  std_ulogic;
    seg :   OUT std_ulogic_vector(31 downto 0);
);
end entity;

architecture behave of Calculator is
    -- signals from PS/2 byte stream
    signal  stream_bs   :   std_logic_vector(7 downto 0);
    signal  strobe_bs   :   std_logic;
    -- signals from PS/2 buffer
    signal  key_scan_code   :   std_logic_vector(7 downto 0);
    signal  key_extended, key_released, key_strobe  :   std_logic := '0';
    -- state machine
    type    cState      is  (sSignInput, sInput, sCalculate, sErase);
    signal  state       :   cState  :=  sInput;
    -- calculator stuff
    signal  tmp         :   unsigned(9 downto 0) :=  (others => '0');
    signal  arg1        :   signed(10 downto 0) :=  (others => '0');
    signal  arg2        :   signed(10 downto 0) :=  (others => '0');
    signal  sign        :   std_logic           :=  '0';
    signal  operand     :   std_logic           :=  '0';
    type    oType       is  (addition, subtraction, multiplying, division);
    signal  operation   :   oType;
begin
    
    ps2_byte_stream :   entity  work.ps2bytestream
    port map(
		clk_kb  =>  clk_kb, 
        clk_50  =>  clk_50, 
        data    =>  data_kb,
		stream  =>  stream_bs,
		strobe  =>  strobe_bs
    );
    
    ps2_buffer      :   entity  work.ps2buffer
    port map(        
		clk_50      =>  clk_50, 
        strobe_in   =>  strobe_bs,
		data        =>  stream_bs,
		byte        =>  key_scan_code,
		extended    =>  key_extended,
        released    =>  key_released, 
        strobe_out	=>  key_strobe
    );
    
    converter_sys   :   entity  work.Conveter
    port map(
        clk     =>  clk_50,
        number  =>  result,
        sign    =>  sign,
        seg     =>  seg
    );
    
    process(clk_50)
    begin
        if rising_edge(clk_50) then
            case state is
                when sSignInput =>
                    if key_strobe = '1' then
                        if key_released = '0' then
                            case key_scan_code is 
                                when x"7B"  =>  sign   <= '1';
                                when others =>  sign   <= '0';
                            end case;
                            result  <=  0;
                            state   <=  sInput;
                        end if;
                    end if;
                when sInput     =>
                    if key_strobe = '1' then
                        if key_released = '0' then
                            case key_scan_code is 
                                when x"70" =>   result <= result * 10; 
                                when x"69" =>   result <= result * 10 + 1;
                                when x"72" =>   result <= result * 10 + 2;
                                when x"7A" =>   result <= result * 10 + 3;
                                when x"6B" =>   result <= result * 10 + 4;
                                when x"73" =>   result <= result * 10 + 5;
                                when x"74" =>   result <= result * 10 + 6;
                                when x"6C" =>   result <= result * 10 + 7;
                                when x"75" =>   result <= result * 10 + 8;
                                when x"7D" =>   result <= result * 10 + 9;
                                when x"5A" =>   -- Enter
                                    if key_extended then
                                        state       <= sCalculate;
                                    end if;
                                when x"79" =>   -- Plus 
                                    operation   <= addition;
                                    state       <= sCalculate; 
                                when x"7B" =>   -- Minus
                                    operation   <= subtraction;
                                    state       <= sCalculate; 
                                when x"7C" =>   -- Asterisk
                                    operation   <= multiplying;
                                    state       <= sCalculate;
                                when x"4A" =>   -- Division (aka slash)
                                    if key_extended then
                                        operation   <= division;
                                        state       <= sCalculate;
                                    end if;
                                when x"71" =>   -- Dot (aka 'period', aka 'Del')
                                    state       <= sErase;
                                when others =>
                                    null;
                            end case;   -- case scan code
                        end if;         -- key pressed
                    end if;             -- key strobe = 1
                when sCalculate =>
                    if operand = '0' then
                        arg1(10)            <= sign;
                        arg1(9 downto 0)    <= tmp(9 downto 0);
                        operand             <= '1';
                        state               <= sSignInput;
                    else
                        
                    end if;
                when sErase =>
                    result  <= 0;
                    state   <= sInput;
            end case;
        end if;
    end process;

end bahave;