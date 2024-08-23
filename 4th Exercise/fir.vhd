library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir is
  Port ( 
        clk, rst, valid_in: in std_logic;
        x: in std_logic_vector(7 downto 0);
        y: out std_logic_vector(17 downto 0);
        valid_out: out std_logic
    );
end fir;

architecture Behavioral of fir is
    component control_unit is
      Port ( 
      clk, rst, valid_in: in std_logic;
      rom_address, ram_address: out std_logic_vector(2 downto 0);
      mac_init, valid_out: out std_logic;
      cycle8: out std_logic
            );
    end component;
    
    component mlab_rom is
         generic (
            coeff_width : integer :=8                  --- width of coefficients (bits)
         );
        Port ( clk : in  STD_LOGIC;
                  en : in  STD_LOGIC;                --- operation enable
               addr : in  STD_LOGIC_VECTOR (2 downto 0);            -- memory address
               rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0));    -- output data
    end component;
    
    component mlab_ram is
         generic (
            data_width : integer :=8                  --- width of data (bits)
         );
        port (clk  : in std_logic;
              we   : in std_logic;                        --- memory write enable
                 en   : in std_logic;                --- operation enable
                 reset: in std_logic; 
              addr : in std_logic_vector(2 downto 0);            -- memory address
              di   : in std_logic_vector(data_width-1 downto 0);        -- input data
              do   : out std_logic_vector(data_width-1 downto 0));        -- output data
    end component;
    
    component MAC is
        Port (
            x, h: in std_logic_vector(7 downto 0);
            mac_init: in std_logic;
            clk: in std_logic;
            y: out std_logic_vector(17 downto 0)
        );
    end component;
    signal rom_address, ram_address: std_logic_vector(2 downto 0):="000";
    signal mac_init, valid_out_temp, ram_enable, rom_enable: std_logic:='0';
    signal h, x_ram: std_logic_vector(7 downto 0):="00000000";
    signal cycle8: std_logic;
    signal write1: std_logic;
    signal x_mac, h_mac: std_logic_vector(7 downto 0);
    signal ram_address_out, rom_address_out: std_logic_vector(2 downto 0);
begin    
    
    cu: control_unit port map(clk, rst, valid_in, rom_address, ram_address, mac_init, valid_out, cycle8);
    
    rom: mlab_rom port map(clk, '1', rom_address, h);
    
    ram: mlab_ram port map(clk, cycle8, '1', rst, ram_address, x, x_ram);
    
    mac_fir: mac port map(x_ram, h, mac_init, clk, y);
end Behavioral;
