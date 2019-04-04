----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2018 11:38:32 AM
-- Design Name: 
-- Module Name: reg_file - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_file is
    port (
    clk : in std_logic;
    reg_write: in std_logic;
    ra1 : in std_logic_vector (2 downto 0);
    ra2 : in std_logic_vector (2 downto 0);
    wa : in std_logic_vector (2 downto 0);
    wd : in std_logic_vector (15 downto 0);
    wen : in std_logic;
    rd1 : out std_logic_vector (15 downto 0);
    rd2 : out std_logic_vector (15 downto 0)
);
end reg_file;

architecture Behavioral of reg_file is
    type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
    signal reg_file : reg_array := (0 => x"0000", 1 => x"0001", 2 => x"0002", 3 => x"0003", 4 => x"0004", 5 => x"0005",
                                    6 => x"0006", 7 => x"0007", 8 => x"0008", 9 => x"0009", 10 => x"0010", 
                                    11 => x"0011", 12 => x"0012", 13 => x"0013", 14 => x"0014", 
                                    15 => x"0015", others => x"1234");
    
begin



process(clk, wen)
begin
    if rising_edge(clk) then
        if (reg_write = '1') then
            if wen = '1' then
                reg_file(conv_integer(wa)) <= wd;
            end if;
        end if;
    end if;
end process;

rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

end Behavioral;
