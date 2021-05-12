----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2021 11:08:34 PM
-- Design Name: 
-- Module Name: VGA_initals_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_initials_top is
 generic (strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          strip_vfp     :positive:= 511;    -- Vertical front porch = 511 (2+29+ 480)
          clk_bits      :integer := 869;
          depth_prom    :integer := 5;
          data_size_prom:integer := 7;
          hex_size_prom :integer := 114
         );
    Port ( clk  : in STD_LOGIC;
           rst  : in STD_LOGIC;
           enciphered_data: in unsigned(63 downto 0);
           vga_sw : STD_LOGIC_VECTOR (7  downto 0);
           hsync: out STD_LOGIC;
           vsync: out STD_LOGIC; 
           red  : out STD_LOGIC_VECTOR (2 downto 0); 
           green: out STD_LOGIC_VECTOR (2 downto 0);
           blue : out STD_LOGIC_VECTOR (2 downto 0)
         );
end vga_initials_top;

architecture Behavioral of vga_initials_top is



component VGA_VHDL 
    -- Note these numbers are different from a resolution to another (This is for 640x480) 
    generic(hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
            vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
            hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
            hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
            vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
            vfp     :positive:= 511    -- Vertical front porch = 511 (2+29+ 480)
           );
    Port ( clk   : in  STD_LOGIC;
           clr   : in  STD_LOGIC;
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           hc    : out STD_LOGIC_VECTOR (9 downto 0);
           vc    : out STD_LOGIC_VECTOR (9 downto 0);
           vidon : out STD_LOGIC
        );
end component;

component clk_wiz_0 
     port (
           clk25  : out std_logic; 
           reset  : in  std_logic; 
           locked : out std_logic;
           clk_in1: in  std_logic;
           sys_clk: out std_logic
          );
end component; 

component PROM_IMG is
    generic(DEPTH    :positive:= 5; 
            DATA_SIZE:positive:= 7;
			HEX_SIZE :positive:= 114
           );
    Port   ( 
             sel: STD_LOGIC_VECTOR (63 downto 0);
			 addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (HEX_SIZE-1 downto 0)
           );
end component;


component vga_initials is
    generic (hbp:positive:=144; vbp:positive:=31; W:positive:=32; H:positive:= 5 );
    Port ( 
           clk      : in  STD_LOGIC; 
           rst      : in  STD_LOGIC; 
           vidon    : in  STD_LOGIC;
           hc       : in  STD_LOGIC_VECTOR (9  downto 0);
           vc       : in  STD_LOGIC_VECTOR (9  downto 0);
           M        : in  STD_LOGIC_VECTOR (W-1 downto 0);
           SW       : in  STD_LOGIC_VECTOR (7  downto 0);
           rom_addr4: out STD_LOGIC_VECTOR (2  downto 0);
           red      : out STD_LOGIC_VECTOR (2  downto 0); 
           green    : out STD_LOGIC_VECTOR (2  downto 0); 
           blue     : out STD_LOGIC_VECTOR (2  downto 0)
         );
end component;


signal clk25MHz       :std_logic; 
signal sys_clk          : std_logic;
signal locked_pll     :std_logic; 
signal steady_clk25MHz:std_logic;
signal steady_clk100MHz:std_logic;

signal hc, vc:std_logic_vector(9 downto 0); 
signal video_on :std_logic; 
signal IMG_in,IMG_out:std_logic_vector(hex_size_prom-1 downto 0); 

signal IMG:std_logic_vector(31 downto 0); 
signal rom_addr4:std_logic_vector(2 downto 0); 

signal rx_data, pos_data : std_logic_vector(7 downto 0) := (others => '0');
signal rx_valid : std_logic;

begin



CLK_GEN_PLL: clk_wiz_0 port map ( 
                                   clk25   => clk25MHz, 
                                   reset   => rst,
                                   locked  => locked_pll,
                                   clk_in1 => clk,
                                   sys_clk => sys_clk
                                );
steady_clk25MHz <= locked_pll and clk25MHz;
steady_clk100MHz <= locked_pll and sys_clk;



VGA_DRIVER: VGA_VHDL 
                     generic map (
                                  hpixels => strip_hpixels,
                                  vlines  => strip_vlines,
                                  hbp     => strip_hbp,
                                  hfp     => strip_hfp,
                                  vbp     => strip_vbp,
                                  vfp     => strip_vfp
                        
                                  )   
                     port map (
                               clk   => steady_clk25MHz,
                               clr   => rst,
                               hsync => hsync,
                               vsync => vsync,
                               hc    => hc, 
                               vc    => vc, 
                               vidon => video_on
                              );
                              
INIT: vga_initials 
    generic map ( hbp =>144, 
                  vbp =>31, 
                  W   =>114, 
                  H   =>5 
                )
    Port map ( 
                   clk       => steady_clk25MHz,
                   rst       => rst,
                   vidon     => video_on,
                   hc        => hc,
                   vc        => vc,
                   M         => IMG_out,
                   SW        => vga_sw,
                   rom_addr4 => rom_addr4,
                   red       =>  red,
                   green     =>  green,
                   blue      =>  blue
         );
         
PROM: PROM_IMG generic map (
                            DEPTH     => depth_prom,
                            DATA_SIZE => data_size_prom,
                            HEX_SIZE => hex_size_prom
                            )
               port map (
                          sel     => std_logic_vector(enciphered_data),
                          addr    => rom_addr4,
                          PROM_OP => IMG_out
                        );         
         

end Behavioral;
