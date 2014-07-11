library ieee;
use ieee.std_logic_1164.all;

entity Segment is
port(
    i : IN  unsigned (3 downto 0);
    o : OUT std_ulogic_vector (6 downto 0)
);
end entity Segment;

architecture behave of Segment is
begin
    with i select
        o   <=  "1000000" when 0,   --0
                "1111001" when 1,	--1
                "0100100" when 2,	--2
                "0110000" when 3,	--3
                "0011001" when 4,	--4
                "0010010" when 5,	--5
                "0000010" when 6,	--6
                "1111000" when 7,	--7
                "0000000" when 8,	--8
                "0010000" when 9,	--9
                "0111111" when 10,  --'-'
                "1111111" when others;
end architecture behave;