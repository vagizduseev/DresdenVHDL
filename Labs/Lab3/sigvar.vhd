library IEEE;
use IEEE.std_logic_1164.all;

entity sigvsvar is
end entity;

architecture sig of sigvsvar is
  signal a : std_logic := '0';
  signal b : std_logic := '1';
  signal c : std_logic := '0';
begin
  process
  begin
    wait for 5 ns;
    c <= a xor b;
    b <= a xor c;
    wait for 5 ns;
    c <= a xor b;
    b <= a xor c;
    wait;
  end process;
end architecture;

architecture var of sigvsvar is
  signal a : std_logic := '0';
  signal b : std_logic := '1';
begin
  process
    variable c : std_logic := '0';
  begin
    wait for 5 ns;
    c := a xor b;
    b <= a xor c;
    wait for 5 ns;
    c := a xor b;
    b <= a xor c;
    wait;
  end process;
end architecture;