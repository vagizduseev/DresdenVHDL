library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder is
  port(
      A, B, Cin : in std_logic;
      S, Cout : out std_logic
    );
end entity;

architecture FA_IMPL of FullAdder is
begin
  S <= A xor B xor Cin;
  Cout <= (A and B) or (Cin and (A xor B));
end architecture;