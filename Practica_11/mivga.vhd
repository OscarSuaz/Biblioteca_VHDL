library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mivga is
    port ( clk50MHz: in std logic;

    red: out std logic vector (3 downto 0);
    green: out std logic vector (3 downto 0);
    blue: out std logic vector (3 downto 0);
    h sync: out std logic;
    
    v_sync: out std logic;
    
    dipsw: in std logic vector (3 downto 0); -- numeros para
    a,b,C,d,e,f,g: out std logic ); -- decodificador
    
end entity mivga;

constant cero: std logic vector (6 downto 0):="0111111"; --gfedcba

constant uno: std logic vector (6 downto 0) :="0000110";

constant dos: std logic vector (6 downto 0):="1011011";

constant tres: std logic vector (6 downto 0):="1001111";

constant cuatro: std logic vector (6 downto 0):="1100110";

constant cinco: std logic vector (6 downto 0) :="1101101";

constant seis: std logic vector (6 downto 0):="1111101";

constant siete: std logic vector (6 downto 0):="0000111";

constant ocho: std logic vector (6 downto 0):="1111111";

constant nueve: std logic vector (6 downto 0):="1110011";

constant ri:std logic vector (3 downto 0):=(OTHERS => '1");

constant r0:std logic vector (3 downto 0) :=(OTHERS => '0');

constant gl:std logic vector (3 downto 0):=(OTHERS => '1');

constant g0:std logic vector (3 downto 0):=(OTHERS => '0');

constant bl:std logic vector (3 downto 0):=(OTHERS => '1');

constant b0:std logic vector (3 downto 0) :=(OTHERS => '0');

-- variable a,b,c,d,e,f: std logic;

signal conectornum:std logic vector (6 downto 0); -- coneccion del
—-- decodificador con image gen

with dipsw select conectornum <= “-decodificador para los números
"0111111" when "0000",
"0000110" when "0001",
"1011011" when "0010",
"1001111" when "0011",
"1100110" when "0100",
"1101101" when "0101",
"1111101" when "0110",
"0000111" when "0111",
"1111111" when "1000",
"1110011" when "1001",
"0000000" when others;

when uno=>
if ((row > 210 and row <240) and
(column>140 and column<150)) THEN -- b verde
red <= (OTHERS => '0');
green <= (OTHERS => '1');
blue <= (OTHERS => '0');
elsif ((row > 250 and row <280) and
(column>140 and column<150)) THEN -- ¢ rojo
red <= (OTHERS => '1');;
green <= (OTHERS => '0');
blue <= (OTHERS => '0');
else —-—- fondo
red <= (OTHERS => '0');
green <= (OTHERS => '0');
blue <= (OTHERS => '0');
end if;

when dos=>
if ((row > 200 and row <210) and
(column>110 and column<140)) THEN -- a azul

red <= (OTHERS => '0');
green <= (OTHERS => '0');
blue <= (OTHERS => '1');

elsif ((row > 210 and row <240) and

(column>140 and column<150)) THEN -- b verde
Red <= (OTHERS => '0');
green <= (OTHERS => '1');
blue <= (OTHERS => '0');
elsif ((row > 280 and row <290) and
(column>110 and column<140)) THEN -- d blanco
Red <= (OTHERS => '1');
green <= (OTHERS => '1');
blue <= (OTHERS => '1');
elsif ((row > 250 and row <280) and
(column>100 and column<110)) THEN -- e cian
Red <= (OTHERS => '0');
Green <= (OTHERS => '1')
Blue <= (OTHERS => '1');
elsif ((row > 240 and row <250) and
(column>110 and column<140)) THEN -- gy violeta
red <= (OTHERS => '1');
green <= (OTHERS => '0');
blue <= (OTHERS => '1');
else -- fondo
red <= (OTHERS => '0');
green <= (OTHERS => '0');
blue <= (OTHERS => '0');
end if;


when nueve=>

if ((row > 200 and row <210) and
(column>110 and column<140)) THEN -- a azul
red <= (OTHERS => '0');
green <= (OTHERS => '0');
blue <= (OTHERS => '1');
elsif ((row > 210 and row <240) and
(column>140 and column<150)) THEN -- b verde
red <= (OTHERS => '0'");
green <= (OTHERS => '1');
blue <= (OTHERS => '0');
elsif ( (row > 250 and row <280) and

(column>140 and column<150)) THEN -- € rojo
red <= (OTHERS => '1');
green <= (OTHERS => '0');
blue <= (OTHERS => '0');
elsif ((row > 210 and row <240) and
(column>100 and column<110)) THEN -- £ amarillo
red <= (OTHERS => '1');
green <= (OTHERS => '1');
blue <= (OTHERS => '0');

elsif ((row > 240 and row <250) and
    (column>110 and column<140)) then
    red <= (OTHERS => '1');
    green <= (OTHERS => '0');
    blue <= (OTHERS => '1');
else -- fondo
    red <= (OTHERS => '0');
    green <= (OTHERS => '0');
    blue <= (OTHERS => '0');
end if;


    