library IEEE;
use IEEE.std_logic_1164.all;

entity trigger_tb is
end entity;

architecture TRIGGER_TB_ARC of trigger_tb is
  signal event, reset, clock, trigger : std_logic;
begin
  
  -- Trigger
  trg_test : trigger
    generic map(THRESHOLD => 3)
    port map(
      clk => clock,
      rst => reset,
      evt => event,
      trg => trigger
    );

  -- Test statement
  if trigger = '1' then
    report "Trigger has succesfuly emmited a signal";
  end if;
    
  process
  begin
    report "Hello! Begin test";
    wait for 3 ns;
    
    report "Test started";
    clock <= '1';
    reset <= '1';
    wait for 5 ns;
    report "Reset commited"
    
    clock <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #1
    clock <= '1';
    event <= '1';
    wait for 5 ns;
    
    clock <= '0';
    event <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #2
    clock <= '1';
    event <= '1';
    wait for 5 ns;
    
    clock <= '0';
    event <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #3
    clock <= '1';
    event <= '1';
    wait for 5 ns;
    
    clock <= '0';
    event <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
        
    report "Now waiting for 10 ns";
    wait for 10 ns;
    report "Test complete";      
    wait;    
      
  end process;
  
end architecture;