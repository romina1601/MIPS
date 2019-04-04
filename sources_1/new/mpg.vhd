----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2018 06:44:25 PM
-- Design Name: 
-- Module Name: mpg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mpg is
    Port(clk: in std_logic;
         btn: in std_logic_vector (4 downto 0);
         enable: out std_logic_vector (4 downto 0));
end mpg;

architecture Behavioral of mpg is

signal count: std_logic_vector(15 downto 0) := (others => '0');
signal q1: std_logic_vector (4 downto 0);
signal q2: std_logic_vector (4 downto 0);
signal q3: std_logic_vector (4 downto 0);

begin

process(clk) --counter
begin
    if rising_edge(clk) then
        count <= count+1;
    end if;
end process;

process(clk, count) -- first reg
begin
    if rising_edge(clk) then
        if count = "1111111111111111" then
            q1<= btn;
        end if;
    end if;
end process;

process (clk) --second reg
begin
    if rising_edge(clk) then
        q2 <= q1;
    end if;
end process;

process(clk) --third reg
begin
    if rising_edge(clk) then
        q3 <= q2;
    end if;
end process;

enable <= q2 and (not(q3));



end Behavioral;
