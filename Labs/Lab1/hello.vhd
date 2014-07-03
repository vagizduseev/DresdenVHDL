entity HELLO is
end HELLO;

architecture HELLO_1 of HELLO is
begin
  process
  begin
    report "Hello world, Hi" severity note;
    wait;
  end process;
  
  process
  begin
    wait for 0 ns;
    report "After nano seconds" severity note;
    wait;
  end process;
  
  process
  begin
    wait for 1 min;
    report "Bye world!" severity note;
    wait;
  end process;
end HELLO_1;
