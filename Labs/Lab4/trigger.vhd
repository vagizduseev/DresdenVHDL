library IEE;
use IEEE.std_logic_1164.all;
entity trigger is
  generic (
    THRESHOLD : positive
  );
  port(
    clk : in  std_logic;
    rst : in  std_logic;
    evt : in  std_logic;
    trg : out std_logic;
  );
end trigger;

architecture counter of trigger is
  
begin 
  
  process(clk, rst)
  begin
    if rst = '1' then
      ...
    else 
        if( evt='1' )
         begin
         end 
        end if 
      end  
   end if;
  end process; 
    
end architecture;