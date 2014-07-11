library IEEE;
use IEEE.std_logic_1164.all;

-- Buffer is implemented as a layer above the ps2bytestream.
-- It consumes flag bytes E0 and F0 and forwards strobe signal.
entity ps2buffer is
	port(		
		clk_50, strobe_in : in std_logic;
		data    : in std_logic_vector(7 downto 0);
		byte    : out std_logic_vector(7 downto 0);
		extended, released, strobe_out	: out std_logic
	);
end entity;

architecture PS2_BUFFER_ARC of ps2buffer is
	type rState	is (Receiving, Sending, Erasing);
	signal state	: rState := Receiving;
	signal buf		: std_logic_vector(7 downto 0) := (others => '1');
	signal ext, rel, stb    : std_logic := '0';
begin
	byte 	<= buf;
    
    extended    <= ext;
    released    <= rel;
    strobe_out  <= stb;

	process(clk_50)
	begin
		if rising_edge(clk_50) then
            case state is	
                when Receiving =>
                    if strobe_in = '1' then
                        if data = x"E0" then
                            ext <= '1';
                        elsif data = x"F0" then
                            rel <= '1';
                        else
                            buf <= data;
                            state <= Sending;
                        end if;
                    end if;
                when Sending =>
                    stb <= '1';
                    state <= Erasing;
                when Erasing =>
                    stb <= '0';
                    ext <= '0';
                    rel <= '0';
                    state <= Receiving;
                when others =>
                    null;
            end case;
		end if;
	end process;
end architecture;