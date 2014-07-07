library IEEE;
use IEEE.std_logic_1164.all;

entity ps2receiver is
    port(		
        clk_kb, clk_50  : in std_logic;
        data    : in std_logic;
        byte    : out std_logic_vector(7 downto 0);
        strobe  : out std_logic
    );
end entity;

architecture PS2_RECEIVER_ARC of ps2receiver is
    type rState	is (Receiving, Sending, Erasing);
    signal state    : rState := Receiving;
    signal buf	    : std_logic_vector(10 downto 0) := (others => '1');
    signal dff_0, dff_1     : std_logic := '1';
    signal strb	    : std_logic := '0';
begin
    -- comment
    strobe  <= strb;
    byte    <= buf(8 downto 1);

    process(clk_50)
    begin
        if rising_edge(clk_50) then
            -- 
            dff_1 <= dff_0;	-- save previous clk_kb state
            dff_0 <= clk_kb;	-- get current clk_kb state
            --
            case state is		
            --
                when Receiving =>
                    if buf(0) = '0' then
                        state <= Sending;
                    -- Falling edge of the clk_kb
                    elsif dff_0 = '0' and dff_1 = '1' then
                        buf <= data & buf(10 downto 1);
                    end if;
                --
				when Sending =>
					strb    <= '1';
					state   <= Erasing;
				--	
                when Erasing =>
                    strb    <= '0';
                    buf     <= (others => '1');
                    state   <= Receiving;
                --	
                when others =>
                    null;					
            end case;
            --
        end if;
    end process;
end architecture;