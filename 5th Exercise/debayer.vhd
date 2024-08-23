library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debayer is
  Generic (
  N: integer:=32
  ); 
  Port ( 
  clk: in std_logic;
  rst_n: in std_logic;
  new_image, valid_in: in std_logic;
  pixel: in std_logic_vector(7 downto 0);
  image_finished, valid_out: out std_logic; 
  --w00, w01, w02, w10, w11, w12, w20, w21, w22: out std_logic_vector(9 downto 0);
  --cycles, row, col: out integer;
  R, G, B: out std_logic_vector(7 downto 0) 
  );
end debayer;

architecture Behavioral of debayer is
    component fifo_generator_0 IS                    --32 entries
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END component;
    component fifo_generator_1 IS                  --64 entries
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END component;
    component fifo_generator_2 IS               --128 entries
      PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END component;
    
    component fifo_generator_1024_1 IS               --1024 entries
          PORT (
            clk : IN STD_LOGIC;
            srst : IN STD_LOGIC;
            din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            wr_en : IN STD_LOGIC;
            rd_en : IN STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            full : OUT STD_LOGIC;
            empty : OUT STD_LOGIC
          );
        END component;
    
    --3x3 window contstruction
    type win_row is array(2 downto 0) of std_logic_vector(9 downto 0);
    type win is array(2 downto 0) of win_row;
    
    signal window: win := (others => (others => (others => '0')));
    signal row0, row1, row2: win_row;
    
    signal w00, w01, w02, w10, w11, w12, w20, w21, w22: std_logic_vector(9 downto 0);
    signal cycles, row, col: integer;
    
    signal up_flag, down_flag, left_flag, right_flag: std_logic_vector(7 downto 0);
    signal rowCounter, columnCounter: integer;
    signal out0, out1, out2: std_logic_vector(7 downto 0);
    signal read_enable: std_logic;
    signal full0, full1, full2: std_logic;
    signal empty0, empty1, empty2: std_logic;
    signal rst: std_logic;
    signal cycle_counter: integer:=0;
    signal read0, read1, read2 : std_logic;
    signal countRow, countCol: integer:=0;
    signal maskUp, maskDown, maskLeft, maskRight: std_logic_vector(9 downto 0);
    signal tempBlue, tempGreen, tempRed: std_logic_vector(9 downto 0);
    signal prevRow, prevCol: integer :=-1;
    signal gated_clock: std_logic:='0';
    signal image_reset:std_logic:='0';
    signal fifo0_enable, fifo1_enable, fifo2_enable:std_logic:='0';
begin

    rst<= (not rst_n);
    cycles<=cycle_counter;
    row<=countRow;
    col<=countCol;
    gated_clock<=clk and valid_in;
    fifo0_enable<= valid_in or read0;
    fifo1_enable<= valid_in or read1;
    fifo2_enable<= valid_in or read2;
    
    FIFO_32:
    if N=32 generate
        fifo0: fifo_generator_0 port map(clk, rst, pixel, valid_in, fifo0_enable, out0, full0, empty0);
        fifo1: fifo_generator_0 port map(clk, rst, out0, fifo1_enable, read1, out1, full1, empty1);
        fifo2: fifo_generator_0 port map(clk, rst, out1, fifo2_enable, read2, out2, full2, empty2);
    end generate FIFO_32;
    
    FIFO_64:
    if N=64 generate
        fifo0: fifo_generator_1 port map(clk, rst, pixel, valid_in, fifo0_enable, out0, full0, empty0);
        fifo1: fifo_generator_1 port map(clk, rst, out0, fifo1_enable, read1, out1, full1, empty1);
        fifo2: fifo_generator_1 port map(clk, rst, out1, fifo2_enable, read2, out2, full2, empty2);
    end generate FIFO_64;
  
    FIFO_128:
    if N=128 generate
        fifo0: fifo_generator_2 port map(clk, rst, pixel, valid_in, fifo0_enable, out0, full0, empty0);
        fifo1: fifo_generator_2 port map(clk, rst, out0, fifo1_enable, read1, out1, full1, empty1);
        fifo2: fifo_generator_2 port map(clk, rst, out1, fifo2_enable, read2, out2, full2, empty2);
    end generate FIFO_128;
    
    FIFO_1024:
    if N=1024 generate
        fifo0: fifo_generator_1024_1 port map(clk, rst, pixel, valid_in, fifo0_enable, out0, full0, empty0);
        fifo1: fifo_generator_1024_1 port map(clk, rst, out0, fifo1_enable, read1, out1, full1, empty1);
        fifo2: fifo_generator_1024_1 port map(clk, rst, out1, fifo2_enable, read2, out2, full2, empty2);
    end generate FIFO_1024;
    
    w00 <= window(0)(0);
    w01 <= window(0)(1);
    w02 <= window(0)(2);
    w10 <= window(1)(0);
    w11 <= window(1)(1);
    w12 <= window(1)(2);
    w20 <= window(2)(0);
    w21 <= window(2)(1);
    w22 <= window(2)(2);

