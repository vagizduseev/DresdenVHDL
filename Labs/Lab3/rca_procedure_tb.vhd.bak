library IEEE;
use IEEE.std_logic_1164.all;

entity rca_procedure_tb is
end entity;

architecture RCA_PROCEDURE_TB_ARC of rca_procedure_tb is
  signal arg1, arg2, summ : std_logic_vector(1 to 4);
  signal carry_in, carry_out : std_logic;
begin
      
  -- Ripple Carry Adder implemented as a procedure
  rca_func_test : entity work.rca_procedure
      generic map(N => 4)
      port map(
        carry_in => carry_in,
        carry_out => carry_out,
        word_1 => arg1,
        word_2 => arg2,
        summ => summ
      );
    
  process
  begin
    report "Hello! Begin test";
    wait for 3 ns;
       
    -- Test 1 func
    report "Test 1 start";
    carry_in <= '0';
    arg1 <= "1111";
    arg2 <= "0001";
    report "Now waiting for 10 ns";
    wait for 10 ns;
    report "Now checking assertion";
    assert summ = "0000" and carry_out = '1'
      report "Adder error in test 1"
      severity error;
    report "Test_1_complete";
            
    -- Test 2 func
    report "Test 2 start";
    carry_in <= '1';
    arg1 <= "0101";
    arg2 <= "0101";
    report "Now waiting for 10 ns";
    wait for 10 ns;
    report "Now checking assertion";
    assert summ = "1011" and carry_out = '0'
      report "Adder error in test 2"
      severity error;
    report "Test_2_complete";
      
    wait;
      
  end process;
end architecture;