----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2018 10:04:37 PM
-- Design Name: 
-- Module Name: segm7 - Behavioral
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

entity segm7 is
    Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end segm7;

architecture Behavioral of segm7 is

signal count: std_logic_vector (15 downto 0) := (others=>'0');
signal outc: std_logic_vector (3 downto 0); --iesire mux de sus (catre catoade)
signal outa: std_logic_vector (3 downto 0); --iesire mux de jos (catre anoade)
signal dcd: std_logic_vector (6 downto 0); --iesire decoder

begin

process(clk) --counterul
begin
    if rising_edge(clk) then
        if count = "1111111111111111" then
            count <= "0000000000000000";
        else
            count <= count+1;
        end if;
    end if;
end process;

process(count) --primul mux (pt catod)
begin
    case count(15 downto 14) is
        when "00" => outc <= digit(3 downto 0);
        when "01" => outc <= digit(7 downto 4);
        when "10" => outc <= digit(11 downto 8);
        when others => outc <= digit(15 downto 12);
    end case;
end process;

with outc SELect ----------- hex to 7 seg dcd
   dcd<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;   --0

process(count) --al doilea mux (pt anod)
begin
    case count(15 downto 14) is
        when "00" => outa <= "1110";
        when "01" => outa <= "1101";
        when "10" => outa <= "1011";
        when others => outa <= "0111";
    end case;
end process;

cat <= dcd;
an <= outa;


end Behavioral;
