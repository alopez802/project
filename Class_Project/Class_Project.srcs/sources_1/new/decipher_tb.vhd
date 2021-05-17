library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity TeaDecipherTb is
    --Port()
end TeaDecipherTb; 

architecture Behavioral of TeaDecipherTb is

    component TeaDecipher
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
    
    constant jump : time := 10 ns;
    signal clk, rst, done : STD_LOGIC;
    
    signal num_rounds : UNSIGNED(7 downto 0);

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
    
    UUT: TeaDecipher
        port map (
            clk         => clk,
            rst         => rst,
            num_rounds  => num_rounds,
            input_data  => din,
            key         => key,
            output_data => dout,
            done        => done
        );
        
    TESTBENCH: process
    begin
        din <= x"9ce85bbb00b58f3c";
        key <= x"1928374650bacd921928374650bacd92";
        num_rounds <= x"02";
        
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