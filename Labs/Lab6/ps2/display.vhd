library IEEEE;
use IEEE.std_logic_1164.all;

entity display is
	port(
		clk	: in std_logic;
		num0, num1, num2, num3 	: in unsigned(3 downto 0);
		dsp0, dsp1, dsp2, dsp3	: out std_logic_vector(6 downto 0)
	);
end entity;

architecture DISPLAY_ARC of display is
	signal 
begin
	process(clk)
	begin
		
	end process;
end architecture;