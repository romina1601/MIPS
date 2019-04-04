library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity TX_FSM is
    Port ( tx_data : in STD_LOGIC_VECTOR (7 downto 0);
           tx_en : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           tx : out STD_LOGIC;
           tx_rdy : out STD_LOGIC);
end TX_FSM;

architecture Behavioral of TX_FSM is

signal bit_cnt: std_logic_vector(2 downto 0);
type state_type is(idle, start, bits, stop);
signal state: state_type;

begin

process(clk, rst, bit_cnt, tx_en)
begin
    if(rst = '1') then
        state <= idle;
    else 
        if (rising_edge(clk)) then
            if (baud_en = '1') then
                case state is
                    when idle =>
                        if (tx_en = '1') then
                            state <= start;
                            bit_cnt <= "000";
                        end if;
                     
                     when start =>
                        state <= bits;
                     
                     when bits =>
                        if ( bit_cnt = "111") then
                            state <= stop;
                        else
                            bit_cnt <= bit_cnt + 1;
                            state <= bits;
                        end if;
                     
                     when stop =>
                        state <= idle;
                 end case;
             end if;
          end if;
    end if;
 end process;
 
 process(state)
 begin
    case state is
        when idle => tx <= '1';
        when start => tx <= '0';
        when bits => tx <= tx_data(conv_integer(bit_cnt));
        when stop => tx <= '1';
    end case;
end process;

end Behavioral;
