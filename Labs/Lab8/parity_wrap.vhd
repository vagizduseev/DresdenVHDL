library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.std_logic_arith.all; -- import add/sub of std_logic_vector
use IEEE.std_logic_unsigned.all;
--use IEEE.math_real.all; -- import floor for real 
--use IEEE.numeric_std.all; -- for type conversion to_unsigned

--library STD;
--use STD.textio.all;

--------------------------------------------------------------------------------
--!@file: parity_wrap.vhd
--!@brief: this is the top wrapper for the parity example lab
--
--!@author: Tobias Koal(TK)
--!@revision info :
-- last modification by tkoal(TK)
-- Mon Feb  3 11:02:30 CET 2014 
--------------------------------------------------------------------------------

-- entity description

entity parity_wrap is
port(
		clk, rst		    :	IN	std_ulogic;
		seg_sender_out	    :	OUT	std_ulogic_vector(6 downto 0);
		seg_receiver_out	:	OUT	std_ulogic_vector(6 downto 0);
		receiver_err	    :	OUT std_ulogic;
		error_in		    :	IN	std_ulogic_vector(6 downto 0);
		error_out 	        :	OUT std_ulogic_vector(6 downto 0)
);
end entity;

-- architecture description

architecture behave of parity_wrap is

	signal s_en		:	std_ulogic;	
	signal channel_in, channel_out		:	std_ulogic_vector(6 downto 0);	
	signal s_receiver_out				:	std_ulogic_vector(3 downto 0);
    signal s_sender_out                 :   std_ulogic_vector(3 downto 0);

begin
	
	-- clk div process
	clk_div	:	process(clk,rst)
		constant MAX_COUNT	:	integer	:=	100000000;
		variable count		:	integer;
	begin
		if rst = '1' then
			count	:= 0;
			s_en	<=	'0';
		elsif rising_edge(clk) then
			if count < MAX_COUNT then
				count 	:=	count + 1;
				s_en	<=	'0';
			else
				count 	:=	0;
				s_en	<=	'1';
			end if;
		end if;
	end process;
	
	
	-- entity to implement
	parity_sys : entity work.parity(behave)
	port map (
        clk				=>	clk,
        rst				=>	rst,
        en				=>	s_en,
        channel_in		=>	channel_in,
        channel_out		=>	channel_out,
        receiver_out	=>	s_receiver_out,
        receiver_err	=>	receiver_err
	);
	
	-- corrupt channel
	channel_out     <=	channel_in	xor	error_in;
	error_out       <=	error_in;
    
    -- sender output
    s_sender_out	<=  channel_in(6 downto 4) & channel_in(2);
	
	-- this is the 7 segment decoder
	seg_send_reg	:	entity work.segment(behave)
	port map(
        i	=>	s_sender_out,
        o	=>	seg_sender_out
	);
	
	-- this is the 7 segment decoder
	seg_receive_reg	:	entity work.segment(behave)
	port map(
        i	=>	s_receiver_out,
        o	=>	seg_receiver_out
	);
	
	
end behave;
