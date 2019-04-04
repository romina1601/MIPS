library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity instruction_fetch is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           reset : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           jump : in STD_LOGIC;
           jumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
           branchAddress : in STD_LOGIC_VECTOR (15 downto 0);
           PC1 : out STD_LOGIC_VECTOR (15 downto 0);
           Instruction : out STD_LOGIC_VECTOR (15 downto 0));
end instruction_fetch;

architecture Behavioral of instruction_fetch is
signal PC_out, sum_out, mux_branch, mux_jump: std_logic_vector(15 downto 0) := "0000000000000000";
type memorie is array (0 to 256) of std_logic_vector (15 downto 0);
signal instr_mem: memorie := (
0 => B"000_101_101_101_0_110",      --xor $5, $5, $5        --16D6
1 => B"000_000_000_000_0_000",       --noOp
2 => B"000_100_100_100_0_110",      --xor $4, $4, $4        --1246
3 => B"000_000_000_000_0_000",      --noOp
4 => B"000_011_011_011_0_110",      --xor $3,$3,$3          --0DB6
5 => B"000_000_000_000_0_000",       --noOp
6 => B"000_110_110_110_0_110",      --xor $6,$6,$6          --1B66
7 => B"000_000_000_000_0_000",       --noOp
8 => B"000_111_111_111_0_110",      --xor $7,$7,$7          --1FF6
9 => B"000_000_000_000_0_000",       --noOp
10 => B"001_101_101_0000110",        --addi $5,$5,6         --3686
11 => B"001_110_110_0001100",        --addi $6,$6,12           --3B0C
12 => B"000_101_110_100_0_001",      --sub $4,$5,$6          --1741
13 => B"100_100_011_0000110",        --beq $4,$3,6           --9186
14 => B"101_100_000_0000001",        --bgtz $4,1             --B001
15 => B"110_100_000_0000010",       --blez $4,2             --D002 
16 => B"000_101_110_101_0_001",     --sub $5,$5,$6          --1751
17 => B"111_0000000001100",         --jump 12                --E007
18 => B"000_110_101_110_0_001",     --sub $6,$6,$5          --1AE1
19 => B"111_0000000001100",         --jump 12                --E00C
20 => B"000_111_101_111_0_000",     --add $7,$7,$5          --1EF0
others => B"000_000_000_000_0_000"  --noOp                  --0000
);

begin

process(clk)
begin
    if (reset = '1') then
        PC_out <= "0000000000000000";
    else
        if (rising_edge(clk)) then
            if (we = '1') then
                PC_out <= mux_jump;
            end if;
        end if;
    end if;
end process;

--FIRST OUTPUT
Instruction <= instr_mem(conv_integer(PC_out));

sum_out <= PC_out + 1;
--SECOND OUTPUT
PC1 <= sum_out;

--branch MUX
process(sum_out, branchAddress, PCSrc)
begin
    if (PCSrc = '0') then
        mux_branch <= sum_out;
    else
        mux_branch <= branchAddress;
    end if;
end process;

--jump MUX
process(jumpAddress, mux_branch, jump)
begin
    if (jump = '0') then
        mux_jump <= mux_branch;
    else
        mux_jump <= jumpAddress;
    end if;
end process;
 

            
    

end Behavioral;
