library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           RsTx: out std_logic;
           RsRx: in std_logic);
end test_env;

architecture Behavioral of test_env is

component mpg
port(clk: in std_logic;
         btn: in std_logic_vector(4 downto 0);
         enable: out std_logic_vector(4 downto 0));
end component;

component segm7
Port ( digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component instruction_fetch
 Port ( clk : in STD_LOGIC;
          we : in STD_LOGIC;
          reset : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          jump : in STD_LOGIC;
          jumpAddress : in STD_LOGIC_VECTOR (15 downto 0);
          branchAddress : in STD_LOGIC_VECTOR (15 downto 0);
          PC1 : out STD_LOGIC_VECTOR (15 downto 0);
          Instruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component MAIN_CONTROL
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
end component;

component ID
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
end component;

component EXEC
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
end component;

component MemUnit
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           Enable: in STD_LOGIC;
           ALUResI : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResO : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component TX_FSM
    Port ( tx_data : in STD_LOGIC_VECTOR (7 downto 0);
           tx_en : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           tx : out STD_LOGIC;
           tx_rdy : out STD_LOGIC);
end component;

component RX_FSM
    Port ( clk : in STD_LOGIC;
           rx : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end component;



-------------------------LAB 2---------------------------------
--signal count: std_logic_vector (15 downto 0) := (others=>'0');
--signal ce: std_logic_vector(4 downto 0);
--signal enable: std_logic;
--signal digit: std_logic_vector (15 downto 0);
--signal op1, op2, op3: Std_logic_vector (15 downto 0);
--signal result: Std_logic_vector (15 downto 0);--output of mux

-----------------LAB 3--------------------------------------

type rom_type is array (0 to 255) of std_logic_vector (15 downto 0);
signal rom: rom_type := (
0 => B"000_101_101_101_0_110",      --xor $5, $5, $5
1 => B"000_100_100_100_0_110",      --xor $4, $4, $4
2 => B"000_011_011_011_0_110",      --zor $3,$3,$3
3 => B"000_110_110_110_0_110",      --xor $6,$6,$6
4 => B"000_111_111_111_0_110",      --zor $7,$7,$7
5 => B"001_101_101_0000111",        --addi $5,$5,6
6 => B"001_110_110_0001100",        --addi $6,$6,12
7 => B"000_101_110_100_0_001",      --sub $4,$5,$6
8 => B"100_100_011_0001110",        --beq $4,$3,15
9 => B"101_100_000_0001011",        --bgtz $4,11
10 => B"110_100_000_0001101",       --blez $4,13      
11 => B"000_101_110_101_0_001",     --sub $5,$5,$6
12 => B"111_0000000000111",         --jump 7
13 => B"000_110_101_110_0_001",     --sub $6,$6,$5
14 => B"111_0000000000011",         --jump 3
15 => B"000_111_101_111_0_000",     --add $7,$7,$5
others => B"000_000_000_000_0_000"  --noOp
);
signal count:std_logic_vector (7 downto 0) := (others=>'0');
signal enable: std_logic_vector(4 downto 0);
signal ce: std_logic;
signal result: Std_logic_vector (15 downto 0);
signal addr: std_logic_vector (7 downto 0);
signal do: std_logic_vector (15 downto 0);

--signals for reg file
type reg_array is array (0 to 15) of std_logic_vector(15 downto 0);
    signal reg_file : reg_array := (0 => x"0000", 1 => x"0001", 2 => x"0002", 3 => x"0003", 4 => x"0004", 5 => x"0005",  others => x"1234");
signal reg_addr: std_logic_vector(2 downto 0) := "101";
signal reg_data: std_logic_vector(15 downto 0);
--signals for IF
signal PC1, Instruction: std_logic_vector(15 downto 0);

--signals for MAIN_CONTROL
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, RegWrite, RegWrite2: std_logic;
signal ALUOp: std_logic_vector (2 downto 0);

--signals for ID
signal WD,RD1, RD2, ExtImm: std_logic_vector (15 downto 0);
signal Fct: std_logic_vector(2 downto 0);
signal sa: std_logic;

--signals for EXEC_UNIT
signal BranchAddr, ALURes: std_logic_vector (15 downto 0);
signal zero: std_logic;

--signals for MEM_UNIT
signal ALUResOut: std_logic_vector(15 downto 0);--same as ALURes
signal MemData: std_logic_vector(15 downto 0);

--signals for WRITE BACK
signal WB_out, JumpAddr: std_logic_vector(15 downto 0);
signal PCSrc: std_logic;

--signals for tests
signal test1: std_logic_vector(15 downto 0):= "0000000000000111";
signal test2: std_logic_vector(15 downto 0) := "0000000000001000";
signal result_test:std_logic_vector(15 downto 0);
signal zeroFlag: std_logic;

--signals for PIPELINE
signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(82 downto 0);
signal EX_MEM: std_logic_vector(55 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);
signal WrAddr: std_logic_vector(2 downto 0);
signal WrAddrTemp: std_logic_vector(2 downto 0);

--signals for TX_FSM
signal tx_en: std_logic;
signal baud_en: std_logic;
signal tx: std_logic;
signal tx_rdy: std_logic;
signal tx_count: std_logic_vector(13 downto 0);

--signals for RX_FSM
signal rx_en: std_logic;
signal rx_baud_en: std_logic;
signal rx_data: std_logic_vector(7 downto 0);
signal rx_count: std_logic_vector(15 downto 0);
signal rx_rdy: std_logic;

begin
seven_segm: segm7 port map (result, clk, cat, an);
mpg1: mpg port map (clk, btn,enable); 
--InstrF: instruction_fetch port map(clk, ce, enable(4), PCSrc, Jump, JumpAddr, BranchAddr, PC1, Instruction);
InstrF: instruction_fetch port map(clk, ce, enable(4), PCSrc, Jump, JumpAddr,EX_MEM(19 downto 4),PC1, Instruction);
--Main_Ctrl: MAIN_CONTROL port map (Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
Main_Ctrl: MAIN_CONTROL port map(IF_ID(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);
--InstrDec: ID port map (clk, Instruction, WD, ce, RegDst, RegWrite, ExtOp, RD1, RD2, ExtImm, Fct, sa);
InstrDec: ID port map(clk, IF_ID(15 downto 0), WD, ce, ID_EX(8), ID_EX(1), ExtOp, RD1, RD2, ExtImm, Fct, sa, MEM_WB(36 downto 34));
--ExecUnit: EXEC port map(PC1, RD1, RD2, ExtImm, Fct, sa, ALUSrc, ALUOp, BranchAddr, ALURes, zero, RegDst, RT, RD, WrAddr );
ExecUnit: EXEC port map(ID_EX(24 downto 9), ID_EX(40 downto 25), EX_MEM(52 downto 37), ID_EX(72 downto 57), ID_EX(75 downto 73), ID_EX(76), ID_EX(7), 
        ID_EX(6 downto 4), BranchAddr, ALURes, zero, ID_EX(8), ID_EX(79 downto 77), ID_EX(82 downto 80), WrAddr);
--MemoryUnit: MemUnit port map(clk, MemWrite, '1', ALURes, RD2, MemData, ALUResOut);
MemoryUnit: MemUnit port map(clk, EX_MEM(2), '1', EX_MEM(36 downto 21), EX_MEM(52 downto 37), MemData, ALUResOut);
TX_FinStateMachine: TX_FSM port map (sw(7 downto 0), tx_en, baud_en, enable(4), clk, RsTx, tx_rdy);
RX_FinStateMachine: RX_FSM port map (clk, RsRx, enable(4), rx_baud_en, rx_data, rx_rdy);
---------------------LAB 2-------------------------------
--enable <= (ce(0) or ce(1) or ce(2) or ce(3) or ce(4));

--process(ce, clk) --numarator afisat pe 7 segm
--begin
--    if rising_edge(clk) then
--        if  enable = '1' then 
--         count <= count + 1;
--     end if;
--    end if;
--end process;
        
--result <= count;
--end Behavioral;

--ALU:

--process(ce, clk)
--begin
--    if rising_edge(clk) then
--        if  enable = '1' then 
--            count <= count + 1;
--        end if;
--    end if;
--end process;
        
----zero extension
--op1 <= "000000000000" & sw(3 downto 0);
--op2 <= "000000000000" & sw(7 downto 4);
--op3 <= "00000000" & sw(7 downto 0);

--process(count) --the big mux
--begin
--    case count is
--        when "00" => result <= op1 + op2;
--        when "01" => result <= op1 - op2;
--        when "10" => result <= op3(13 downto 0) & "00";
--        when others => result <= "00" & op3(15 downto 2);
--    end case;
--end process;

-------------------------------LAB 3---------------------------
--ce <= (enable(0) or enable(1) or enable(2) or enable(3));

----counter
--process(enable, clk)
--begin
--    if rising_edge(clk) then
--        if  ce = '1' then 
--            count <= count + 1;
--        end if;
--    end if;
--end process;

----ROM
--do <= rom(conv_integer(count));
--result <= do; --afisez continutul ROM

----------------LAB 5------------------
ce <= (enable(0) or enable(1) or enable(2));

--counter
process(enable, clk)
begin
    if rising_edge(clk) then
        if  ce = '1' then 
            count <= count + 1;
        end if;
    end if;
end process;

----------------------------------LAB 5--------------
--process(sw(7))
--begin
--    if (sw(7) = '0') then
--        result <= Instruction;
--    else 
--        result <= PC1;
--    end if;
--end process;

-----------------WRITE BACK UNIT-------------
--PCSrc <= Branch and zero;
PCSrc <= EX_MEM(3) and EX_MEM(20);

--process(MemtoReg, MemData, ALUResOut)
--begin
--    if (MemtoReg = '0') then
--        WB_out <= ALUResOut;
--    else
--        WB_out <= MemData;
--    end if;
--end process;



--JumpAddr <= "000" & Instruction(12 downto 0);

JumpAddr <= "000" & IF_ID(12 downto 0);



--reg IF_ID
process(clk, ce)
begin
    if(rising_edge(clk)) then
        IF_ID(31 downto 16) <= PC1;
        IF_ID(15 downto 0) <= Instruction;
    end if;
end process;


--reg ID_EX
process(clk, ce)
begin
    if(rising_edge(clk)) then
        ID_EX(40 downto 25) <= RD1;
        ID_EX(56 downto 41) <= RD2;
        ID_EX(72 downto 57) <= ExtImm;
        ID_EX(75 downto 73) <= Fct;
        ID_EX(76) <= sa;
        ID_EX(24 downto 9) <= IF_ID(31 downto 16);  --PC1
        ID_EX(7) <= ALUSrc;
        ID_EX(6 downto 4) <= ALUOp;
        ID_EX(0) <= MemtoReg;
        ID_EX(1) <= RegWrite;
        ID_EX(2) <= MemWrite;
        ID_EX(3) <= Branch;
        ID_EX(8) <= RegDst;
        ID_EX(79 downto 77) <= IF_ID(9 downto 7);   --Instruction(9 downto 7)
        ID_EX(82 downto 80) <= IF_ID(6 downto 4);   --Instruction(6 downto 4)
        end if;
end process;
        
--reg EX_MEM
process(clk, ce)
begin
    if(rising_edge(clk)) then 
        EX_MEM(0) <= ID_EX(0);      --MemtoReg
        EX_MEM(1) <= ID_EX(1);      --RegWrite
        EX_MEM(2) <= ID_EX(2);      --MemWrite
        EX_MEM(3) <= ID_EX(3);      --Branch
        EX_MEM(19 downto 4) <= BranchAddr;
        EX_MEM(20) <= zero;
        EX_MEM(36 downto 21) <= ALURes;
        EX_MEM(52 downto 37) <= RD2;
        EX_MEM(55 downto 53) <= WrAddr;
    end if;
end process;
        
--reg MEM_WB
process(clk, ce)
begin
    if(rising_edge(clk)) then
        MEM_WB(0) <= EX_MEM(0);     --MemtoReg
        MEM_WB(1) <= EX_MEM(1);     --RegWrite
        MEM_WB(17 downto 2) <= MemData;   
        MEM_WB(33 downto 18) <= ALUResOut;       --ALURes
        MEM_WB(36 downto 34) <= EX_MEM(55 downto 53);       --WrAddr
    end if;
end process;

process(MEM_WB(0), MEM_WB(17 downto 2), MEM_WB(33 downto 18))
begin
    if(MEM_WB(0) = '0') then 
        WB_out <= MEM_WB(33 downto 18);
    else
        WB_out <= MEM_WB(17 downto 2);
    end if;
end process;

---------------END OF WRITE BACK UNIT --------------
WD <= WB_out;
        
---------------------------------------------------
------------------TX_FSM processes-----------------
---------------------------------------------------

------------------BAUD_EN-------------------------
process(clk)
begin
    if(rising_edge(clk)) then
        
        if (tx_count = "10100010110000") then
            baud_en <= '1';
            tx_count <= "00000000000000";
        else
            baud_en <= '0';
            tx_count <= tx_count + 1;
        end if;
    end if;
end process;

-----------------TX_EN------------------------------
process (clk)
begin
    if(rising_edge(clk)) then
        if (enable(3) = '1') then
            tx_en <= '1';
        else
            if (baud_en = '1') then
                tx_en <= '0';
            end if;
        end if;
    end if;
end process;

----------------RX_BAUD_EN------------------
process(clk)
begin
    if(rising_edge(clk)) then
        rx_count <= rx_count + 1;
        
        if (rx_count = "0000001010001011") then
            rx_baud_en <= '1';
            rx_count <= "0000000000000000";
        else
            rx_baud_en <= '0';
        end if;
    end if;
end process;


--process(sw(7 downto 5), Instruction)
--begin
--    case sw(7 downto 5) is
--        when "000" => result <= Instruction;
--        when "001" => result <= PC1;
--        when "010" => result <= RD1;
--        when "011" => result <= RD2;
--        when "100" => result <= ExtImm;
--        when "101" => result <= ALURes;
--        when "110" => result <= MemData;
--        when "111" => result <=  WD;
--        --when "111" => result <= result_test;
--       -- when others => result <= x"0000";
--    end case;
--end process;

 process(sw,Instruction,RD1,RD2,WD,PC1)
    begin
        case sw(15 downto 12) is
            when "0000"=>result<=Instruction;
            when "0001"=>result<=PC1;
            when "0010"=>result<=RD1; 
            when "0011"=>result<=RD2;
            when "0100"=>result<=ExtImm;
            when "0101"=>result<=ALURes;
            when "0110"=>result<=MemData;
            when "0111"=>result<=WD;
            when "1000"=>result <= ID_EX(40 downto 25);     --RD1
            when "1001"=>result <= ID_EX(72 downto 57);     --ExtImm
            when "1010"=>result <= EX_MEM(36 downto 21);    --ALURes
            when "1011"=>result <="0000000000000" & Fct;
            when "1100"=> result<="0000000000000" & WrAddr;
            when "1101"=> result<=ALUResOut;
            when others=>result<="0000000000000000";
         end case;
    end process;

process(RegDst, ExtOp, ALUSrc,Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite)
begin
    led(0) <= RegDst;
    led(1) <= ExtOp;
    led(2) <= ALUSrc;
    led(3) <= Branch;
    led(4) <= Jump;
    led(7 downto 5) <= ALUOp;
    led(8) <= MemWrite;
    led(9) <= MemtoReg;
    led(10) <= RegWrite;
    led(15) <= zero;
end process;

        

end Behavioral;
