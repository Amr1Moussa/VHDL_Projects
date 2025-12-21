library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_vco is
-- Testbench has no ports
end tb_vco;

architecture sim of tb_vco is

    -- Signals to connect to the VCO
    signal clk          : std_logic := '0';
    signal control_freq : std_logic_vector(2 downto 0) := "000";
    signal range_sel    : std_logic := '0';
    signal vco_out      : std_logic;

    -- Clock period for 1 MHz
    constant clk_period : time := 1 us;

begin

    -- Instantiate the VCO
    uut: entity work.vco
        port map(
            clk => clk,
            control_freq => control_freq,
            range_sel => range_sel,
            vco_out => vco_out
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Test all control_freq values with range_sel = '0' (KHz)
        for i in 0 to 7 loop
            control_freq <= std_logic_vector(to_unsigned(i,3));
            range_sel <= '0';
            wait for 100 us; -- wait enough to see multiple output cycles
        end loop;

        -- Test all control_freq values with range_sel = '1' (Hz)
        for i in 0 to 3 loop
            control_freq <= std_logic_vector(to_unsigned(i,3));
            range_sel <= '1';
            wait for 20 ms; -- wait longer for low frequencies
        end loop;

        for i in 4 to 7 loop
            control_freq <= std_logic_vector(to_unsigned(i,3));
            range_sel <= '1';
            wait for 40 ms; -- wait longer for low frequencies
        end loop;
		  
        -- Stop simulation
        wait;
    end process;

end architecture;
