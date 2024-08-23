library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aux_4_bit_adder is
  Port ( 
  A, Sin: in std_logic_vector(3 downto 0);
  B: in std_logic;
  Sum: out std_logic_vector(3 downto 0);
  Cout: out std_logic
  );
end aux_4_bit_adder;

architecture Behavioral of aux_4_bit_adder is
    component fa_aux is
      Port ( 
      Sin, A, B, Cin: in std_logic;
      Sout, Cout: out std_logic
      );
    end component;
    signal intermediateC: std_logic_vector(2 downto 0);
begin
    fa_aux0: fa_aux port map(
        Sin=>Sin(0),
        A=>A(0),
        B=>B,
        Cin=>'0',
        Sout=>Sum(0),
        Cout=>intermediateC(0)
     );
     
     fa_aux1: fa_aux port map(
             Sin=>Sin(1),
             A=>A(1),
             B=>B,
             Cin=>intermediateC(0),
             Sout=>Sum(1),
             Cout=>intermediateC(1)
          );
          
      fa_aux2: fa_aux port map(
                  Sin=>Sin(2),
                  A=>A(2),
                  B=>B,
                  Cin=>intermediateC(1),
                  Sout=>Sum(2),
                  Cout=>intermediateC(2)
               );
      
      fa_aux3: fa_aux port map(
                       Sin=>Sin(3),
                       A=>A(3),
                       B=>B,
                       Cin=>intermediateC(2),
                       Sout=>Sum(3),
                       Cout=>Cout
                    );
     

end Behavioral;
