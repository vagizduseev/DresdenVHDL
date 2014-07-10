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
entity parity is
port(
		clk, rst		:	IN	std_ulogic;
		en				:	IN	std_ulogic;
		channel_in		:	OUT	std_ulogic_vector(6 downto 0);
		channel_out		:	IN	std_ulogic_vector(6 downto 0);
		receiver_out	:	OUT	std_ulogic_vector(3 downto 0);
		receiver_err	:	OUT	std_ulogic
	);
end entity;

-- architecture description

architecture behave of parity is
    signal count    :   std_ulogic_vector(3 downto 0)   :=  (others => '0');
begin
    
    transmitter_sys :   entity  work.transmitter(behave)
    port map(
        clk             =>  clk,
        rst             =>  rst,
        en              =>  en,
        transmitter_out =>  channel_in
    );
    
    receiver_sys    :   entity  work.receiver(behave)
    port map(
        receiver_in     =>  channel_out,
        receiver_err    =>  receiver_err,
        receiver_out    =>  receiver_out
    );
    
end behave;
