library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity buttons is
	port(
		clk			: in std_logic,
		start			: in std_logic,
		restart		: in std_logic,
		btn_start	: out std_logic,
		btn_restart	: out std_logic
		);
end entity;

architecture debouncing_arc of buttons is	
	signal str_clk_cnt : unsigned( 17 downto 0 ) 	:= (others => '0');
	signal rst_clk_cnt : unsigned( 17 downto 0 ) 	:= (others => '0');
	signal btn_rst : std_logic := '0';
	signal btn_str : std_logic := '0';
begin
	btn_start 	<= btn_str;
	btn_restart <= btn_rst;
	process(clk)
	begin
		if rising_edge(clk) then
			-- Button start
			if start = '0' and str_clk_cnt < 150000 then
				str_clk_cnt <= str_clk_cnt + 1;
				if str_clk_cnt = 150000 - 1 then
					btn_str <= '1';					
				end if;
			elsif start = '1' then
				btn_str <= '0';				
				str_clk_cnt <= (others => '0');
			end if;
				-- Button restart
			if restart = '0' and rst_clk_cnt < 150000 then
				rst_clk_cnt <= rst_clk_cnt + 1;
				if rst_clk_cnt = 150000 - 1 then
					btn_rst <= '1';					
				end if;
			elsif restart = '1' then
				btn_rst <= '0';				
				rst_clk_cnt <= (others => '0');
			end if;
		end if;
	end process;
end architecture;