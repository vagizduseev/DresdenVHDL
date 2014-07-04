library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timer is 
	port(
		clk			: in std_logic;
		led			: out std_logic_vector( 9 downto 0 )
	);	
end entity;

architecture timer_arc of timer is
	signal clock_counter : unsigned(25 downto 0) := (others => '0');
	signal shift : std_logic_vector(9 downto 0) := (0 => '1', others => '0');
begin

	process(clk)
	
	begin
		if rising_edge(clk) then
			clock_counter <= clock_counter + 1;
			if clock_counter = 50000000-1 then
				shift <= shift(8 downto 0) & shift(9);
				clock_counter <= (others => '0');
			end if;
		end if;
	end process;
	
	led <= shift;
	
end architecture;