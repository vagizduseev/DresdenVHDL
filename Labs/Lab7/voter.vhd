library IEEE;
use IEEE.std_logic_1164.all; -- import std_logic types
use IEEE.numeric_std.all; -- for type conversion to_unsigned

entity voter is
    port(
        q1  :   IN  std_ulogic_vector(3 downto 0);
        q2  :   IN  std_ulogic_vector(3 downto 0);
        q3  :   IN  std_ulogic_vector(3 downto 0);
        o   :   OUT std_ulogic_vector(3 downto 0)
    );
end entity;

architecture behave of voter is
begin
    process (q1, q2, q3)
    begin
        o   <=  (q1 and q2) or (q2 and q3) or (q1 and q3);
    end process;
end architecture;