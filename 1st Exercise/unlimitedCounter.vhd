library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity unlimitedCounter is
    port (
        clk : in std_logic;
        resetn: in std_logic;
        count_en : in std_logic;
        up : in std_logic;
        sum : out std_logic_vector(2 downto 0);
        cout : out std_logic
    );
end unlimitedCounter;

architecture rtl_nolimit of unlimitedCounter is
    signal count: std_logic_vector(2 downto 0);

begin
    process (clk, resetn)
    begin
        if resetn = '0' then
            -- Code for the reset condition (active low)
            count <= (others => '0');
        elsif clk'event and clk = '1' then
            if count_en = '1' then
                if up='1' then
                    count<=count+1;
                else 
                    count<=count-1;
                end if;
            end if;
        end if;
    end process;

    sum <= count;
    cout <= '1' when count = "111" and count_en = '1' else '0'; -- Changed count = 7 to count = "111"
end rtl_nolimit;