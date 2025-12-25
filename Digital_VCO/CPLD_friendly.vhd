library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vco is
    port (
        clk          : in  std_logic;                     -- 3.5 kHz onboard clock
        control_freq : in  std_logic_vector(2 downto 0);  -- DIP switches
        range_sel    : in  std_logic;                     -- range selector switch
        vco_out      : out std_logic                      -- square wave output
    );
end entity;

architecture rtl of vco is

    -- CPLD-friendly registers
    signal counter : unsigned(11 downto 0) := (others => '0');
    signal limit   : unsigned(11 downto 0) := (others => '0');
    signal out_reg : std_logic := '0';

begin

    vco_out <= out_reg;

    -- Frequency selection (REGISTERED → HARDWARE SAFE)
    process(clk)
        variable base_limit : unsigned(11 downto 0);
    begin
        if rising_edge(clk) then

            case control_freq is
                when "000" => base_limit := to_unsigned(5,   12);
                when "001" => base_limit := to_unsigned(10,  12);
                when "010" => base_limit := to_unsigned(20,  12);
                when "011" => base_limit := to_unsigned(40,  12);
                when "100" => base_limit := to_unsigned(80,  12);
                when "101" => base_limit := to_unsigned(160, 12);
                when "110" => base_limit := to_unsigned(320, 12);
                when "111" => base_limit := to_unsigned(640, 12);
                when others => base_limit := to_unsigned(5, 12);
            end case;

            if range_sel = '1' then
                limit <= base_limit + base_limit;  -- ×2
            else
                limit <= base_limit;
            end if;

        end if;
    end process;
          
    -- Counter + Toggle Flip-Flop
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = limit then
                counter <= (others => '0');
                out_reg <= not out_reg;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

end architecture;
