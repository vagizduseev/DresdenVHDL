library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.DE0_DISPLAY.all;

entity main is
	port(		
        clk_50, clk_kb, data_kb : in std_logic;
		dsp_out	    : out std_logic_vector(31 downto 0)    -- to de0display
	);
end entity;

architecture MAIN_ARC of main is
    signal local_numbers : input_numbers := (others => (others => '0'));
    signal local_display : displays := (others => (others => '1'));
    signal byte_stream   : std_logic_vector(7 downto 0) := (others => '0');
    signal byte_strobe   : std_logic := '0';
    
    signal key_scan_code : std_logic_vector(7 downto 0) := (others => '0');
    signal key_extended, key_released, key_strobe : std_logic := '0';
        
begin

    display : entity work.de0display
        port map(
            clk => clk_50,
            num => local_numbers,
            dsp => local_display
        );
        
    ps2str  : entity work.ps2bytestream
        port map(
            clk_kb => clk_kb,       -- in
            clk_50 => clk_50,       -- in
            data   => data_kb,      -- in (bit)
            byte   => byte_stream,  -- out (byte)
            strobe => byte_strobe   -- out (bit)
        );
        
    ps2buf  : entity work.ps2buffer
        port map(
            clk_50      => clk_50,      -- in
            strobe_in   => byte_strobe, -- in
            data        => byte_stream, -- in (byte)
            byte        => key_scan_code,--out (byte)
            extended    => key_extended,-- out
            released    => key_released,-- out
            strobe_out  => key_strobe
        );
        
    dsp_out(6 downto 0)     <= local_display(0);
    dsp_out(14 downto 8)    <= local_display(1);
    dsp_out(22 downto 16)   <= local_display(2);
    dsp_out(30 downto 24)   <= local_display(3);

    process(clk_50)
    begin
        if rising_edge(clk_50) then
            if key_strobe = '1' then
                if key_released = '0' then
                    case key_scan_code is
                        -- TODO: implement other key codes (extended and released too)
                        when x"70"  => local_numbers(0) <= to_unsigned(0, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"69"  => local_numbers(0) <= to_unsigned(1, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"72"  => local_numbers(0) <= to_unsigned(2, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"7A"  => local_numbers(0) <= to_unsigned(3, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"6B"  => local_numbers(0) <= to_unsigned(4, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"73"  => local_numbers(0) <= to_unsigned(5, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"74"  => local_numbers(0) <= to_unsigned(6, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"6C"  => local_numbers(0) <= to_unsigned(7, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"75"  => local_numbers(0) <= to_unsigned(8, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"7D"  => local_numbers(0) <= to_unsigned(9, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"5A"  => local_numbers(0) <= to_unsigned(14, 6);  -- Enter
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"79"  => local_numbers(0) <= to_unsigned(25, 6);  -- Plus
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"7C"  => local_numbers(0) <= to_unsigned(28, 6);  -- Star
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"4A"  => local_numbers(0) <= to_unsigned(21, 6);  -- Slash
                                       local_numbers(1) <= to_unsigned(28, 6); 
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when x"71"  => local_numbers(0) <= to_unsigned(13, 6);  -- Del
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                        when others => local_numbers(0) <= to_unsigned(0, 6);
                                       local_numbers(1) <= to_unsigned(0, 6);
                                       local_numbers(2) <= to_unsigned(0, 6);
                                       local_numbers(3) <= to_unsigned(0, 6);
                    end case;
                end if;
            end if; 
        end if;
    end process;
end architecture;