library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Calculator is  
port(
    clk_50, clk_kb, data_kb  :   IN  std_ulogic;
    swt :   IN  std_logic;
    seg :   OUT std_ulogic_vector(31 downto 0);
    led :   OUT std_ulogic_vector(9 downto 0)
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
    type    cState      is  (sInput, sValidate, sCalculate, sOutput);
    signal  state       :   cState  :=  sInput;
    signal  calculated  :   std_logic   := '0';
    signal  sign_determenition  : std_logic := '1';
    -- calculator stuff
    signal  tmp         :   signed(20 downto 0) :=  (others => '0');    -- up to 1'000'000 with sign
    signal  tmpi        :   signed(41 downto 0) :=  (others => '0');    -- OMG: really?
    signal  arg1        :   signed(10 downto 0) :=  (others => '0');
    signal  arg2        :   signed(10 downto 0) :=  (others => '0');
    signal  sign        :   std_logic           :=  '0';
    signal  valid       :   std_logic           :=  '1';
    -- current displayable number
    signal  dsp_num     :   unsigned(9 downto 0):=  (others => '0');
    signal  current_num :   unsigned(9 downto 0):=  (others => '0');
    -- calculator's internal states
    type    oType       is  (addition, subtraction, multiplying, division, none);
    signal  operation1  :   oType   :=  none;
    signal  operation2  :   oType   :=  none;
    type    cStep       is  (operand1, operand2, calculation);
    signal  calc        :   cStep   :=  operand1;
    --
    signal  leds        :   std_ulogic_vector(8 downto 0)   := "000000001";
begin
    
    led(9)          <= not valid;
    
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
    
    converter_sys   :   entity  work.Converter
    port map(
        clk     =>  clk_50,
        number  =>  dsp_num,
        valid   =>  valid,
        sign    =>  sign,
        seg     =>  seg
    );
    
    dsp_num <=  unsigned ( tmp(9 downto 0) );
    
    process(clk_50)
    begin
        if rising_edge(clk_50) then
            if swt = '1' then                
                led(8 downto 0) <= std_ulogic_vector(tmp(8 downto 0));
            else
                led(8 downto 0) <= leds(8 downto 0);
                case state is
                    when sInput     =>
                        if calculated = '1' then                                    
                            tmp     <= (others => '0');                            
                            tmpi    <= (others => '0');                         
                            arg1    <= (others => '0');                         
                            arg2    <= (others => '0');
                            sign    <= '0';
                            leds    <= "000000001";
                            calc    <= operand1;
                            operation1 <= none;
                            operation2 <= none;
                            calculated <= '0';
                            current_num<= (others => '0');
                        elsif key_strobe = '1' then
                            if key_released = '0' then
                                valid   <= '1';                               
                                case key_scan_code is 
                                    when x"70" =>   tmpi <= tmp * 10;       state <= sValidate;
                                    when x"69" =>   tmpi <= tmp * 10 + 1;   state <= sValidate;
                                    when x"72" =>   tmpi <= tmp * 10 + 2;   state <= sValidate;
                                    when x"7A" =>   tmpi <= tmp * 10 + 3;   state <= sValidate;
                                    when x"6B" =>   tmpi <= tmp * 10 + 4;   state <= sValidate;
                                    when x"73" =>   tmpi <= tmp * 10 + 5;   state <= sValidate;
                                    when x"74" =>   tmpi <= tmp * 10 + 6;   state <= sValidate;
                                    when x"6C" =>   tmpi <= tmp * 10 + 7;   state <= sValidate;
                                    when x"75" =>   tmpi <= tmp * 10 + 8;   state <= sValidate;
                                    when x"7D" =>   tmpi <= tmp * 10 + 9;   state <= sValidate;
                                    when x"5A" =>   -- Enter
                                        if key_extended = '1' then
                                            operation1  <= operation2;
                                            state       <= sCalculate;
                                        end if;
                                    when x"79" =>   -- Plus 
                                        operation1  <= operation2;
                                        operation2  <= addition;
                                        state       <= sCalculate; 
                                    when x"7B" =>   -- Minus
                                        if sign_determenition = '1' then
                                            sign <= '1';
                                        else
                                            operation1  <= operation2;
                                            operation2  <= subtraction;
                                            state       <= sCalculate;
                                        end if;
                                    when x"7C" =>   -- Asterisk
                                        operation1  <= operation2;
                                        operation2  <= multiplying;
                                        state       <= sCalculate;
                                    when x"4A" =>   -- Division (aka slash)
                                        if key_extended = '1' then
                                            operation1  <= operation2;
                                            operation2  <= division;
                                            state       <= sCalculate;
                                        end if;
                                    when x"71" =>   -- Dot (aka 'period', aka 'Del')
                                        calculated <= '1';
                                    when others =>
                                        null;
                                end case;           -- case 'scan code'  
                                sign_determenition <= '0';
                                leds <= leds(7 downto 0) & leds(8);   
                            end if;                 -- key pressed
                        end if;                     -- key strobe = 1
                    when sValidate =>
                        -- validate input
                        if tmpi < -999 or tmpi > 999 then
                            valid <= '0';
                        else
                            valid <= '1';
                            tmp         <= tmpi(20 downto 0);
                        end if;             -- is tmp valid? [-999; 999]   
                        current_num <=  unsigned( tmp(9 downto 0) );
                        state <= sInput;
                        --leds <= leds(7 downto 0) & leds(8);
                    when sCalculate =>
                        case calc is
                            when operand1 =>
                                arg1(10)            <= sign;
                                arg1(9 downto 0)    <= tmp(9 downto 0);
                                tmpi                <= (others => '0');
                                tmp                 <= (others => '0');
                                calc                <= operand2;
                                sign_determenition  <= '1';
                                state               <= sInput;
                                --leds <= leds(7 downto 0) & leds(8);
                            when operand2 =>
                                arg2(10)            <= sign;
                                arg2(9 downto 0)    <= tmp(9 downto 0);
                                tmpi                <= (others => '0');
                                tmp                 <= (others => '0');
                                calc                <= calculation;
                            when calculation =>
                                case operation1 is
                                    when addition       =>
                                        tmp(10 downto 0) <=  arg1 + arg2;
                                    when subtraction    =>
                                        tmp(10 downto 0) <=  arg1 - arg2;
                                    when multiplying    =>
                                        tmp <=  resize(arg1 * arg2, 21);
                                    when division       =>  
                                        tmp(10 downto 0) <=  arg1 / arg2;   
                                    when none =>
                                        --state   <= sInput;
                                        --leds <= leds(7 downto 0) & leds(8);
                                end case;
                                state   <=  sOutput;
                                --leds    <= leds(7 downto 0) & leds(8);
                        end case;   -- case 'calc'
                    when    sOutput =>                
                        -- validate output
                        if tmp < -999 or tmp > 999 then
                            valid <= '0';
                        else
                            valid <= '1';
                            sign  <=  tmp(20);
                        end if;  
                        current_num <=  unsigned( tmp(9 downto 0) );                        
                        state       <=  sInput;
                        --leds <= leds(7 downto 0) & leds(8);
                        calculated <= '1';
                end case;           -- case 'state'
            end if;
        end if;                 -- rising edge 'clk'
    end process;

end architecture;