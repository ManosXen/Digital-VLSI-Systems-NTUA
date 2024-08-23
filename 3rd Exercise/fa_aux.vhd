library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fa_aux is
  Port ( 
  Sin, A, B, Cin: in std_logic;
  Sout, Cout: out std_logic
  );
end fa_aux;

architecture Behavioral of fa_aux is
    component full_adder is
      Port ( 
      A, B, Cin: in std_logic;
      Sum, Cout: out std_logic
      );
    end component;
    signal A_and_B : std_logic;
begin
    A_and_B <= A and B;
    fa: full_adder port map(
        A=>Sin,
        B=>A_and_B,
        Cin=>Cin,
        Sum=>Sout,
        Cout=>Cout
    );

end Behavioral;
