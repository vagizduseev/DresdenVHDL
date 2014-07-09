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

entity sub_system_tmr_wrap is
port(
		clk						:	IN	std_ulogic;
		rst						:	IN	std_ulogic;
		err_in					:	IN	std_ulogic_vector(0 to 2);
		err_out					:	OUT	std_ulogic_vector(0 to 2);
		seg1, seg2, seg3		:	OUT	std_ulogic_vector(6 downto 0)
);
end entity;

-- architecture description

architecture behave of sub_system_tmr_wrap is
	
	signal s_en				:	std_ulogic;
	signal reg1, reg2, reg3	:	std_ulogic_vector(3 downto 0);
	signal en1, en2, en3	:	std_ulogic;
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
	
	-- inject permanent faults on enable signal of the register
	en1	<= 	s_en when err_in(0) = '0' else
			'0';
	
	en2	<= 	s_en when err_in(1) = '0' else
			'0';
	
	en3	<= 	s_en when err_in(2) = '0' else
			'0';
			
	-- map err in to output
	err_out	<=	err_in;
			
	-- this is the sub system tmr component
	sub_sys	:	entity work.sub_system_tmr(behave)
	port map(
				clk	=>	clk,
				rst	=>	rst,
				en1	=>	en1,
				en2	=>	en2,
				en3	=>	en3,
				q1	=>	reg1,
				q2	=>	reg2,
				q3	=>	reg3
	);	
	
	-- this is the 7 segment decoder
	seg_1	:	entity work.segment(behave)
	port map(
				i	=>	reg1,
				o	=>	seg1
	);
	
	-- this is the 7 segment decoder
	seg_2	:	entity work.segment(behave)
	port map(
				i	=>	reg2,
				o	=>	seg2
	);
	
	-- this is the 7 segment decoder
	seg_3	:	entity work.segment(behave)
	port map(
				i	=>	reg3,
				o	=>	seg3
	);
end behave;
















