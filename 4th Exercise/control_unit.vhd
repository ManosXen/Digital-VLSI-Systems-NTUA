library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
  Port ( 
  clk, rst, valid_in: in std_logic;
  rom_address, ram_address: out std_logic_vector(2 downto 0);
  mac_init, valid_out: out std_logic;
  cycle8: out std_logic
    );
end control_unit;

architecture Behavioral of control_unit is
    component N_D_Flip_Flop is
        generic (
            N: integer :=7
        );
        Port ( 
            x, clk: in std_logic;
            y: out std_logic
        );
    end component;
    signal counter: unsigned(2 downto 0) := (others => '0');
    signal prev_valid_in: std_logic :='0';
    signal valid_out_d: std_logic;
begin
    uut: N_D_Flip_Flop generic map(9) port map(valid_out_d, clk, valid_out);
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                counter<="000";
                rom_address<="111";
                mac_init<='1';
                valid_out_d<='0';
                cycle8<='0';
            else
                if counter=1 then
                    mac_init<='1';
                    cycle8<='0';
                    rom_address<="110";
                    ram_address<="001";
                    valid_out_d<='0';
                    counter<=counter+1;
                else
                    mac_init<='0';
                    valid_out_d<='0';
                    if prev_valid_in='1' and valid_in='0' then
                        prev_valid_in<='0';
                    end if;
                    if counter=0 and valid_in='1' and prev_valid_in<='0' then 
                        cycle8<='1';
                        prev_valid_in<='1';
                        valid_out_d<='1';
                    end if;
                    ram_address<=std_logic_vector(counter);
                    rom_address<=std_logic_vector(7-counter);
                    if counter=7 then
                        counter<="000";
                    elsif counter=0 and valid_in='0' then
                        counter<="000";
                    else 
                        counter<=counter+1;
                    end if;
                end if;
      end if;
      end if;
   end process;
end Behavioral;
