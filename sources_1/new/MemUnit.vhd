library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MemUnit is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           Enable: in STD_LOGIC;
           ALUResI : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResO : out STD_LOGIC_VECTOR (15 downto 0));
end MemUnit;

architecture Behavioral of MemUnit is
type mem is array (0 to 63) of std_logic_vector (15 downto 0);
signal RAM: mem := (others=> "0000000000000000");
begin
process (clk)
begin
    if (rising_edge(clk)) then
        if Enable = '1' then
           if MemWrite = '1' then
              RAM(conv_integer(ALUResI)) <= RD2;
                MemData <= RAM( conv_integer(ALUResI));
           else
                MemData <= RAM( conv_integer(ALUResI));
           end if;
         end if;
     end if;
end process;

ALUResO <= ALUResI;

end Behavioral;
