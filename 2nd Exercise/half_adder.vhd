library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port ( 
        A, B: in std_logic;
        Sum, C: out std_logic);
end half_adder;

architecture Dataflow of half_adder is
begin
    hf: process(A, B)
    begin
        Sum <= A xor B;
        C <= A and B;
    end process;
end Dataflow;
