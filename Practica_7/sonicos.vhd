library IEEE;
use IEEE.STD LOGIC 1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity sonicos is
Port (clk: in STD_LOGIC;
sensor_disp: out STD LOGIC;
sensor_eco: in STD_LOGIC;
anodos: out STD_LOGIC_VECTOR (3 downto 0);
segmentos: out STD_LOGIC_VECTOR (7 downto 0));
end sonicos;
architecture Behavioral of sonicos is
signal cuenta: unsigned (16 downto 0) := (others => '0'); 
signal centimetros: unsigned (15 downto 0) := (others => '0'); 
signal centimetros_unid: unsigned (3 downto 0) := (others => '0'); 
signal centimetros_dece: unsigned (3 downto 0) := (others => '0'); 
signal sal_unid: unsigned (3 downto 0) := (others => '0'); 
signal sal_dece: unsigned (3 downto 0) := (others => '0'); 
signal digito: unsigned (3 downto 0) := (others => '0');
signal eco_pasado: std_logic := '0'; signal eco_sinc: std_logic := '0'; 
signal eco_nsinc: std_logic := '0';
signal espera: std_logic:= '0';
signal siete_seg_cuenta: unsigned (15 downto 0) = (others => '0'); begin

begin
anodos (1 downto 0) <= "11";
siete_seg: process (clk)
begin
if rising edge (clk) then
if siete_seg_cuenta (siete_seg_cuenta'high) = '1' then
digito <= sal_unid;
anodos (3 downto 2) <= "01";
else
digito <= sal_dece;
anodos (3 downto 2) <= "10";
end if;
siete_seg_cuenta <= siete_seg_cuenta +1;
end if;
end process;


Trigger : process( clk )
begin
if rising_edge(clk) then
if espera='0' then
if cuenta=500 then
sensor_disp<='0';
espera <='1';
cuenta <= (others => '0');
else
sensor_disp <='1';
cuenta<=cuenta+1;
end if;
elsif eco_pasado='0' and eco_sinc='1' then
cuenta < (others => '0'); 
centimetros <= (others => '0'); 
centimetros_unid <= (others => '0'); 
centimetros dece <= (others => '0'); 
elsif eco_pasado '1' and eco_sinc ='0' then
sal_unid<= centimetros unid; 
sal_dece <= centimetros_dece; 
elsif cuenta = 2900-1 then
if centimetros unid = 9 then
centimetros unid <= (others => '0'); 
centimetros_dece <= centimetros_dece + 1;
else
centimetros_unid<= centimetros_unid + 1;
end if;
centimetros <= centimetros + 1;
cuenta<= (others => '0');
if centimetros =3448 then
espera <= '0';
end if;
else
cuenta <= cuenta + 1;
end if;
eco_pasado<= eco_sinc; 
eco_sinc <=eco_nsinc; 
eco_nsinc <= sensor_eco;
end if;
end process; -- Trigger
