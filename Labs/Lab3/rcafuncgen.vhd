library IEEE;
use IEEE.std_logic_1164.all;

entity RCAFuncGen is
  generic(
    N : positive
  );
  port(
    carry_in        : in std_logic;
    word_1, word_2  : in std_logic_vector(N-1 downto 0);
    carry_out       : out std_logic;
    summ            : out std_logic_vector(N-1 downto 0)
  );
end entity;

architecture rca_func_gen_arc of RCAFuncGen is
          
  type tFaRes is record
    c : std_logic; -- Carry bit
    s : std_logic; -- Summ bit
  end record;

  function faFunc(a, b, c : std_logic) return tFaRes is
    variable res : tFaRes;
  begin
    res.c := (a and b) or (c and (a xor b));
    res.s := a xor b xor c;
    return  res;
  end faFunc;
  
  signal cout : std_logic_vector(N downto 0);  
  
begin 
  
  cout(0) <= carry_in;    
  rca_fun_gen : for i in 0 to N-1 generate
    signal res : tFaRes;
  begin  
    res       <= faFunc(word_1(i), word_2(i), cout(i));
    cout(i+1) <= res.c;
    summ(i)   <= res.s;
  end generate;
  carry_out <= cout(N); 
         
end architecture;
