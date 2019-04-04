----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2018 11:35:02 AM
-- Design Name: 
-- Module Name: ID - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ID is
    Port ( clk : in STD_LOGIC;
           Instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WriteData : in STD_LOGIC_VECTOR (15 downto 0);
           WEn: in std_logic;
           RegDst : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           ExtOp : in STD_LOGIC; 
           ReadData1 : out STD_LOGIC_VECTOR (15 downto 0);
           ReadData2 : out STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           Funct : out STD_LOGIC_VECTOR (2 downto 0);
           SA : out STD_LOGIC;
           WrAddr: in std_logic_vector(2 downto 0));
end ID;

architecture Behavioral of ID is
component reg_file is
Port (
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
end component;
signal mux_out: std_logic_vector(2 downto 0);
begin

register_file: reg_file port map(clk, WEn, Instruction(12 downto 10), Instruction(9 downto 7), WrAddr, 
                                 WriteData, RegWrite, ReadData1, ReadData2);
           
--Selection of WriteAddress                                 
--process(Instruction, RegDst)
--begin
--    if (RegDst = '0') then
--        mux_out <= Instruction(9 downto 7);
--    else
--        mux_out <= Instruction(6 downto 4);
--    end if;
-- end process;
 
 --OUTPUT ExtImm
 process(Instruction, ExtOp)
 begin
    if (ExtOp = '0') then
        ExtImm <= "000000000" & Instruction(6 downto 0);
    else 
        if (Instruction(6) = '0') then
            ExtImm <= "000000000" & Instruction(6 downto 0);
        else 
            ExtImm <= "111111111" & Instruction(6 downto 0);
        end if;
    end if;
end process;

--OUTPUT Funct
Funct <= Instruction(2 downto 0);
--OUTPUT SA
SA <= Instruction(3);
    

end Behavioral;
