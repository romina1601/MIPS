library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity EXEC is
    Port ( PC1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           Func : in STD_LOGIC_VECTOR (2 downto 0);
           Sa : in STD_LOGIC;
           ALUSrc : in STD_LOGIC;
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           Branch_Address : out STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           Zero : out STD_LOGIC;
           RegDst: in std_logic;
           RT: in std_logic_vector(2  downto 0);
           RD: in std_logic_vector(2 downto 0);
           WrAddr: out std_logic_vector(2 downto 0));
end EXEC;

architecture Behavioral of EXEC is

signal ALU_mult: std_logic_vector(31 downto 0);
signal mux_out, ALU_intRes: std_logic_vector(15 downto 0);
signal is_zero: std_logic;
signal WrAddrTemp: std_logic_vector(2 downto 0);


begin


--OUTPUT
--calculate branch address
Branch_Address <= PC1 + Ext_Imm(13 downto 0);

--calculate Write Address
process(RegDst, RT, RD)
begin
    if(RegDst = '0') then
        WrAddrTemp <=  RT;
    elsif(RegDst = '1') then
        WrAddrTemp <= RD;
   end if;
end process;
        
WrAddr <= WrAddrTemp;

--choose second input of ALU
process(RD2, Ext_Imm,ALUSrc)
begin
    if (ALUSrc = '0') then
        mux_out <= RD2;
    else 
        mux_out <=Ext_Imm;
    end if;
end process;

--ALU process
process(RD1, mux_out, Sa, Func,ALUOp)
begin
    case ALUOp is
        --R type
        when "000" => case Func is
                        when "000" => ALU_intRes <= RD1 + mux_out;      --add
                        when "001" => ALU_intRes <= RD1 - mux_out;      --sub
                            if (ALU_intRes = "0000000000000000") then
                                is_zero <= '1';
                            end if;
                        when "010" =>                                   --sll
                            if (sa = '1') then
                                ALU_intRes <= RD1(14 downto 0) & '0';
                            else
                                ALU_intRes <= RD1;
                            end if;                
                        when "011" =>                                   --srl
                            if (sa = '1') then 
                                ALU_intRes <= '0' & RD1(15 downto 1);
                            else 
                                ALU_intRes <= RD1;
                            end if;
                        when "100" => ALU_intRes <= RD1 and mux_out;            --and
                        when "101" => ALU_intRes <= RD1 or mux_out;             --or
                        when "110" => ALU_intRes <= RD1 xor mux_out;            --xor
                        when "111" => ALU_mult <= RD1 * mux_out;              --multiply
                            ALU_intRes <= ALU_mult(15 downto 0); 
                        end case;
         when "001" => ALU_intRes <= RD1 + mux_out;     --addi
         when "010" => ALU_intRes <= RD1 + mux_out;     --lw
         when "011" => ALU_intRes <= RD1 + mux_out;     --sw
         when "100" => ALU_intRes <= RD1 - mux_out;     --beq                  
            if (ALU_intRes = x"0000") then
                is_zero <= '1';
            else
                is_zero <= '0';
            end if;
         when "101" => ALU_intRes <= RD1 - mux_out;     --bgtz
            --if first bit of result is 0,  then the difference is greater than 0
--            if (ALU_intRes > "0000") then
--                is_zero <= '1';
--            end if;
            if (ALU_intRes(15) = '0') then
                --when is_zero is 1, it means difference greater than 0
                is_zero <= '1';
            else
                is_zero <= '0';
            end if;
         when "110" => ALU_intRes <= RD1 - mux_out;     --blez
         --if first bit of result is 1,  then the difference is smaller than 0
--            if (ALU_intRes < "0000") then
--                is_zero <= '1';
            if (ALU_intRes(15) = '0') then
                 --when is_zero is 0, it means difference greater than 0
                is_zero <= '0';
             else
                --is_zero = 1 means the difference is less than 0
                is_zero <= '1';
            end if;
        when "111" => ALU_intRes <= "0000000000000000";     --jump
    end case;
end process;
 
 --zero detection
-- process(ALU_intRes)
-- begin
--    if (ALU_intRes = "0000000000000000") then
--        is_zero <= '1';
--    else 
--        is_zero <= '0';
--    end if;
--end process;

--OUTPUT
Zero <= is_zero;

--OUTPUT
ALURes <= ALU_intRes;                          

end Behavioral;
