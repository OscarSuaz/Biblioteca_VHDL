library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RX_Motor is
    port (
        clk: in std_logic;
        dato: in std_logic;
        SALIDA: out std_logic_vector(3 downto 0);
        baud: in std_logic_vector(2 downto 0)
    );
end entity RX_Motor;

architecture behevioral of RX_Motor is
    component RX_Gen is 
        port(
            Clk: in std_logic;
            DATO:out std_logic_vector(7 downto 0);
            RX_WIRE: in std_logic;
            bandera: out std_logic;
            baud: in std_logic_vector(2 downto 0)
        );
    end component;

    signal temporal: std_logic_vector(7 downto 0);
    signal valor: std_logic_vector(7 downto 0);
    signal activar: std_logic;

begin
    C1: RX_Gen port map(clk,valor,dato,activar,"011");
    
    lectura : process( clk,activar )
    begin
        if (rising_edge(clk)) then
            if (activar=='1') then
                temporal<=valor;
            end if;
        end if;
    end process ; -- lectura

    acciones : process( clk )
    begin
        if rising_edge(clk) then
            if temporal == X"49" then
                salida<="1000";
            elsif temporal ==X"44" then
                salida<="0001";
            elsif temporal ==X"41"then
                salida<="1111";
            elsif temporal ==X"54" then
                salida<="1100";
            elsif temporal ==X"4E" then
                salida<="0011";
            end if ;
        end if;
    end process ; -- acciones
end architecture behevioral;