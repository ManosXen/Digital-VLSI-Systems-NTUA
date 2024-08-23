library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_parallel_4_digit is
    Port ( 
    A, B: in std_logic_vector(15 downto 0);
    Sum: out std_logic_vector(15 downto 0);
    Cout: out std_logic
    );
end bcd_parallel_4_digit;

architecture Structural of bcd_parallel_4_digit is
    component bcd_fa is
      Port ( 
          A, B: in std_logic_vector(3 downto 0);
          Cin: in std_logic;
          DecimalUnits: out std_logic_vector(3 downto 0);
          C: inout std_logic
      );
    end component;
    
    signal carry: std_logic_vector(3 downto 0);
begin
    bcd_1: bcd_fa port map(
        A=>A(3 downto 0),
        B=>B(3 downto 0),
        Cin=>'0',
        DecimalUnits=> Sum(3 downto 0),
        C=> carry(0)
        );
        
     bcd_2: bcd_fa port map(
        A=>A(7 downto 4),
        B=>B(4 downto 5),
        Cin=>carry(0),
        DecimalUnits=> Sum(7 downto 4),
        C=> carry(1)
        );
      
      bcd_3: bcd_fa port map(
        A=>A(11 downto 8),
        B=>B(11 downto 8),
        Cin=>carry(1),
        DecimalUnits=> Sum(11 downto 8),
        C=> carry(2)
        );
        
      bcd_4: bcd_fa port map(
        A=>A(15 downto 12),
        B=>B(15 downto 12),
        Cin=>carry(2),
        DecimalUnits=> Sum(15 downto 12),
        C=> carry(3)
        );
        
        Cout<= carry(3);

end Structural;
