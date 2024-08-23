library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec3to8 is
    Port (
        enc : in STD_LOGIC_VECTOR(2 downto 0);
        dec : out STD_LOGIC_VECTOR(7 downto 0)
    );
end dec3to8;

architecture Dataflow of dec3to8 is
    signal enc2_not : std_logic;
    signal enc1_not : std_logic;
    signal enc0_not : std_logic;
begin
    enc2_not <= not enc(2);
    enc1_not <= not enc(1);
    enc0_not <= not enc(0);
    dec(0) <= enc2_not and enc1_not and enc0_not;
    dec(1) <= enc2_not and enc1_not and enc(0);
    dec(2) <= enc2_not and enc(1) and enc0_not;
    dec(3) <= enc2_not and enc(1) and enc(0);
    dec(4) <= enc(2) and enc1_not and enc0_not;
    dec(5) <= enc(2) and enc1_not and enc(0);
    dec(6) <= enc(2) and enc(1) and enc0_not;
    dec(7) <= enc(2) and enc(1) and enc(0);
end Dataflow;
