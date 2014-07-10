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
		receiver_in		:	IN	std_ulogic_vector(6 downto 0);
		receiver_out	:	OUT	std_ulogic_vector(3 downto 0);
		receiver_err	:	OUT	std_ulogic
	);
end entity;

-- architecture description

architecture behave of receiver is
    signal  p4, p2, p1  :   std_ulogic                      :=  '0';
begin    
    
    process(receiver_in)
        variable    syndrome    :   std_ulogic_vector(2 downto 0);
    begin
        syndrome(0) :=  receiver_in(0)  xor receiver_in(2)  xor receiver_in(4)  xor receiver_in(6);     -- p1
        syndrome(1) :=  receiver_in(1)  xor receiver_in(2)  xor receiver_in(5)  xor receiver_in(6);     -- p2
        syndrome(2) :=  receiver_in(3)  xor receiver_in(4)  xor receiver_in(5)  xor receiver_in(6);     -- p4

        if syndrome = "000" then    -- no errors
            receiver_err                <=  '0';
            receiver_out(3 downto 0)    <=  receiver_in(6 downto 4) & receiver_in(2); 
        else                        -- single bit error
            receiver_err                <=  '1';            
            case syndrome is
                when "001" | "010" | "100" =>   -- parity error
                    receiver_out    <=  receiver_in(6 downto 4) & receiver_in(2);
                when "011" =>
                    receiver_out    <=  receiver_in(6 downto 4) & (not receiver_in(2));
                when "101" =>
                    receiver_out    <=  receiver_in(6 downto 5) & (not receiver_in(4)) & receiver_in(2);
                when "110" =>
                    receiver_out    <=  receiver_in(6) & (not receiver_in(5)) & receiver_in(4) & receiver_in(2);
                when "111" =>
                    receiver_out    <=  (not receiver_in(6)) & receiver_in(5 downto 4) & receiver_in(2);    
                when others =>
                    null;
            end case;        
        end if;
        
    end process;
   
end behave;