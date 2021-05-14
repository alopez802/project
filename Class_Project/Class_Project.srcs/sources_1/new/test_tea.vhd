----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/14/2021 02:07:23 PM
-- Design Name: 
-- Module Name: test_tea - Behavioral
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

entity test_tea is
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
        test_key         :  in std_logic_vector(127 downto 0); -- switches used to change color of text
        test_vga_sw      : in std_logic_vector(7 downto 0); -- switches used to change color of text
        test_hsync       : out std_logic; -- top output hsync for vga
        test_vsync       : out std_logic; -- top output vsync for vga
        test_red         : out std_logic_VECTOR(2 downto 0); -- top output red for text
        test_blue        : out std_logic_VECTOR(2 downto 0); -- top output blue for text
        test_green       : out std_logic_VECTOR(2 downto 0) -- top output green for tex

        );
end test_tea;

architecture Behavioral of test_tea is

signal test_output_data :  unsigned(63 downto 0); -- switches used to change color of text


component TeaEncipher is
    generic(num_rounds :integer := 2);
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0);
        done        : out STD_LOGIC
    );
end component;

component vga_initials_top is
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
end component;

begin

GEN_TEA: TeaEncipher 
    generic map(num_rounds  => test_round)
    Port map (
        clk        => test_clk, -- top input for tea enc
        rst        => test_rst, -- top key for tea enc
        input_data => unsigned(test_input_data),
        key        => unsigned(test_key),
        output_data=> test_output_data,
        done       => open
        
    );


GEN_VGA: vga_initials_top
          generic map (
          strip_hpixels => test_strip_hpixels,
          strip_vlines  => test_strip_vlines,
          strip_hbp     => test_strip_hbp,
          strip_hfp     => test_strip_hfp,
          strip_vbp     => test_strip_vbp,
          strip_vfp     => test_strip_vfp,
          clk_bits      => test_clk_bits,
          depth_prom    => test_depth_prom,
          data_size_prom=> test_data_size_prom,
          hex_size_prom => test_hex_size_prom 
         )
    Port map( 
           clk   => test_clk, -- top clk for vga
           rst   => test_rst, -- top vga reset
           enciphered_data  => unsigned(test_output_data),
           vga_sw           => test_vga_sw,
           hsync => test_hsync, -- top output for hsync
           vsync => test_vsync, -- top output for vsync
           red   => test_red, -- top red output 
           green => test_green, --top green output
           blue  => test_blue -- top blue output
         );



end Behavioral;
