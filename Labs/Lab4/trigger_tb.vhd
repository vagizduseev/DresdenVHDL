library IEEE;
use IEEE.std_logic_1164.all;

entity trigger_tb is
end entity;

library dresden_lab4;

architecture TRIGGER_TB_ARC of trigger_tb is
  signal event, reset, clock, trigger : std_logic;

begin
  
  -- Trigger
  trg_test : entity dresden_lab4.trigger(trigger_arc)
    generic map(THRESHOLD => 2)
    port map(
      clk => clock,
      rst => reset,
      evt => event,
      trg => trigger
    );

  -- Test statement
  assert trigger /= '1'
    report "Trigger has succesfuly emmited a signal";
    
  process
  begin
    report "Hello! Begin test";
    wait for 3 ns;
    
    report "Test started";
    clock <= '1';
    reset <= '1';
    wait for 5 ns;
    report "Reset commited";
    
    clock <= '0';
    reset <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #1
    event <= '1';
    clock <= '1';
    wait for 5 ns;
    report "Event!";
    
    clock <= '0';
    event <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #2
    event <= '1';
    clock <= '1';
    wait for 5 ns;
    report "Event!";
    
    event <= '0';
    clock <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
    
    -- Event #3
    event <= '1';
    clock <= '1';
    wait for 5 ns;
    report "Event!";
    
    event <= '0';
    clock <= '0';
    wait for 5 ns;
    report "Set clk to zero and wait";
        
    report "Now waiting for 10 ns";
    wait for 10 ns;
    report "Test complete";      
    wait;    
      
  end process;
  
end architecture;