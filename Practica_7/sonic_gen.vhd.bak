library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sonic_gen is
Port(clk: in STD_LOGIC;
    inicio: in std_LOGIC;
    sensor_disp: out STD_LOGIC;
    sensor_eco: in STD_LOGIC;
    cent: out std_logic_vector (3 downto 0);
    dec: out std_logic_vector (3 downto 0);
    unid: out std_logic_vector (3 downto 0);
    cm: out std_logic_vector (8 downto 0));
end sonic_geno;

architecture Behavioral of sonic_geno is
    signal cuenta: unsigned(16 downto 0) := (others =>'0');
    signal centimetros: unsigned(15 downto 0):= (others =>'0');
    signal centimetros_unid: unsigned(3 downto 0) := (others =>'0');
    signal centimetros_dece: unsigned(3 downto 0) := (others =>'0');
    signal centimetros_cente: unsigned(3 downto 0) := (others=>'0');
    signal sal_unid: unsigned(3 downto 0) := (others =>'0');
    signal sal_dece: unsigned(3 downto 0) := (others =>'0');
    signal sal_cente: unsigned(3 downto 0) := (others =>'0');
    signal eco_pasado: std_logic :='0';
    signal eco_sinc: std_logic :='0';
    signal eco_nsinc: std_logic := '0';
    signal espera: std_logic :='0';


begin
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
                cent <= sal_cente;
                dec <= sal_dece;
                unid <= sal_unid;
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
