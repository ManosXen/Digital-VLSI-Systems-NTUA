library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_Flip_Flop is
    Port ( 
    D, Clk: in std_logic;
    Q: out std_logic
    );
end D_Flip_Flop;

architecture Behavioral of D_Flip_Flop is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            Q<=D;
        end if;
    end process;
end Behavioral;
