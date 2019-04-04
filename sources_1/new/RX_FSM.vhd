library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity RX_FSM is
    Port ( clk : in STD_LOGIC;
           rx : in STD_LOGIC;
           rst : in STD_LOGIC;
           baud_en : in STD_LOGIC;
           rx_data : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rdy : out STD_LOGIC);
end RX_FSM;

architecture Behavioral of RX_FSM is
signal bit_cnt: std_logic_vector(2 downto 0);
signal baud_cnt: std_logic_vector(3 downto 0);
signal rx_temp: std_logic_vector(7 downto 0);
type state_type is(idle, start, bits, stop, waits);
signal state: state_type;

begin

process(clk, rst, bit_cnt, rx, baud_cnt)
begin
    if(rst = '1') then
        state <= idle;
    elsif (baud_en = '1') then
        if (rising_edge(clk)) then
            case state is
                when idle =>
                    if (rx = '0') then
                        state <= start;
                        bit_cnt <= "000";
                        baud_cnt <= "0000";
                    else
                        state <= idle;
                    end if;
                 
                 when start =>
                    if (rx = '1') then
                        state <= idle;
                    else
                        if(baud_cnt < "0111") then
                            state <= start;
                        elsif (baud_cnt = "0111" and rx = '0') then
                            state <= bits;
                            baud_cnt <= "0000";
                        end if;
                    end if;
                 
                 when bits =>
                        if (bit_cnt < "111") then
                            bit_cnt <= bit_cnt + 1;
                            rx_temp <= rx & rx_temp(7 downto 1);
                            state <= bits;
                        elsif (bit_cnt = "111") then
                            if(baud_cnt = "1111") then
                                state <= stop;
                             end if;
                        end if;             
                                      
                 when stop =>
                    if (baud_cnt < "1111") then
                        state <= stop;
                    elsif (baud_cnt = "1111") then
                        state <= waits;
                    end if;
                 
                 when waits =>
                    if (baud_cnt < "0111") then
                        state <= waits;
                    elsif (baud_cnt = "0111") then
                        state <= idle;
                    end if;
                    
             end case;
         end if;
    end if;
 end process;
 
 --output process
 process(state)
 begin
    case state is
        when waits => rx_data <= rx_temp;
        when others => rx_rdy <= '0';
    end case;
end process;

--baud_cnt process
process(baud_cnt, clk, baud_en)
begin
    if(baud_en = '1') then
        if (rising_edge(clk)) then
            baud_cnt <= baud_cnt + 1;
        end if;
   end if;
end process;


end Behavioral;
