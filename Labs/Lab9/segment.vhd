library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Segment is
port(
    i : IN  unsigned (3 downto 0);
    o : OUT std_ulogic_vector (6 downto 0)
);
end entity Segment;

architecture behave of Segment is
begin
    with i select
        o   <=  "1000000" when x"0",    --0
                "1111001" when x"1",	--1
                "0100100" when x"2",	--2
                "0110000" when x"3",	--3
                "0011001" when x"4",	--4
                "0010010" when x"5",	--5
                "0000010" when x"6",	--6
                "1111000" when x"7",	--7
                "0000000" when x"8",	--8
                "0010000" when x"9",	--9
                "0111111" when x"A",    --'-'
                "1111111" when others;
end architecture behave;