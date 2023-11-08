library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RX is
port (
    Clk: in std_logic;
    LEDS:out std_logic_vector(7 downto 0);
    RX_WIRE: in std_logic
) ;
end RX;

architecture Behavioral of RX is
    signal BUFF: std_logic_vector(9 downto 0);
    signal Flag: std_logic:='0';
    signal PRE: integer range 0 to 5208 :=0;
    signal INDICE: integer range 0 to 9 :=0;
    signal PRE_val: integer range 0 to 41600;
    signal baud: std_logic_vector(2 downto 0);

    begin
        RX_dato : process(ckl)
        begin
            if (Clk'event and Clk='1') then
                if (Flag='0' and RX_WIRE='0' ) then
                    Flag<='1';
                    indice <=0;
                    pre <=0;
                end if;
                if (Flag='1' ) then
                    buff(indice) <= RX_wire;
                    if (PRE < PRE_val) then
                        PRE<=PRE+1;
                    else
                        PRE<=0;
                    end if;
                    if (PRE=PRE_VAL/2) then
                        if (indice < 9) then
                            indice <= indice + 1;
                        else
                            if (BUFF(0)='0' and BUFF(9)='1' ) then
                                LEDS<=BUFF(8 DOWNTO 1);
                            else
                                LEDS<="00000000";
                            end if;
                            Flag<='0';
                        end if;
                    end if;
                end if;
            end if;
        end process RX_dato;

        baud<="011";
        with (baud) select
            PRE_val <=  41600 when "000",
                        20800 when "001",
                        10400 when "010",
                        5200 when "011",
                        2600 when "100",
                        1300 when "101",
                        866 when "110",
                        432 when others;
end Behavioral;