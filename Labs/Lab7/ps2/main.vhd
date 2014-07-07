library IEEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main is
	port (
		clk		: in std_logic,
		clk_key	: in std_logic,
		data		: in std_logic,
		display	: out std_logic_vector(6 downto 0)
	);
end entity;

architecture arc_main of main is
	signal d1, d2 : d-flip-flop;
	signal shift-register : shift-register(8 downto 0);
begin
	process(clk)
	begin
	
		if rising_edge(clk) then
			bit_counter <= state;
			state <= '1';
			if clk_key = '0' and data = '0' then 
				prv_key_clk <= '0';
				state <= receive;
			end if;
			if clk_key = '1' then
				prv_key_clk <= '1';
			elsif prv_key_clk ='1' then
				
				
			
		when others =>
			null;
		end case;
	end process;
end architecture;