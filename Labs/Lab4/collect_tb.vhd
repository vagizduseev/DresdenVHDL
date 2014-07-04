library IEEE;
use IEEE.std_logic_1164.all;

entity collect_tb is
end entity;

library dresden_lab4;

architecture COLLECT_TB_ARC of collect_tb is
  constant N : positive := 4;
  signal clock, reset, valid, dinput, strobe : std_logic;
  signal doutput, word : std_logic_vector(N-1 downto 0);

begin
  
  -- Trigger
  col_test : entity dresden_lab4.collect(COLLECT_ARC)
    generic map(BITS => N)
    port map(
      clk => clock,
      rst => reset,      
      vld => valid,
      din => dinput,
      dout => doutput,
      strb => strobe
    );

  -- Test statement
  assert strobe /= '1'
    report "Bus has succesfuly emitted a strobe signal";
    
  process
  begin
    reset   <= '1';
    clock   <= '0';
    report "Hello! Begin test";
    wait for 3 ns;
    
    clock <= '1';
    valid <= '0';
    word(N-1 downto 0) <= "1011";
    wait for 5 ns;
    report "Reset done and Word initialized";
    
    reset <= '0';
    clock <= '0';
    valid <= '1';
    wait for 5 ns;
    report "Ready to read";
    
    for i in N-1 downto 0 loop
      report "Bit!";
      dinput  <= word(i);
      clock   <= '1';
      wait for 5 ns;
      clock <= '0';
      wait for 5 ns;
    end loop; 
    
    valid <= '0';    
    report "Now waiting for 10 ns";
    wait for 10 ns;
    report "Test complete";      
    wait;    
      
  end process;
  
end architecture;