----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 04:50:18 PM
-- Design Name: 
-- Module Name: ascii_hex - Behavioral
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

entity ascii_hex is
      Port ( 
             input_ascii : in std_logic_vector(7 downto 0);
             output_hex  : out std_logic_vector(3 downto 0)
            
            
            );
end ascii_hex;

architecture Behavioral of ascii_hex is

begin

ASCII_HEX:process (input_ascii) is
    begin
        if (input_ascii = X"30") then
            output_hex <= "0000";
        elsif (input_ascii = X"31") then
            output_hex <= "0001";
        elsif (input_ascii = X"32") then
            output_hex <= "0010";
        elsif (input_ascii = X"33") then
            output_hex <= "0011";
        elsif (input_ascii = X"34") then
            output_hex <= "0100";
        elsif (input_ascii = X"35") then
            output_hex <= "0101";
        elsif (input_ascii = X"36") then
            output_hex <= "0110";
        elsif (input_ascii = X"37") then
            output_hex <= "0111";
        elsif (input_ascii = X"38") then
            output_hex <= "1000";
        elsif (input_ascii = X"39") then
            output_hex <= "1001";
        elsif (input_ascii = X"41" or input_ascii = X"61") then
            output_hex <= "1010";
        elsif (input_ascii = X"42" or input_ascii = X"62") then
            output_hex <= "1011";
        elsif (input_ascii = X"43" or input_ascii = X"63") then
            output_hex <= "1100";
        elsif (input_ascii = X"44" or input_ascii = X"64") then
            output_hex <= "1101";
        elsif (input_ascii = X"45" or input_ascii = X"65") then
            output_hex <= "1110";
        elsif (input_ascii = X"46" or input_ascii = X"66") then
            output_hex <= "1111";
        else
            output_hex <= "ZZZZ";
        end if;
    end process;
end Behavioral;