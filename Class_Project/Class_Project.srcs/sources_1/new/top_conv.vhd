----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 04:50:03 PM
-- Design Name: 
-- Module Name: top_conv - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_conv is
 Generic ( 
        g_CLK_PER_BIT : POSITIVE:= 869;                  -- FPGA clock / baud rate
        g_DATA_SIZE   : POSITIVE:= 64;
        g_KEY_SIZE    : POSITIVE:= 128
    );
    Port ( 
        i_clk         : in  STD_LOGIC;
        i_rx          : in  STD_LOGIC;
        i_rst         : in  STD_LOGIC;
        o_data        : out UNSIGNED(g_DATA_SIZE - 1 downto 0);
        o_key         : out UNSIGNED(g_KEY_SIZE - 1 downto 0)
    );
end top_conv;

architecture Behavioral of top_conv is

component UART_RX is
  generic (
    g_CLKS_PER_BIT : integer := 869     -- Needs to be set correctly
    );
  port (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
    );
end component;

    component ascii_hex
    Port (
        input_ascii  : in  STD_LOGIC_VECTOR(7 downto 0);
        output_hex    : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;

    type STATE_MACHINE is (s_data, s_key, s_convert);
    signal state          : STATE_MACHINE:= s_data;

    signal state_index    : NATURAL:= 0;
        
    signal rx_done        : STD_LOGIC:= '0';
    signal choice         : STD_LOGIC:= '0';
    --signal temp_done      : STD_LOGIC:= '0';

    signal h_data         : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');       -- Output of ASCII_to_HEX function
    signal a_data         : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal temp           : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');     -- Byte received by uart
    
    signal data           : STD_LOGIC_VECTOR(g_DATA_SIZE - 1 downto 0):= (others => '0');
    signal temp_data      : STD_LOGIC_VECTOR(g_DATA_SIZE - 1 downto 0):= (others => '0');
    signal key            : STD_LOGIC_VECTOR(g_KEY_SIZE - 1 downto 0):= (others => '0');

begin

    BYTE_RX: UART_RX 
        Generic map (
            g_CLKS_PER_BIT => g_CLK_PER_BIT
        )
        Port map ( 
            i_Clk         => i_clk,
            i_RX_Serial   => i_rx,
            o_RX_Byte        => temp,
            o_RX_DV        => rx_done
        );

    CONVERT: ascii_hex
        Port map (
            input_ascii       => a_data,
            output_hex         => h_data
        );

    STATE_CONTROL: process (i_clk) is
    begin          
        if rising_edge(i_clk) then
            if (i_rst = '1') then
                state       <= s_data;
                --temp_done   <= '0';
                state_index <= 0;
                a_data      <= (others => '0');
                data        <= (others => '0');
                key         <= (others => '0');
            else
                case state is
                    when s_data =>
                        --temp_done <= '0';
                        choice    <= '0';

                        if (rx_done = '1') then
                            a_data <= temp;
                            state <= s_convert;
                        end if;

                    when s_key =>
                        choice    <= '1';
                        
                        if (rx_done = '1') then
                            a_data <= temp;
                            state <= s_convert;
                        end if;

                    when s_convert =>
                        if (h_data /= "ZZZZ") then
                            if (choice = '0') then
                                data(state_index + 3 downto state_index) <= h_data;

                                if (state_index + 4 > g_DATA_SIZE - 4) then
                                    state_index <= 0;
                                    state       <= s_key;
                                else
                                    state_index <= state_index + 4;
                                    state       <= s_data;
                                end if;
                            else
                                key(state_index + 3 downto state_index) <= h_data;

                                if (state_index + 4 > g_KEY_SIZE - 4) then
                                    --temp_done   <= '1';
                                    state_index <= 0;
                                    state       <= s_data;
                                else
                                    state_index <= state_index + 4;
                                    state       <= s_key;
                                end if;
                            end if;
                        else
                            if (choice = '0') then
                                state <= s_data;
                            else
                                state <= s_key;
                            end if;
                        end if;

                     when others => 
                        state <= s_data;
                end case;
            end if;
       end if;
    end process STATE_CONTROL;
    
    temp_data <= data(3 downto 0) & data(7 downto 4) &  data(11 downto 8) &  data(15 downto 12) &
         data(19 downto 16) & data(23 downto 20) & data(27 downto 24) & data(31 downto 28) & data(35 downto 32) & data(39 downto 36) & data(43 downto 40)
          & data(47 downto 44) & data(51 downto 48) & data(55 downto 52) & data(59 downto 56) & data(63 downto 60);  

    --co_done <= temp_done;
    o_data  <= UNSIGNED(temp_data);
    o_key   <= UNSIGNED(key);

end Behavioral;