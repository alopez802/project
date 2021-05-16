----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2021 06:07:50 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
 generic (top_strip_hpixels :positive:= 800;   -- Value of pixels in a horizontal line = 800
          top_strip_vlines  :positive:= 512;   -- Number of horizontal lines in the display = 521
          top_strip_hbp     :positive:= 144;   -- Horizontal back porch = 144 (128 + 16)
          top_strip_hfp     :positive:= 784;   -- Horizontal front porch = 784 (128+16 + 640)
          top_strip_vbp     :positive:= 31;    -- Vertical back porch = 31 (2 + 29)
          top_strip_vfp     :positive:= 511;    -- Vertical front porch = 511 (2+29+ 480)
          top_clk_bits      :integer := 869;
          top_cycles        :integer := 32;
          top_data          :integer := 64;
          top_key_conv      :integer := 128;
          top_depth_prom    :integer := 5;
          top_data_size     :integer := 7;
          top_hex_size      :integer :=114;
          top_rounds        :integer :=2
         );
Port (
        top_clk         : in  STD_LOGIC; --clk
        top_rst         : in std_logic; -- uart reset
        top_SS_rst      : in  STD_LOGIC; -- Seven Seg reset
        top_vga_rst     : in  STD_LOGIC; -- vga reset  
        top_serial_rx   : in std_logic; -- top uart input
        top_vga_sw      : in std_logic_vector(7 downto 0); -- switches used to change color of text
        top_deci_enc_SS      : in std_logic; -- will show decrypt on SS if high
        top_hsync       : out std_logic; -- top output hsync for vga
        top_vsync       : out std_logic; -- top output vsync for vga
        top_red         : out std_logic_VECTOR(2 downto 0); -- top output red for text
        top_blue        : out std_logic_VECTOR(2 downto 0); -- top output blue for text
        top_green       : out std_logic_VECTOR(2 downto 0); -- top output green for text
        top_En          : out STD_LOGIC_VECTOR(7 downto 0); -- top en for seven seg
        top_SS          : out STD_LOGIC_VECTOR(6 downto 0); -- top ss for seven seg
        top_DP          : out STD_LOGIC -- top dp for seven seg
        
    );
end top;

architecture Behavioral of top is

component TeaDecipher is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        num_rounds  : in  UNSIGNED(7 downto 0);
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0);
        done        : out STD_LOGIC
    );
end component;

component top_conv is
generic(g_CLK_PER_BIT :integer:= 869;
        g_DATA_SIZE :integer:= 64;
        g_KEY_SIZE :integer:= 128
        );
Port ( 
        i_clk         : in  STD_LOGIC;
        i_rx          : in  STD_LOGIC;
        i_rst         : in  STD_LOGIC;
        o_data        : out UNSIGNED(g_DATA_SIZE - 1 downto 0);
        o_key         : out UNSIGNED(g_KEY_SIZE - 1 downto 0)
    );
end component;

component Seven_Seg is
        Port ( clk      : in std_logic;
           rst      : in std_logic;
           SSD_in_0 : in STD_LOGIC;
           EN_out   : out std_logic_vector(7 downto 0);
           DP       : out std_logic;
           SS       : out STD_LOGIC_VECTOR(6 downto 0)
         );
end component;

component TeaEncipher is
    generic(num_rounds :integer := 32);
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        input_data  : in  UNSIGNED(63 downto 0);
        key         : in  UNSIGNED(127 downto 0);
        output_data : out UNSIGNED(63 downto 0);
        done        : out STD_LOGIC
    );
end component;


component Temp_VGATOP
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        enciphered_data : in UNSIGNED(63 downto 0);
        vga_sw: in std_logic_vector(7 downto 0);
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        red   : out STD_LOGIC_VECTOR (2 downto 0);
        green : out STD_LOGIC_VECTOR (2 downto 0);
        blue  : out STD_LOGIC_VECTOR (2 downto 0)
    );
end component;

signal top_output_data : unsigned(63 downto 0);
signal top_rx_data     : std_logic_vector(7 downto 0);
signal top_input_data :unsigned(63 downto 0);
signal top_output_decipher :unsigned(63 downto 0);
signal top_key:unsigned(127 downto 0);
signal num_rounds_top: unsigned(7 downto 0):=x"02";

signal temp_deci_enc :unsigned(63 downto 0);

begin



GEN_SS: Seven_Seg
        port map(
            clk       => top_clk, -- top clock for SS 
            rst       => top_SS_rst, -- top reset for SS 
            SSD_in_0  => top_deci_enc_SS, 
            EN_out    => top_En, -- top En for SS
            DP        => top_DP, -- top DP for SS
            SS        => top_SS  -- top SS for SS
            );

GEN_TEA: TeaEncipher 
    generic map(num_rounds  => top_rounds)
    Port map (
        clk        => top_clk, -- top input for tea enc
        rst        => top_vga_rst, -- top key for tea enc
        input_data => unsigned(top_input_data),
        key        => unsigned(top_key),
        output_data=> top_output_data,
        done       => open
        
    );

GEN_DECI_ENC: process(top_deci_enc_SS)
              begin
              if(top_deci_enc_SS = '0') then
                temp_deci_enc <= top_output_data;
              else
                temp_deci_enc <= top_output_decipher;

              end if;
              end process;

GEN_VGA: Temp_VGATOP
    Port map( 
           clk   => top_clk, -- top clk for vga
           rst   => top_vga_rst, -- top vga reset
           enciphered_data  => unsigned(top_output_data),
           vga_sw           => top_vga_sw,
           hsync => top_hsync, -- top output for hsync
           vsync => top_vsync, -- top output for vsync
           red   => top_red, -- top red output 
           green => top_green, --top green output
           blue  => top_blue -- top blue output
         );

GEN_TOP_CONV: top_conv
generic map(g_CLK_PER_BIT => top_clk_bits,
        g_DATA_SIZE => top_data,
        g_KEY_SIZE => top_key_conv
        )
      Port map ( 
            i_clk       => top_clk,
            i_rx => top_serial_rx, 
            i_rst       => top_rst,
            o_data    => top_input_data,      
            o_key       => top_key
            );
            
GEN_DECIPHER: TeaDecipher
    Port map (
        clk         => top_clk,
        rst         => top_vga_rst,
        num_rounds  => num_rounds_top,
        input_data  => unsigned(top_output_data),
        key         => unsigned(top_key),
        output_data => top_output_decipher,
        done        => open
    ); 
         

end Behavioral;

