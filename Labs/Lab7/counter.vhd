library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.numeric_std.all; -- for type conversion to_unsigned

entity counter is
    port(
        clk :   IN  std_ulogic;
        rst :   IN  std_ulogic;
        en  :   IN  std_ulogic;
        i   :   IN  std_ulogic_vector(3 downto 0);
        o   :   OUT std_ulogic_vector(3 downto 0)
    );
end entity;

architecture behave of counter is
    signal  count   : std_ulogic_vector(3 downto 0) :=  (others => '0');
    signal  reg     : std_ulogic_vector(3 downto 0) :=  (others => '0');
begin
    
    -- register value bound to the output
    o   <=  reg;
    
    -- incrementing unit (combinational process)
    count   <=  std_ulogic_vector( unsigned(i) + 1 );  
    
    -- register process (sequential process)
	process(clk)
	begin
		if rising_edge(clk) then    
            if rst = '1' then
                reg <=  (others => '0');
            elsif en = '1' then
                reg <=  count;
            end if;
		end if;
	end process;
    
end architecture;