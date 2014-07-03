entity data_types is
end data_types;

library IEEE;
use IEEE.std_logic_1164.all;
architecture data1 of data_types is
  signal a,b,c : std_logic;
begin
  process 
    begin
      wait for 10 ns;
      a <= '0';
      wait for 10 ns;
      a <= '1';
      wait;
    end process;
  
  process 
    begin
      wait for 5 ns;
      b <= '0';
      wait for 10 ns;
      b <= '1';
      wait;
    end process;
    
    c <= a and b;
      
end data1;