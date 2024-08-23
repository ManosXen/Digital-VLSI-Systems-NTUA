library IEEE;
use IEEE.std_logic_1164.all;

entity rshift_reg3 is
    port (
        clk,rst,si,en,pl, direction: in std_logic;
        din: in std_logic_vector(3 downto 0);
        storedValue : inout std_logic_vector(3 downto 0);
        so: out std_logic);
end rshift_reg3;

architecture rtl of rshift_reg3 is
    --signal dff: std_logic_vector(3 downto 0);
begin
    edge: process (clk,rst)
    begin
        if rst='0' then
            --dff<=(others=>'0');
            storedValue<=(others=>'0');
        elsif clk'event and clk='1' then
            if pl='1' then
                --dff<=din;
                storedValue<=din;
            elsif en='1' then
                case direction is
                    when '0' =>
                        --dff <= si & dff(3 downto 1);
                        storedValue<= si & storedValue(3 downto 1);
                    when '1' =>
                        --dff <= dff(2 downto 0) & si;
                        storedValue<= storedValue(2 downto 0) & si;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
    --so <= dff(0);
    so<=storedValue(0);
end rtl;