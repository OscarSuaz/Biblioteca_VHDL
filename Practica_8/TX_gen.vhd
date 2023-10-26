library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TX_gen is
    port (
        clk: in std_logic;
        dato: in std_logic_vector(7 downto 0);
        inicio: in std_logic;
        baud: in std_logic_vector(2 downto 0);
        tx_wire: out std_logic;
        bandera: out std_logic;

    );
end entity TX_gen;

architecture behavioral of TX_gen is
    signal conta: integer :=0;
    signal valor: integer :=70000;
    signal start: std_logic;
    signal dato: std_logic_vector(7 downto 0);
    signal pre: integer range 0 to 5208 :=0;
    signal indice: integer range 0 to 9 :=0;
    signal buff: std_logic_vector(9 downto 0);
    signal flag: std_logic :='0';
    signal termino: std_logic :='0';
    signal pre_val: integer range 0 to 41600;
    signal i: integer range 0 to 4;
    signal pulso: std_logic:='0';
    signal contador: integer range 0 to 49999999 :=0;
    signal dato_bin: std_logic_vector(3 downto 0);
    signal hex_val: std_logic_vector(7 downto 0) := (others => '0');
begin
    tx_divisor : process( clk )
    begin
        if rising_edge(clk) then
            contador<=contador+1;
            if contador<140000 then
                pulso <='1';
            else
                pulso <='0';
            end if;
        end if;
    end process tx_divisor;

    tx_prepara : process( clk,pulso )
        type arreglo is array (0 to 1) of std_logic_vector(7 downto 0);
        variable asc_dato: arreglo := (X"30",X"0A");
    begin
        asc_dato(0) := hex_val;
        if pulso='1' and inicio ='1' then
            if rising_edge(clk) then
                if conta=valor then
                    conta <=0;
                    start <='1';
                    dato <= asc_dato(i);
                    if i=1 then
                        i<=0;
                    else
                        i <=i+1;
                    end if;
                    else
                        conta<=conta+1;
                        start<='0';
                end if;
            end if;
        end if;
    end process tx_prepara;

    tx_envia : process( clk,start,dato )
    begin
        if clk'event and clk='1' then
            if flag ='0' and start='1' then
                flag<='1';
                buff(0)<='0';
                buff(9)<='1';
                buff(8 downto 1) <=dato;
                termino <='1';
            end if;
            if flag='1' then
                termino <= '1';
                if pre<pre_val then
                    pre<=pre+1;
                else
                    pre<=0;
                end if;
                if pre=pre_val/2 then
                    tx_wire<=buff(indice);
                    if indice<9 then
                        indice<=indice+1;
                    else
                        flag<='0';
                        indice<=0;
                    end if;
                end if;
            end if;
        end if;
    end process tx_envia;

    led<=pulso;
    dato_bin<=sw;
    bandera<=termino;


    hex_val <= dato_bin;

    with baud select
        pre_val <= 41600 when "000", --1200 bauds
        20800 when "001", --2400 bauds
        10400 when "010", --4800 bauds
        5200 when "011", --9600 bauds
        2600 when "100", --19200 bauds
        1300 when "101", --38400 bauds
        866 when "110", --57600 bauds
        432 when others; --115200
    
end architecture behavioral;