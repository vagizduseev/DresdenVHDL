library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity trigger is
  generic (
    THRESHOLD : positive
  );
  port(
    clk : in std_logic;
    rst : in std_logic;
    evt : in std_logic;
    trg : out std_logic
  );
end trigger;

architecture TRIGGER_ARC of trigger is
  signal eventCounter : natural;
begin
  
  process(clk)                          -- ONLY inputs that may
  begin                                 -- induce a state transition.
    if rising_edge(clk) then     -- Positive clock edge.
      -- Synchronous reset
      if rst = ?1? then                 
        --eventCounter <= ?0?;
      end if;
--      -- Event counter
--      if evt = '1' then
--        eventCounter <= eventCounter + 1;
--        -- Assert the trg signal whenever THRESHOLD is reached
--        if eventCounter = THRESHOLD then
--          trg <= '1';
--        else
--          trg <= '0';
--        end if; -- end Trg assertion          
--      end if; --end Event counter
    end if; -- end Clk event
  end process;
      
end architecture;