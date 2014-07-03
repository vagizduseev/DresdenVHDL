library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdderTest is
end FullAdderTest;

architecture FA_TEST_ARC of FullAdderTest is
  signal ai, bi, ci_1, Si, ci : std_logic;
begin
  ci <= (bi and ci_1) or (ai and ci_1) or (ai and bi);
  Si <= (not ai and not bi and ci_1) or (not ai and bi and not ci_1) or (ai and not bi and not ci_1) or (ai and bi and ci_1);
  
  process
  begin
    ai <= '0'; -- a is zero
    bi <= '0';
    ci_1 <= '0';
      
    wait for 10 ns;
    ci_1 <= '1';
      
    wait for 10 ns;
    bi <= '1';
    ci_1 <= '0';
    
    wait for 10 ns;
    ci_1 <= '1';
      
    wait for 10 ns;
    ai <= '1'; -- a is one
    bi <= '0';
    ci_1 <= '0';
     
    wait for 10 ns;
    ci_1 <= '1';
    
    wait for 10 ns;
    bi <= '1';
    ci_1 <= '0';
     
    wait for 10 ns;
    ci_1 <= '1';
      
    wait;
  end process;
end architecture;
