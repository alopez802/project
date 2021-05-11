----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2021 04:30:29 PM
-- Design Name: 
-- Module Name: tea_encrypt_tb - Behavioral
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

entity TeaEncipherTb is
generic (top_num_rounds : integer  := 2);
    --Port()
end TeaEncipherTb; 

architecture Behavioral of TeaEncipherTb is

    component TeaEncipher
    generic(num_rounds : integer:=32);
        Port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            input_data  : in  UNSIGNED(63 downto 0);
            key         : in  UNSIGNED(127 downto 0);
            output_data : out UNSIGNED(63 downto 0);
            done        : out STD_LOGIC
        );
    end component;    
    
    constant jump : time := 10 ns;
    signal clk, rst, done : STD_LOGIC;
    


    signal din, dout : UNSIGNED(63 downto 0);
    signal key       : UNSIGNED(127 downto 0);
    
begin
    
    CLKGEN: process
    begin
        clk <= '1';
        wait for jump;
        clk <= '0';
        wait for jump;
    end process;
    
    UUT: TeaEncipher
    generic map(num_rounds => top_num_rounds)
        port map (
            clk         => clk,
            rst         => rst,
            input_data  => din,
            key         => key,
            output_data => dout,
            done        => done
        );
        
    TESTBENCH: process
    begin
        din <= x"DEADBEEFFEEBDAED";
        key <= x"FEEDBEEF00C0FFEEF00000110FACADE0";
        
        rst <= '1';
        wait for jump;
        rst <= '0';
        wait for jump;
        
        while done = '0' loop
            wait for jump;
        end loop;
        
        wait;
    
    end process;

end Behavioral;
