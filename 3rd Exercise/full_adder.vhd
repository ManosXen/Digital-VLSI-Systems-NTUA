library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity full_adder is
  Port ( 
  A, B, Cin: in std_logic;
  Sum, Cout: out std_logic
  );
end full_adder;

architecture Behavioral of full_adder is
    signal input : std_logic_vector(2 downto 0);
begin
    input<= A & B & Cin;
    Sum<= A xor B xor Cin;
    with input select
    Cout<= '1' when "011"|"101"|"110"|"111",
           '0' when "000"|"001"|"010"|"100",
           'X' when others;

end Behavioral;
