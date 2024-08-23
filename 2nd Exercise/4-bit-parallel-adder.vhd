library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity parallel_adder_4_bit is
    Port ( 
    A, B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(3 downto 0);
    Cout: out std_logic
    );
end parallel_adder_4_bit;

architecture Structural of parallel_adder_4_bit is
    component full_adder is
      Port ( 
        A, B, Cin: in std_logic;
        Sum, Cout: out std_logic);
    end component;
    signal carry: std_logic_vector(2 downto 0);
begin
    fa1: full_adder port map(
        A => A(0),
        B => B(0),
        Cin=>Cin,
        Sum => Sum(0),
        Cout=>carry(0)
   );
   
   fa2: full_adder port map(
           A => A(1),
           B => B(1),
           Cin=>carry(0),
           Sum => Sum(1),
           Cout=>carry(1)
      );
      
   fa3: full_adder port map(
                 A => A(2),
                 B => B(2),
                 Cin=>carry(1),
                 Sum => Sum(2),
                 Cout=>carry(2)
            );
            
   fa4: full_adder port map(
                       A => A(3),
                       B => B(3),
                       Cin=>carry(2),
                       Sum => Sum(3),
                       Cout=>Cout
                  );

end Structural;
