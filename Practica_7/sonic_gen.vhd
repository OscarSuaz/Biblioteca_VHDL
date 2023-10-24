library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sonico is
Port(clk: in STD_LOGIC;
    inicio: in std_LOGIC;
    sensor_disp: out STD_LOGIC;
    sensor_eco: in STD_LOGIC;
    segmentos: out STD_LOGIC_VECTOR (7 downto 0);
    segmentos2: out STD_LOGIC_VECTOR (7 downto 0);
    segmentos3: out STD_LOGIC_VECTOR (7 downto 0);
    --cent: out std_logic_vector (3 downto 0);
    --dec: out std_logic_vector (3 downto 0);
    --unid: out std_logic_vector (3 downto 0);
    
    cm: out std_logic_vector (8 downto 0));
end sonico;

architecture Behavioral of sonico is
    signal cuenta: unsigned(16 downto 0) := (others =>'0');
    signal centimetros: unsigned(15 downto 0):= (others =>'0');
    signal centimetros_unid: unsigned(3 downto 0) := (others =>'0');
    signal centimetros_dece: unsigned(3 downto 0) := (others =>'0');
    signal centimetros_cente: unsigned(3 downto 0) := (others=>'0');
    signal sal_unid: unsigned(3 downto 0) := (others =>'0');
    signal sal_dece: unsigned(3 downto 0) := (others =>'0');
    signal sal_cente: unsigned(3 downto 0) := (others =>'0');
    signal digito: unsigned(3 downto 0) := (others =>'0');
    signal digito2: unsigned(3 downto 0) := (others =>'0');
    signal digito3: unsigned(3 downto 0) := (others =>'0');
    signal eco_pasado: std_logic :='0';
    signal eco_sinc: std_logic :='0';
    signal eco_nsinc: std_logic := '0';
    signal espera: std_logic :='0';
    signal siete_seg_cuenta: unsigned(15 downto 0) := (others => '0');



begin

    siete_seg: process(clk)
    begin
        if rising_edge(clk) then
            if siete_seg_cuenta(siete_seg_cuenta'high)='1' then
                digito <= sal_unid;
                digito2 <= sal_dece;
                digito3 <=sal_cente;
            end if;
            siete_seg_cuenta <= siete_seg_cuenta +1;
        end if;
    end process;

    Decodificador: process (digito)
    begin
        if    digito=X"0" then segmentos <= x"81";  -- G F E D C B A dp
        elsif digito=X"1" then segmentos <= x"F3";
        elsif digito=X"2" then segmentos <= x"49";
        elsif digito=X"3" then segmentos <= x"61";
        elsif digito=X"4" then segmentos <= x"33";
        elsif digito=X"5" then segmentos <= x"25";
        elsif digito=X"6" then segmentos <= x"05";
        elsif digito=X"7" then segmentos <= x"F1";
        elsif digito=X"8" then segmentos <= x"01";
        elsif digito=X"9" then segmentos <= x"21";
        elsif digito=X"a" then segmentos <= x"11";
        elsif digito=X"b" then segmentos <= x"07";
        elsif digito=X"c" then segmentos <= x"8D";
        elsif digito=X"d" then segmentos <= x"43";
        elsif digito=X"e" then segmentos <= x"0D";
        else
            segmentos<= X"1D";
        end if;

        if    digito2=X"0" then segmentos2 <= x"81";  -- G F E D C B A dp
        elsif digito2=X"1" then segmentos2 <= x"F3";
        elsif digito2=X"2" then segmentos2 <= x"49";
        elsif digito2=X"3" then segmentos2 <= x"61";
        elsif digito2=X"4" then segmentos2 <= x"33";
        elsif digito2=X"5" then segmentos2 <= x"25";
        elsif digito2=X"6" then segmentos2 <= x"05";
        elsif digito2=X"7" then segmentos2 <= x"F1";
        elsif digito2=X"8" then segmentos2 <= x"01";
        elsif digito2=X"9" then segmentos2 <= x"21";
        elsif digito2=X"a" then segmentos2 <= x"11";
        elsif digito2=X"b" then segmentos2 <= x"07";
        elsif digito2=X"c" then segmentos2 <= x"8D";
        elsif digito2=X"d" then segmentos2 <= x"43";
        elsif digito2=X"e" then segmentos2 <= x"0D";
        else
            segmentos2<= X"1D";
        end if;


        if    digito3=X"0" then segmentos3 <= x"81";  -- G F E D C B A dp
        elsif digito3=X"1" then segmentos3 <= x"F3";
        elsif digito3=X"2" then segmentos3 <= x"49";
        elsif digito3=X"3" then segmentos3 <= x"61";
        elsif digito3=X"4" then segmentos3 <= x"33";
        elsif digito3=X"5" then segmentos3 <= x"25";
        elsif digito3=X"6" then segmentos3 <= x"05";
        elsif digito3=X"7" then segmentos3 <= x"F1";
        elsif digito3=X"8" then segmentos3 <= x"01";
        elsif digito3=X"9" then segmentos3 <= x"21";
        elsif digito3=X"a" then segmentos3 <= x"11";
        elsif digito3=X"b" then segmentos3 <= x"07";
        elsif digito3=X"c" then segmentos3 <= x"8D";
        elsif digito3=X"d" then segmentos3 <= x"43";
        elsif digito3=X"e" then segmentos3 <= x"0D";
        else
            segmentos3<= X"1D";
        end if;
    end process;





    Trigger:process(clk,inicio)
        signal temporal: std_logic_vector(8 downto 0);
        begin
        if rising_edge(clk) then
            if espera='0' then
                if inicio = '0' then
                    sensor_disp<='0';
                    espera <='1';
                    cuenta<=(others =>'0');
                else
                    sensor_disp <='1';
                    cuenta<= cuenta+1;
                end if;
            elsif eco_pasado = '0' and eco_sinc = '1' then
                cuenta<=(others =>'0');
                centimetros <= (others =>'0');
                centimetros_unid <= (others =>'0');
                centimetros_dece <= (others =>'0');
                centimetros_cente <= (others =>'0');
            elsif eco_pasado = '1' and eco_sinc = '0' then
                sal_unid <= centimetros_unid;
                sal_dece <= centimetros_dece;
                sal_cente <= centimetros_cente;
            elsif cuenta = 2900-1 then
                if centimetros_unid = 9 then
                    centimetros_unid <=(others =>'0');
                    centimetros_dece <= centimetros_dece+1;
                    if centimetros_dece = 9 then
                        centimetros_dece<=(others =>'0');
                        centimetros_cente <= centimetros_cente+1;
                    end if;
                else
                    centimetros_unid <= centimetros_unid+1;
                end if;
                
                centimetros <= centimetros+1;
                temporal <= centimetros(8 downto 0);
                cm <= temporal;
                cuenta <= (others =>'0');
                if centimetros = 3448 then
                    espera <='0';
                end if;
            else
            cuenta <=cuenta+1;
            end if;
                eco_pasado<=eco_sinc;
                eco_sinc <= eco_nsinc;
                eco_nsinc <= sensor_eco;
        end if;
    end process;

end Behavioral;
