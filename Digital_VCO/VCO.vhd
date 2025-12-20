library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vco is
    port (
        clk          : in  std_logic;
        control_freq : in  std_logic_vector(2 downto 0);
        range_sel    : in  std_logic;
        vco_out      : out std_logic
    );
end entity;

architecture rtl of vco is

    signal counter : unsigned(31 downto 0) := (others => '0'); -- for low freq
    signal out_reg : std_logic := '0';
    signal N       : unsigned(31 downto 0);

begin

    vco_out <= out_reg;

    -- Frequency Selector using lookup table
    process(control_freq, range_sel)
        variable N_temp : unsigned(31 downto 0);
    begin
        case control_freq is
            when "000" => N_temp := to_unsigned(1, 32);         -- 500 kHz
            when "001" => N_temp := to_unsigned(2, 32);         -- 250 kHz
            when "010" => N_temp := to_unsigned(4, 32);         -- 125 kHz
            when "011" => N_temp := to_unsigned(8, 32);        -- 62.5 kHz
            when "100" => N_temp := to_unsigned(16, 32);        -- 31.25 kHz
            when "101" => N_temp := to_unsigned(32, 32);        -- 15.625 kHz
            when "110" => N_temp := to_unsigned(64, 32);       -- 7.8125 kHz
            when "111" => N_temp := to_unsigned(128, 32);       -- 3.90625 kHz
            when others => N_temp := to_unsigned(2, 32);
        end case;

        if range_sel = '1' then
            N <= resize(N_temp * to_unsigned(1000, 32), 32);  -- convert KHz to Hz
        else
            N <= N_temp;
        end if;
    end process;

    -- Counter + Toggle Flip-Flop
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = N - 1 then
                counter <= (others => '0');  -- reset counter
                out_reg <= not out_reg;      -- toggle output
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end architecture;