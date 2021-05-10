----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 04:48:41 PM
-- Design Name: 
-- Module Name: TeaDecypher - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TeaDecypher is
Generic(cycles: integer:=32);
    Port (
        input  : in  UNSIGNED(63 downto 0);
        key    : in  UNSIGNED(127 downto 0);
        output : out UNSIGNED(63 downto 0)
    );
end TeaDecypher;

architecture Behavioral of TeaDecypher is

type MEMORY is array(0 to cycles) of UNSIGNED(63 downto 0); -- Create "object" of length cycles to hold key
    signal matrix : MEMORY := (others => (others => '0'));
    
    type MEMSUM is array(0 to cycles) of UNSIGNED(31 downto 0); -- Create"
    signal sum : MEMSUM := (others => (others => '0'));
    
    signal delta : UNSIGNED(31 downto 0);
    
    signal v0, v1, v0_tmp, v1_tmp, tmp1, tmp2, tmp3, tmp4 : MEMSUM;
    
    type ADDRESS is array(0 to cycles) of POSITIVE;
    signal addr1, addr2 : ADDRESS;

begin

matrix(0) <= input;
    output    <= matrix(cycles);
    delta     <= x"9E3779B9";
    sum(0)    <= x"C6EF3720";
    
    --NOTE TO TEAMMATES: THIS CODE IS STILL UNTESTED
    -- -Sander <3

    --To do: Completely get rid of MEMORY and MEMSUM arrays, I think those are unnecessary
    ENCRYPTOR: for i in 0 to cycles - 1 generate
        v0(i) <= matrix(i)(31 downto 0);
        v1(i) <= matrix(i)(63 downto 32);
        
        -- set v1
        tmp3(i)   <= (shift_left(v0(i), 4) + key(95 downto 64));
        tmp4(i)   <= (shift_left(v0(i), 5) + key(127 downto 96));
        v1_tmp(i) <= v1(i) - (tmp3(i) xor (v0(i) + sum(i + 1)) xor tmp4(i));
        
        -- set v0
        tmp1(i)   <= (shift_left(v1(i), 4) + key(31 downto 0));
        tmp2(i)   <= (shift_left(v1(i), 5) + key(63 downto 32));
        v0_tmp(i) <= v0(i) - (tmp1(i) xor (v1(i) + sum(i + 1)) xor tmp2(i));
        


 
        -- add delta count
        sum(i + 1) <= sum(i) - delta;
        
        matrix(i + 1)(31 downto 0)  <= v0_tmp(i);
        matrix(i + 1)(63 downto 32) <= v1_tmp(i);
        
    end generate;

end Behavioral;
