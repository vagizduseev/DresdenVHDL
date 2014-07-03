library IEEE;
use IEEE.std_logic_1164.all;

entity WaveComparison2 is
end entity;

architecture WC_ARC_2 of WaveComparison2 is
  signal a1, a2 : std_logic;
begin
  
  a1 <= '0', not a1 after 5 ns;
  
  -- Process
  process
  begin
    a2 <= '0';
    wait for 5 ns;
    a2 <= not a2;
    wait; -- forever
  end process;
  
end architecture;  