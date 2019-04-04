----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2018 12:06:46 PM
-- Design Name: 
-- Module Name: MAIN_CONTROL - Behavioral
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

entity MAIN_CONTROL is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           Branch : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (2 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end MAIN_CONTROL;

architecture Behavioral of MAIN_CONTROL is
signal controls: std_logic_vector (10 downto 0);
begin

process(opcode)
begin
    RegDst <= '0';
    ExtOp <= '0';
    ALUSrc <= '0';
    Branch <= '0';
    Jump <= '0';
    ALUOp <= "000";
    MemWrite <= '0';
    MemtoReg <= '0';
    RegWrite <= '0';
    
    case (opcode) is
    
    --R type
    when "000" => 
        RegDst <= '1';         --reg dest no for write register comes from rd field
        RegWrite <= '1';        --register from Write register input is written into w/ val on the Write data input
    
    --I type
    --ADDI
    when "001" =>
        RegWrite <= '1';
        ALUSrc <= '1';
        ALUOp <= "001";
    
    --LW
    when "010" =>
        RegWrite <= '1';        
        ALUSrc <= '1';          --second ALU operand comes from sign-extended lower 7-bits of instr
        MemtoReg <= '1';        --value fed to register write data input comes from data memory
        ALUOp <= "010";
    
    --SW
    when "011" =>
        ALUSrc <= '1';
        MemWrite <= '1';         --data mem contents at address given by write addr is replaced by val on write data input
        ALUOp <= "011";
    
    --BEQ
    when "100" =>
        ExtOp <= '1';
        --MemtoReg <= '1';
        Branch <= '1';
        ALUOp <= "100";
   
   --BGTZ
   when "101" =>
        ExtOp <= '1';
       -- MemtoReg <= '1';
        Branch <= '1';
        ALUOp <= "101";
   
   --BLEZ
   when "110" =>
        ExtOp <= '1';
        --MemtoReg <= '1';
        Branch <= '1';
        ALUOp <= "110";
   
   --J type
   when "111" =>
        Jump <= '1';
        ALUOp <= "111";
   end case;
end process;

end Behavioral;
