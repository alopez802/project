----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2021 03:06:38 PM
-- Design Name: 
-- Module Name: Seven_Segs - Behavioral
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
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Seven_Seg is
        Port ( clk      : in std_logic;
           rst      : in std_logic;
           SSD_in_0 : in STD_LOGIC;
           EN_out   : out std_logic_vector(7 downto 0);
           DP       : out std_logic;
           SS  : out STD_LOGIC_VECTOR(6 downto 0)
         );
end Seven_Seg;

architecture Behavioral of Seven_Seg is


signal counter_out: std_logic_vector(2 downto 0);
signal dout_out: std_logic_vector(5 downto 0);
signal E: std_logic_vector(7 downto 0);

signal char_1: std_logic_vector(3 downto 0);
signal char_2: std_logic_vector(3 downto 0);
signal char_3: std_logic_vector(3 downto 0);
signal char_4: std_logic_vector(3 downto 0);
signal char_5: std_logic_vector(3 downto 0);
signal char_6: std_logic_vector(3 downto 0);
signal char_7: std_logic_vector(3 downto 0);


begin

process(clk, rst)
    variable v_count: std_logic_vector(18 downto 0);
begin
    if(rising_edge(clk))then -- need to fix the reset here
        if(rst ='1')then
            v_count := (others => '0');
          else 
          v_count := v_count + 1;
          end if;    
    end if;
    counter_out <= v_count(18 downto 16);
    end process;


process(SSD_in_0)
begin
	if(SSD_in_0 = '1') then
		char_1 <= "0111"; --decrypt
		char_2 <= "0000";
		char_3 <= "0010";
		char_4 <= "0011";
		char_5 <= "0100";
		char_6 <= "0101";
		char_7 <= "0110";

	else
		char_1 <= "0000"; --encrypt
		char_2 <= "0001";
		char_3 <= "0010";
		char_4 <= "0011";
		char_5 <= "0100";
		char_6 <= "0101";
		char_7 <= "0110";
	end if;
	
end process;


process(clk, counter_out, SSD_in_0)
begin
    case counter_out is  
        when "000" => E <= "00000001";
                      dout_out <= '1' & char_7(3 downto 0) & '1';  
        when "001" => E <= "00000010";
                      dout_out <= '1' & char_6(3 downto 0) & '1';      
        when "010" => E <= "00000100";
                      dout_out <= '1' & char_5(3 downto 0) & '1';      
        when "011" => E <= "00001000";
                      dout_out <= '1' & char_4(3 downto 0) & '1';      
        when "100" => E <= "00010000";
                      dout_out <= '1' & char_3(3 downto 0) & '1' ;    
        when "101" => E <= "00100000";
                      dout_out <= '1' & char_2(3 downto 0) & '1';      
        when "110" => E <= "01000000";
                      dout_out <= '1' & char_1(3 downto 0) & '1';    
        when "111" => E <= "00000000";
                      dout_out <= '0' & "0000" & '1';    
        when others => E <= "11111111";    
    end case;
 end process;

En_out <= not E;

process(dout_out) is -- a reset for the seven segment decoder, shouldnt be the same as the reset above
begin
    case dout_out(4 downto 1) is
        when "0000" => SS(6 downto 0) <= "0110000";
        when "0001" => SS(6 downto 0) <= "1101010";
        when "0010" => SS(6 downto 0) <= "1110010";
        when "0011" => SS(6 downto 0) <= "1111010";
        when "0100" => SS(6 downto 0) <= "1000100";
        when "0101" => SS(6 downto 0) <= "0011000";
        when "0110" => SS(6 downto 0) <= "1110000";
        when "0111" => SS(6 downto 0) <= "1000010";
        when others => SS(6 downto 0) <= "1111111";     
    end case;
end process;

DP <= dout_out(0);
end Behavioral;

