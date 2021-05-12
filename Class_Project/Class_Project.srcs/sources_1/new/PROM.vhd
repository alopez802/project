----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2021 03:04:19 PM
-- Design Name: 
-- Module Name: PROM - Behavioral
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


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2019 03:15:00 PM
-- Design Name: 
-- Module Name: PROM_IMG - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROM_IMG is
    generic(DEPTH    :positive:= 5; 
            DATA_SIZE:positive:= 7;
			HEX_SIZE :positive:= 114
           );
    Port   ( 
	         sel: STD_LOGIC_VECTOR (63 downto 0);
			 addr    : in  STD_LOGIC_VECTOR (integer(ceil(log2(real(DEPTH))))-1 downto 0);
             PROM_OP : out STD_LOGIC_VECTOR (HEX_SIZE-1 downto 0)
           );
end PROM_IMG;

architecture Behavioral of PROM_IMG is


signal temp: STD_LOGIC_VECTOR(HEX_SIZE-3 downto 0);

type mem_type is array (0 to DEPTH-1) of std_logic_vector(HEX_SIZE-3 downto 0);
signal mem: mem_type:= (
                        "0111110011111001000000111110000001000010000111110011111001111100111110011111000100100111110011111000000100111110",
                        "0000010000001001000000000010000001000101000100010010001000100000000010000001000100100100000010000000000100100010",
                        "0011110011111001111100000010011111000111000111110011111000010000111110011111001111100111110011111000000100100010",
                        "0000010000001001000100000010010001001000100100000010001000001000100010010000000100000100000000001000000100100010",
                        "0000010011111001111100111110011111001000100111110011111000000100111110011111000100000111110011111000000100111110"
                        ); 

begin

Character_sel: for i in 0 to ((HEX_SIZE-2)/7) - 1 generate
    temp(7*(((HEX_SIZE-2)/7) - 1 - i) + 6 downto 7*(((HEX_SIZE-2)/7) - 1 - i)) <=mem(conv_integer(addr))(((conv_integer(sel(4*i+3 downto 4*i))+1)*7 -1) downto (conv_integer(sel(4*i+3 downto 4*i))*7));
end generate;

PROM_OP <= "00" & temp; 


end Behavioral;

