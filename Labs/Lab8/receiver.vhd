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
entity receiver is
port(
        clk             :   IN  std_ulogic;
		receiver_in		:	IN	std_ulogic_vector(6 downto 0);
		receiver_out	:	OUT	std_ulogic_vector(3 downto 0);
		receiver_err	:	OUT	std_ulogic
	);
end entity;

-- architecture description

architecture behave of receiver is
    type    rState      is  (ParityComputation, s1, s2);
    signal  state       :   rState                          :=  ParityComputation;
    signal  correction  :   std_ulogic_vector(6 downto 0)   :=  (others => '0');
    signal  p4, p2, p1  :   std_ulogic                      :=  '0';
begin    
    
    correction      <=  channel_in(6 downto 0)  xor 
                        
    process(clk)
    begin
        if rising_edge(clk)
            case state is
                when ParityComputation
            end case;
        end if;
    end process;
        
    
    -- channel output (coded by Hamming 7,4)
    transmitter_out <=  count(3 downto 1)                                       -- d4, d3, d2
                    &   (channel_in(3)  xor channel_in(2)   xor channel_in(1))  -- p4
                    &   count(0)                                                -- d1
                    &   (channel_in(3)  xor channel_in(2)   xor channel_in(0))  -- p2
                    &   (channel_in(3)  xor channel_in(1)   xor channel_in(0)); -- p1      
end behave;