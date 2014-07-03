library IEEE;
use IEEE.std_logic_1164.all;

entity rca_func is
  generic(
    N : positive
  );
  port(
    carry_in : in std_logic;
    word_1, word_2 : in std_logic_vector(N-1 downto 0);
    carry_out : out std_logic;
    summ : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture RCA_FUNC_ARC of rca_func is
    
  type tFaRes is record
    c : std_logic; -- Carry bit
    s : std_logic; -- Summ bit
  end record;

  function faFunc(a, b, c : std_logic) return tFaRes is
    variable res : tFaRes;
  begin
    res.c := (a and b) or (c and (a xor b));
    res.s := a xor b xor c;
    return res;
  end faFunc;
  
begin

  process(carry_in, word_1, word_2) -- stimuli list
  -- canging of any operand in the stimule list causes the process to rerun
    variable res : tFaRes;
    variable cout : std_logic;
    begin
    cout := carry_in;
    for i in 0 to N-1 loop
     res := faFunc(word_1(i), word_2(i), cout);
     cout := res.c;
     summ(i) <= res.s;
    end loop;
    carry_out <= cout;
  end process;
    
end architecture;