process(clk, rst)
begin
    if rst_n = '0' then
        image_finished <= '0';
        valid_out <= '0';
        R <= (others => '0');
        G <= (others => '0');
        B <= (others => '0');
        tempRed <= (others => '0');
        tempGreen <= (others => '0');
        tempBlue <= (others => '0');
        read0 <= '0';
        read1 <= '0';
        read2 <= '0';
        cycle_counter<=0;
        window <= (others => (others => (others => '0')));
        countRow<=0;
        countCol<=0;
    elsif rising_edge(clk) then
        if cycle_counter >= N-2 then
            read0 <= '1';
            read1 <= '1';
            read2 <= '1';
        end if;
        
        valid_out<='0';
        image_finished <= '0';
        image_reset<='0';
        
        if valid_in = '1' or cycle_counter>=N*N-10 then
            window(0)(2) <= window(0)(1);
            window(0)(1) <= window(0)(0);
            window(0)(0) <= "00" & out0;
            
            window(1)(2) <= window(1)(1);
            window(1)(1) <= window(1)(0);
            window(1)(0) <= "00" & out1;

            window(2)(2) <= window(2)(1);
            window(2)(1) <= window(2)(0);
            window(2)(0) <= "00" & out2;
            
            cycle_counter <= cycle_counter + 1; 
            
            if cycle_counter >= N + 4 then
            if countCol=N-1  then 
                countCol<=0;
                countRow<=countRow+1;
            else countCol<=countCol+1;
            end if;
            prevRow<=countRow;
            prevCol<=countCol;
            
            if prevRow=N-1 and prevCol=N-1 then
                image_finished<='1';
                cycle_counter<=0;
            else image_finished<='0';
            end if;
            
            if cycle_counter>=N+5 then
                valid_out<='1';
            end if;
                

            if prevRow mod 2 = 0 then
                if prevCol mod 2 =0 then
                    G<=tempGreen(7 downto 0);
                    B<=tempBlue(8 downto 1);
                    R<=tempRed(8 downto 1);
                else
                    B<=tempBlue(7 downto 0);
                    G<=tempGreen(9 downto 2);
                    R<=tempRed(9 downto 2);
                end if;
            else 
                if prevCol mod 2 =0 then
                    R<=tempRed(7 downto 0);
                    G<=tempGreen(9 downto 2);
                    B<=tempBlue(9 downto 2);
                else
                    G<=tempGreen(7 downto 0);
                    R<=tempRed(8 downto 1);
                    B<=tempBlue(8 downto 1);
                end if;
            end if;




                if (countRow mod 2) = 0 then                 --Green and Blue
                    if countRow=0 then                       --We are on First Line
                        if countCol mod 2 =0 then            --Green
                            if CountCol=0 then               --Upper Left Green
                                tempGreen<=window(1)(1);
                                tempRed<=window(0)(1);
                                tempBlue<=window(1)(0);
                            else                             --Other Greens from First Line
                                tempGreen<=window(1)(1);
                                tempBlue <= (window(1)(0)) + (window(1)(2));
                                tempRed<=window(0)(1);
                            end if;
                        else                                 --Blues on First Line
                            if countCol=N-1 then             --Upper Right Blue
                                tempBlue<=window(1)(1);
                                tempGreen <= (window(1)(2)) + (window(0)(1));
                                tempRed<=window(0)(2);
                            else                            --Other First Line Blues
                                tempGreen<=window(1)(0)+window(1)(2)+window(0)(1);
                                tempBlue<=window(1)(1);
                                tempRed<=window(0)(2)+window(0)(0);
                            end if;
                        end if;
                    else                                    --We are on other Green-Blue Lines
                        if CountCol mod 2 = 0 then          --Color is Green
                            tempGreen<=window(1)(1);
                            tempRed<=window(0)(1)+window(2)(1);
                            if CountCol=0 then              --We are on First Column
                                tempBlue<=window(1)(0);
                            else 
                                tempBlue<=window(1)(0)+window(1)(2);
                            end if;
                        else                                --Color is Blue
                            tempBlue<=window(1)(1);
                            if CountCol=N-1 then
                                tempGreen<=window(0)(1)+window(1)(2)+window(2)(1);
                                tempRed<=window(0)(2)+window(2)(2);
                            else 
                                tempGreen<=window(0)(1)+window(1)(2)+window(2)(1)+window(1)(0);     
                                tempRed<=window(0)(2)+window(2)(2)+window(0)(0)+window(2)(0);
                            end if;
                        end if;
                    end if;
                else                                        --Red Green
                    if countRow=N-1 then                    --We are on Last Line
                        if CountCol mod 2 =0 then           --Color is Red
                            tempRed<=window(1)(1);
                            if CountCol=0 then              --Down Left
                                tempGreen<=window(2)(1)+window(1)(0);
                                tempBlue<=window(2)(0);
                            else                            --Other Last Line Reds
                                tempGreen<=window(2)(1)+window(1)(2) + window(1)(0);
                                tempBlue<=window(2)(0)+window(2)(2);
                            end if;
                        else                               --We are on Last Line and calculating Greens
                            tempGreen<=window(1)(1);
                            if CountCol=N-1 then           --Down Right
                                tempBlue<=window(2)(1);
                                tempRed<=window(1)(2);
                            else                           --Other Last Line Greens
                                tempRed<=window(1)(0)+window(1)(2);
                                tempBlue<=window(2)(1);
                            end if;
                        end if;
                    else                                   --Other Red Green Lines
                        if CountCol mod 2=0 then           --Color is Red
                            tempRed<=window(1)(1);
                            if CountCol=0 then             --We are on First Column
                                tempGreen<=window(0)(1)+window(2)(1)+window(1)(0);
                                tempBlue<=window(2)(0)+window(0)(0);
                            else                           --Other Reds
                                tempGreen<=window(0)(1)+window(2)(1)+window(1)(2)+window(1)(0);
                                tempBlue<=window(2)(2)+window(0)(2)+window(0)(0)+window(2)(0);
                            end if;
                        else                               --Color is Green
                            tempGreen<=window(1)(1);
                            tempBlue<=window(0)(1)+window(2)(1);
                            if CountCol=N-1 then           --Last Column Green
                                tempRed<=window(1)(2);
                            else                           --Other Greens
                                tempRed<=window(1)(2)+window(1)(0);
                            end if;
                        end if;
                end if;
            end if;   
        end if;
    end if;
    end if;
end process;

            
end Behavioral;
