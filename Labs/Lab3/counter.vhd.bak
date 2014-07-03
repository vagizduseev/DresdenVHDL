entity data_types is
end data_types;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture data1 of data_types is
  signal parity : std_logic;
  signal counter : unsigned(9 downto 0);
  signal iounter : unsigned(9 downto 0);
  signal tounter : unsigned(10 downto 0);
  
begin

  parity  <= counter(0);
  iounter <= not counter;
  tounter <= (counter & '0') + counter; 
  
  process 
    begin
      counter <= "0000000000";
      wait for 10 ns;      
      counter <= counter + 1;

  end process;
    
end data1;
