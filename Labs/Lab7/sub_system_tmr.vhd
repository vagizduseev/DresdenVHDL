library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.numeric_std.all; -- for type conversion to_unsigned

--------------------------------------------------------------------------------
--!@file: sub_system_tmr.vhd
--!@brief: this is a simple 4 bit register with enable signal
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Sat May  3 00:18:20 CEST 2014 
--------------------------------------------------------------------------------

-- entity description

entity sub_system_tmr is
port(
		clk				:	IN	std_ulogic;
		rst				:	IN	std_ulogic;
		en1, en2, en3	:	IN	std_ulogic;
		q1, q2, q3		:	OUT	std_ulogic_vector(3 downto 0)
);
end entity;

-- architecture description

architecture behave of sub_system_tmr is
    signal vi1, vi2, vi3    :   std_ulogic_vector(3 downto 0)    :=  (others => '0');
    signal vo1, vo2, vo3    :   std_ulogic_vector(3 downto 0)    :=  (others => '0');
begin
	
    -- registers outputs bound to the output signals
    q1  <=  vi1;
    q2  <=  vi2;
    q3  <=  vi3;
    
    -- unit 1
    u1_reg  :   entity work.counter
        port map(
            clk =>  clk,
            rst =>  rst,
            en  =>  en1,
            i   =>  vo1,
            o   =>  vi1
        );
    u1_vot  :   entity work.voter
        port map(
            q1  =>  vi1,
            q2  =>  vi2,
            q3  =>  vi3,
            o   =>  vo1
        );
    
    -- unit 2
    u2_reg  :   entity work.counter
        port map(
            clk =>  clk,
            rst =>  rst,
            en  =>  en2,
            i   =>  vo2,
            o   =>  vi2
        );
    u2_vot  :   entity work.voter
        port map(
            q1  =>  vi1,
            q2  =>  vi2,
            q3  =>  vi3,
            o   =>  vo2
        );
    
    -- unit 3
    u3_reg  :   entity work.counter
        port map(
            clk =>  clk,
            rst =>  rst,
            en  =>  en3,
            i   =>  vo3,
            o   =>  vi3
        );
    u3_vot  :   entity work.voter
        port map(
            q1  =>  vi1,
            q2  =>  vi2,
            q3  =>  vi3,
            o   =>  vo3
        );
    
end behave;
















