library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity N_D_Flip_Flop is
    generic (
        N: integer :=7
    );
    Port ( 
        x, clk: in std_logic;
        y: out std_logic
    );
end N_D_Flip_Flop;

architecture Behavioral of N_D_Flip_Flop is
    component D_Flip_Flop is
    Port ( 
        D, Clk: in std_logic;
        Q: out std_logic
    );
end component;
    signal c: std_logic_vector(N+1 downto 0);
begin
    c(0)<=x;
    y<=c(N+1);
    G_1: for i in 0 to N generate
        DFF: D_Flip_Flop port map(c(i), clk, c(i+1));
    end generate; 

end Behavioral;
