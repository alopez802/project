----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2021 02:30:27 PM
-- Design Name: 
-- Module Name: test_tea_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_tea_tb is
 generic  (test_strip_hpixels_tb :positive:= 800;   -- Value of pixels in a horizontal line = 800
          test_strip_vlines_tb  :positive:= 512;   -- Number of horizontal lines in the display = 521
          test_strip_hbp_tb     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          test_strip_hfp_tb     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          test_strip_vbp_tb     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          test_strip_vfp_tb     :positive:= 511;    -- Vertical front porch = 511 (2+29+ 480)
          test_clk_bits_tb      :integer := 869;
          test_depth_prom_tb    :integer := 5;
          test_data_size_prom_tb:integer := 7;
          test_hex_size_prom_tb :integer := 114;
          test_round_tb         : integer:= 2
          
         );
--  Port ( );
end test_tea_tb;

architecture Behavioral of test_tea_tb is

component test_tea is
 generic (test_strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          test_strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          test_strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          test_strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          test_strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          test_strip_vfp     :positive:= 511;    -- Vertical front porch = 511 (2+29+ 480)
          test_clk_bits      :integer := 869;
          test_depth_prom    :integer := 5;
          test_data_size_prom:integer := 7;
          test_hex_size_prom :integer := 114;
          test_round         : integer:= 2
          
         );
  Port ( 
        test_clk         : in  STD_LOGIC; --clk
        test_rst         : in std_logic; -- uart reset
        test_input_data  : in std_logic_vector(63 downto 0); -- switches used to change color of text
        test_vga_sw      : in std_logic_vector(7 downto 0); -- switches used to change color of text
        test_key         :  in std_logic_vector(127 downto 0); 
        test_hsync       : out std_logic; -- top output hsync for vga
        test_vsync       : out std_logic; -- top output vsync for vga
        test_red         : out std_logic_VECTOR(2 downto 0); -- top output red for text
        test_blue        : out std_logic_VECTOR(2 downto 0); -- top output blue for text
        test_green       : out std_logic_VECTOR(2 downto 0) -- top output green for tex

        );
end component;

signal  test_clk_tb         : STD_LOGIC; --clk
signal  test_rst_tb         : std_logic; -- uart reset
signal  test_input_data_tb  : std_logic_vector(63 downto 0); -- switches used to change color of text
signal  test_key_tb  : std_logic_vector(127 downto 0); -- switches used to change color of text
signal  test_vga_sw_tb      :  std_logic_vector(7 downto 0); -- switches used to change color of text
signal  test_hsync_tb       :  std_logic; -- top output hsync for vga
signal  test_vsync_tb       :  std_logic; -- top output vsync for vga
signal  test_red_tb         :  std_logic_VECTOR(2 downto 0); -- top output red for text
signal  test_blue_tb        :  std_logic_VECTOR(2 downto 0); -- top output blue for text
signal  test_green_tb       :  std_logic_VECTOR(2 downto 0); -- top output green for tex



begin

GEN_CLK: process
begin
test_clk_tb <= '0';
wait for 5ns;
test_clk_tb <= '1';
wait for 5ns;

end process;


GEN_TEST: test_tea

generic map(
            test_strip_hpixels => test_strip_hpixels_tb,
          test_strip_vlines     => test_strip_vlines_tb,
          test_strip_hbp        => test_strip_hbp_tb,
          test_strip_hfp        => test_strip_hfp_tb,
          test_strip_vbp        => test_strip_vbp_tb,
          test_strip_vfp        => test_strip_vfp_tb,
          test_clk_bits         => test_clk_bits_tb,
          test_depth_prom       => test_depth_prom_tb,
          test_data_size_prom   => test_data_size_prom_tb,
          test_hex_size_prom    => test_hex_size_prom_tb,
          test_round            =>  test_round_tb       
            
            )
port map(
        test_clk         => test_clk_tb,
        test_rst         => test_rst_tb,
        test_input_data  => test_input_data_tb,
        test_key         => test_key_tb,
        test_vga_sw      => test_vga_sw_tb,
        test_hsync       => test_hsync_tb,
        test_vsync       => test_vsync_tb,
        test_red         => test_red_tb,
        test_blue        => test_blue_tb,
        test_green       => test_green_tb
        
         );        

TEST: process
        begin
        test_rst_tb <= '0';
        test_input_data_tb <= x"1928374650bacd92";
        test_key_tb <= x"1928374650bacd921928374650bacd92";
        test_vga_sw_tb <= x"22";
        wait for 100ns;
        
        end process;

end Behavioral;
