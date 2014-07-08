library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock is
	port(
		clk			: in std_logic,
		btn_start	: in std_logic,
		btn_restart	: in std_logic,
		msc			: out unsigned(19 downto 0),
		dsp_state	: out std_logic
		);
end entity;
		
architecture arc_main of clock is
	type tState is (Restart, Running, Pause);
	signal state 			: tState := Restart;
	signal clk_counter	: unsigned(15 downto 0) := (others => '0');
	signal msc_counter 	: unsigned(19 downto 0) := (others => '0');
	
begin
	msc <= msc_counter;
	dsp_restart <= btn_restart;
	
	process(clk)
	begin
		if rising_edge(clk) then
			case state is
				when Restart =>
					clk_counter	<= (others => '0');
					msk_counter	<= (others => '0');
					if rising_edge(btn_start) then
						state <= Running;
					end if;
				when Running =>
					if clock_counter = 50000-1 then
						clock_counter	<= (others => '0');
						if msc_counter < 600000-1 then
							msc_counter	<= msc_counter +1;
						end if;
					else
						clock_counter  <= clock_counter+1;
					end if;				
					
					if rising_edge(btn_restart) then
						state <= Restart;
					elsif rising_edge(btn_start) then
						state <= Pause;
					end if;
				when Pause 	 =>
					if rising_edge(btn_restart) then
						state <= Restart;
					elsif rising_edge(btn_start) then
						state <= Running;
					end if;
				when others  =>
					null;
			end case;
		end if;
	end process;
end architecture;
