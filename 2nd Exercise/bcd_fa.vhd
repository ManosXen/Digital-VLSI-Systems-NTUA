library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_fa is
  Port ( 
      A, B: in std_logic_vector(3 downto 0);
      Cin: in std_logic;
      DecimalUnits: out std_logic_vector(3 downto 0);
      C: inout std_logic
  );
end bcd_fa;

architecture Structural of bcd_fa is
    component parallel_adder_4_bit is
        Port ( 
        A, B: in std_logic_vector(3 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(3 downto 0);
        Cout: out std_logic
        );
    end component;
    signal sumTemp: std_logic_vector(3 downto 0);
    signal cTemp, dummy: std_logic;
begin
    pa1: parallel_adder_4_bit port map(
        A=>A,
        B=>B,
        Cin=>Cin,
        Sum=>sumTemp,
        Cout=>cTemp
     );
     
     pa2: parallel_adder_4_bit port map(
             A=>sumTemp,
             B(0)=>'0',
             B(3) =>'0',
             B(2) => C,
             B(1) => C,
             Cin=>'0',
             Sum=>DecimalUnits,
             Cout=>dummy
      );
      
      C <= cTemp or (sumTemp(3) and (sumTemp(2) or sumTemp(1)));

end Structural;
