library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
--use IEEE.math_real.all; -- import floor for real 
use IEEE.numeric_std.all; -- for type conversion to_unsigned

--library STD;
--use STD.textio.all;

--------------------------------------------------------------------------------
--!@file: parity.vhd
--!@brief: this is a simple parity de- and encoder
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Mon Feb  3 11:02:30 CET 2014 
--------------------------------------------------------------------------------

-- entity description
entity transmitter is
port(
		clk, rst		:	IN	std_ulogic;
		en				:	IN	std_ulogic;
		transmitter_out	:	OUT	std_ulogic_vector(6 downto 0)
	);
end entity;

-- architecture description

architecture behave of transmitter is
    signal count        :   std_ulogic_vector(3 downto 0)   :=  (others => '0');
    signal p1, p2, p4   :   std_ulogic                      :=  '0';
begin    
    -- counter
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- reset
                count   <=  (others => '0');
            elsif en = '1' then
                -- incrementing
                count   <=  std_ulogic_vector( unsigned(count) + 1 );
            end if;
        end if;
    end process;
    
    -- parity bits calculation
    p1  <=  (count(3)  xor count(1))   xor count(0);
    p2  <=  (count(3)  xor count(2))   xor count(0);
    p4  <=  (count(3)  xor count(2))   xor count(1);
    
    -- encoded word output
    transmitter_out(6 downto 4) <=  count(3 downto 1);
    transmitter_out(3)          <=  p4;
    transmitter_out(2)          <=  count(0);
    transmitter_out(1)          <=  p2;   
    transmitter_out(0)          <=  p1;   
    
end behave;