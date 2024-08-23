library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MAC is
    Port (
        x, h: in std_logic_vector(7 downto 0);
        mac_init: in std_logic;
        clk: in std_logic;
        y: out std_logic_vector(17 downto 0)
    );
end MAC;

architecture Behavioral of MAC is
    signal sum: unsigned(17 downto 0) := (others => '0');
begin
    --y <= std_logic_vector(sum);

    process(clk)
    begin
        if rising_edge(clk) then
            if mac_init = '1' then
                sum <= "000000000000000000"+unsigned(x) * unsigned(h);
            else
                sum <= sum + unsigned(x) * unsigned(h);
            end if;
            y <= std_logic_vector(sum);
        end if;
    end process;

end Behavioral;
