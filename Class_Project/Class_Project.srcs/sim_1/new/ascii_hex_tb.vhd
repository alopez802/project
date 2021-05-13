----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2021 02:16:00 PM
-- Design Name: 
-- Module Name: ascii_hex_tb - Behavioral
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

entity ascii_hex_tb is
--  Port ( );
end ascii_hex_tb;

architecture Behavioral of ascii_hex_tb is

component ascii_hex is
      Port ( 
             input_ascii : in std_logic_vector(7 downto 0);
             output_hex  : out std_logic_vector(3 downto 0)
            
            
            );
end component;

signal input_ascii_tb: std_logic_vector(7 downto 0);
signal output_hex_tb: std_logic_vector(3 downto 0);

begin

ASCII: ascii_hex 
       
       port map(    
                input_ascii => input_ascii_tb,
                output_hex  => output_hex_tb
                );


TEST: process
      begin
      input_ascii_tb <= x"34";
      wait for 10ns;
      end process;
      

end Behavioral;
