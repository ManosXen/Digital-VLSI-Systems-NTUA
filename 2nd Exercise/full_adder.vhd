library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
  Port ( 
    A, B, Cin: in std_logic;
    Sum, Cout: out std_logic);
end full_adder;

architecture Structural of full_adder is
component half_adder
        port(
            A, B: in std_logic;
            Sum, C: out std_logic
            );
    end component;
signal S1, C1, C2: std_logic;
begin
    ha1: half_adder port map(
        A=>A,
        B=>B,
        Sum=>S1,
        C=>C1 
    );
    ha2: half_adder port map(
            A=>Cin,
            B=>S1,
            Sum=>Sum,
            C=>C2 
        );
        Cout<=C1 or C2;

end Structural;
