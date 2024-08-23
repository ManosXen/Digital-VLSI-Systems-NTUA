library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity upCounterWithLimiter is
    port( 
        clk,
        resetn,
        count_en : in std_logic;
        sum : out std_logic_vector(2 downto 0);
        cout : out std_logic;
        limit: in std_logic_vector(2 downto 0));
end upCounterWithLimiter;

architecture Behavioral of upCounterWithLimiter is
signal count: std_logic_vector(2 downto 0);
begin
    process(clk, resetn)
    begin
        if resetn='0' then
            count <= (others=>'0');
        elsif clk'event and clk='1' then
            if count_en='1' then
                if count/=limit then
                    count<=count+1;
                else
                    count<=(others => '0');
                end if;   
            end if;
        end if;
    end process;
    sum <= count;
    cout <= '1' when count="111" and count_en='1' else '0';

end Behavioral;
