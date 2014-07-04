library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collect is
  generic (
    BITS : positive
  );
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    vld   : in std_logic;
    
    din   : in std_logic;
    dout  : out std_logic_vector(BITS-1 downto 0);
    strb  : out std_logic
  );
end collect;

architecture COLLECT_ARC of collect is
  signal bitCounter : natural;
begin
  
  process(clk)
    variable strb_v : std_logic;
  begin
    if rising_edge(clk) then
      strb_v := '0';
      -- Synchronous reset
      if rst = '1' then      
        report "Take a look! bitCounter <= BITS-1";
        bitCounter <= BITS-1;
        strb_v := '0';
      end if;
      if vld = '1' then
        dout(bitCounter) <= din; 
        
        if bitCounter = 0 then
          report "Wow! We've reached the least significant bit!";
          strb_v := '1';
        else
          strb_v := '0';
          bitCounter <= bitCounter - 1;   
        end if;  
      end if;
      strb <= strb_v; 
    end if;
  end process;      
      
end architecture;