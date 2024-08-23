library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipelined_multiplier is
  Port ( 
        A, B: in std_logic_vector(3 downto 0);
        Output: out std_logic_vector(7 downto 0);
        Clk: in std_logic
        );
end pipelined_multiplier;

architecture Behavioral of pipelined_multiplier is
    component aux_4_bit_adder is
      Port ( 
      A, Sin: in std_logic_vector(3 downto 0);
      B: in std_logic;
      Sum: out std_logic_vector(3 downto 0);
      Cout: out std_logic
      );
    end component;
    signal A_cp0, A_cp1, A_cp2, A_cp3: std_logic_vector(3 downto 0);
    signal B3: std_logic;
    signal B2: std_logic_vector(1 downto 0);
    signal B1: std_logic_vector(2 downto 0);
    signal B0: std_logic_vector(3 downto 0);
    signal Sum0_out, Sum1_out, Sum2_out, Sum3_out: std_logic_vector(3 downto 0);
    signal Sum0_in, Sum1_in, Sum2_in: std_logic_vector(2 downto 0);
    signal Cout0, Cin1, Cout1, Cin2, Cout2, Cin3: std_logic;
    signal Cout3: std_logic;
    signal Sum1, Sum2, Sum3: std_logic_vector(3 downto 0);
    signal p0_0, p0_1, p0_2: std_logic;
    signal p1_0, p1_1: std_logic;
    signal p2: std_logic;
begin
    Sum1<= Cin1 & Sum0_in;
    Sum2<= Cin2 & Sum1_in;
    Sum3<= Cin3 & Sum2_in;
    
    A4FA0: aux_4_bit_adder port map(A_cp0, "0000", B0(0), Sum0_out, Cout0);
    A4FA1: aux_4_bit_adder port map(A_cp1, Sum1, B1(0), Sum1_out, Cout1);
    A4FA2: aux_4_bit_adder port map(A_cp2, Sum2, B2(0), Sum2_out, Cout2);
    A4FA3: aux_4_bit_adder port map(A_cp3, Sum3, B3, Sum3_out, Cout3);
    
    process(Clk)
        begin
            if rising_edge(Clk) then
            
                A_cp0<=A;
                A_cp1<=A_cp0;
                A_cp2<=A_cp1;
                A_cp3<=A_cp2;
                
                B0<=B;
                B1<= B0(3 downto 1);
                B2<= B1(2 downto 1);
                B3<= B2(1);
                
                Cin1<=Cout0;
                Cin2<=Cout1;
                Cin3<=Cout2;
                
                Sum0_in <= Sum0_out(3 downto 1);
                Sum1_in <= Sum1_out(3 downto 1);
                Sum2_in <= Sum2_out(3 downto 1);
                
                p0_0<=Sum0_out(0);
                p0_1<=p0_0;
                p0_2<=p0_1;
                
                p1_0<=Sum1_out(0);
                p1_1<=p1_0;
                
                p2<=Sum2_out(0);
                
                Output(7)<=Cout3;
                Output(6 downto 3)<=Sum3_out;
                Output(2)<=p2;
                Output(1)<=p1_1;
                Output(0)<=p0_2;
                
          end if;
   end process;
end Behavioral;
