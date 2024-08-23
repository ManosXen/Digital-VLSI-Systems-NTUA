library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pipelined_4_bit_adder is
  Port ( 
  A, B: in std_logic_vector(3 downto 0);
  Sum: out std_logic_vector(3 downto 0);
  Cout: out std_logic;
  Clk: in std_logic
  );
end pipelined_4_bit_adder;

architecture Behavioral of pipelined_4_bit_adder is
    component full_adder is
      Port ( 
        A, B, Cin: in std_logic;
        Sum, Cout: out std_logic);
    end component;
    
    signal A_cp1, B_cp1: std_logic_vector(3 downto 0);
    signal A_cp2, B_cp2: std_logic_vector(2 downto 0);
    signal A_cp3, B_cp3: std_logic_vector(1 downto 0);
    signal A_cp4, B_cp4: std_logic;
    signal carry0, carry_in0, carry1, carry_in1, carry2, carry_in2, carry3: std_logic;
    signal Sum_cp0_1, Sum_cp0_2, Sum_cp0_3, Sum_cp0_4, Sum_cp1_1, Sum_cp1_2, Sum_cp1_3, Sum_cp2_1, Sum_cp2_2, Sum_cp3_1: std_logic;

begin
        fa0: full_adder port map(
                A => A_cp1(0),
                B => B_cp1(0),
                Cin => '0',
                Sum => Sum_cp0_1,
                Cout => carry0
              );
        
          fa1: full_adder port map(
            A => A_cp2(0),
            B => B_cp2(0),
            Cin => carry_in0,
            Sum => Sum_cp1_1,
            Cout => carry1
          );
          
          fa2: full_adder port map(
              A => A_cp3(0),
              B => B_cp3(0),
              Cin => carry_in1,
              Sum => Sum_cp2_1,
              Cout => carry2
           );
           
           fa3: full_adder port map(
             A => A_cp4,
             B => B_cp4,
             Cin => carry_in2,
             Sum => Sum_cp3_1,
             Cout => carry3
          );
                    
        process (Clk)
          begin
            if rising_edge(Clk) then
            
              A_cp1 <= A(3 downto 0);
              B_cp1 <= B(3 downto 0);
              
              A_cp2 <= A_cp1(3 downto 1);
              B_cp2 <= B_cp1(3 downto 1);
              
              A_cp3 <= A_cp2(2 downto 1);
              B_cp3 <= B_cp2(2 downto 1);
              
              A_cp4 <= A_cp3(1);
              B_cp4 <= B_cp3(1);
              
              carry_in0<=carry0;
              carry_in1<=carry1;
              carry_in2<=carry2;
              
              Sum_cp0_2<=Sum_cp0_1;
              Sum_cp0_3<=Sum_cp0_2;
              Sum_cp0_4<=Sum_cp0_3;
              Sum(0)<=Sum_cp0_4;
              
              Sum_cp1_2<=Sum_cp1_1;
              Sum_cp1_3<=Sum_cp1_2;
              Sum(1)<=Sum_cp1_3;
              
              Sum_cp2_2<=Sum_cp2_1;
              Sum(2)<=Sum_cp2_2;
              
              Sum(3)<=Sum_cp3_1;
              
              Cout<=carry3;
            end if;
          end process;

end Behavioral;