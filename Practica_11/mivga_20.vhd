library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity mivga_20 is

generic(

	constant h_pulse : integer := 96;
	constant h_bp : integer := 48;
	constant h_pixels : integer := 640;
	constant h_fp : integer := 16;
	
	constant v_pulse : integer := 2;
	constant v_bp : integer := 33;
	constant v_pixels : integer := 480;
	constant v_fp : integer := 10;

	constant cero: std_logic_vector(6 downto 0):="0111111"; --GFEDCBA
	constant uno: std_logic_vector(6 downto 0):="0000110";
	constant dos: std_logic_vector(6 downto 0):="1011011";
	constant tres: std_logic_vector(6 downto 0):="1001111";
	constant cuatro: std_logic_vector(6 downto 0):="1100110";
	constant cinco: std_logic_vector(6 downto 0):="1101101";
	constant seis: std_logic_vector(6 downto 0):="1111101";
	constant siete: std_logic_vector(6 downto 0):="0000111";
	constant ocho: std_logic_vector(6 downto 0):="1111111";
	constant nueve: std_logic_vector(6 downto 0):="1110011";
	constant diez: std_logic_vector(6 downto 0):="1110111"; --A
	constant once: std_logic_vector(6 downto 0):="1111100"; --B
	constant doce: std_logic_vector(6 downto 0):="0111001"; --C
	constant trece: std_logic_vector(6 downto 0):="1011110"; --D
	constant catorce: std_logic_vector(6 downto 0):="1111001"; --E
	constant quince: std_logic_vector(6 downto 0):="1110001"; --F
	constant diesiseis: std_logic_vector(6 downto 0):="0000001"; 
	constant diesisiete: std_logic_vector(6 downto 0):="0000010"; 
	constant diesiocho: std_logic_vector(6 downto 0):="0000100" ;
	constant diesinueve: std_logic_vector(6 downto 0):="0001000" ;
	constant veinte: std_logic_vector(6 downto 0):="0010000" 
	
);

port(	clk50MHz: 	in std_logic;
		red: 			out std_logic_vector (3 downto 0); -- al monitor
		green: 		out std_logic_vector (3 downto 0);
		blue: 		out std_logic_vector (3 downto 0);
	
		h_sync: 		out std_logic;
		v_sync: 		out std_logic;
		
		reset:		in std_logic;
		--dipsw: 		in std_logic_vector(3 downto 0); -- numeros para
		
		A,B,C,D,E,F,G: out std_logic ); -- decodificador
end entity mivga_20;

architecture behavioral of mivga_20 is

	signal h_period : integer := h_pulse + h_bp + h_pixels + h_fp;
	signal v_period : integer := v_pulse + v_bp + v_pixels + v_fp;

	signal h_count : integer range 0 to h_period - 1 := 0;
	signal v_count : integer range 0 to v_period - 1 := 0; 

	signal column 	: integer range 0 to h_period - 1 := 0;
	signal row		: integer range 0 to v_period - 1 := 0;
	
	signal conectornum	: std_logic_vector(6 downto 0);
	
	signal reloj_pixel 	: std_logic;
	signal clklow			: std_logic;
	
	subtype state is std_logic_vector (4 downto 0);
	signal present_state, next_state: state;
	constant state0: state:= "00000";
	constant state1: state:= "00001";
	constant state2: state:= "00010";
	constant state3: state:= "00011";
	constant state4: state:= "00100";
	constant state5: state:= "00101";
	constant state6: state:= "00110";
	constant state7: state:= "00111";
	constant state8: state:= "01000";
	constant state9: state:= "01001";
	constant state10: state:= "01010";
	constant state11: state:= "01011";
	constant state12: state:= "01100";
	constant state13: state:= "01101";
	constant state14: state:= "01110";
	constant state15: state:= "01111";
	constant state16: state:= "10000";
	constant state17: state:= "10001";
	constant state18: state:= "10010";
	constant state19: state:= "10011";
	constant state20: state:= "10100";
	
	signal conteo	: integer := 0;
	signal contador: std_logic;

begin

relojpixel: process (clk50MHz) is
begin
	if rising_edge(clk50MHz) then
		reloj_pixel <= not reloj_pixel;
	end if;
end process relojpixel; -- 25mhz


lowclk: process(clk50mhz)
begin
	if (clk50mhz'event and (clk50mhz ='1')) then
		conteo<=conteo+1;
		
		if (conteo=1) then
			conteo<=0;
			clklow<=not(clklow);
		end if;
		
	end if;
end process;


conta1: process(clklow)
begin
	if rising_edge(clklow) then
	
		if (reset='1') then
			present_state <= state0;
		else
			present_state<= next_state;
		end if;
		
	end if;
end process;

Divi: process (clk50MHz)
variable cuenta: std_logic_vector(27 downto 0) := x"0000000";
begin
	if rising_edge (clk50MHz) then
	
		if cuenta = x"48009e0" then
			cuenta := x"0000000";
		else
			cuenta := cuenta + 1;
		end if;
		
	end if;
	contador <= cuenta(24);
end process;

conta2: process(present_state, contador)
begin

	if rising_edge(contador) then
	
		case present_state is
		
		when state0=>
			next_state<= state1;
		
		when state1=>
			next_state<= state2;
		
		when state2=>
			next_state<= state3;
		
		when state3=>
			next_state<= state4;
		
		when state4=>
			next_state<= state5;
		
		when state5=>
			next_state<= state6;
		
		when state6=>
			next_state<= state7;
			
		when state7=>
			next_state<= state8;
		
		when state8=>
			next_state<= state9;
		
		when state9=>
			next_state<= state10;
		
		when state10=>
			next_state<= state11;
		
		when state11=>
			next_state<= state12;
		
		when state12=>
			next_state<= state13;
		
		when state13=>
			next_state<= state14;
		
		when state14=>
			next_state<= state15;
		
		when state15=>
			next_state<= state16;
			
		when state16=>
			next_state<= state17;
			
		when state17=>
			next_state<= state18;
			
		when state18=>
			next_state<= state19;
			
		when state19=>
			next_state<= state20;
			
		when state20=>
			next_state<= state0;
		
		when others=>
			next_state<= state0;
		
		end case;
		
	
	end if;
	
end process;


contadores : process (reloj_pixel) -- H_periodo=800, V_periodo=525
begin
	if rising_edge(reloj_pixel) then
	
		if h_count<(h_period-1) then
		
			h_count<=h_count+1;
		else
			h_count<=0;
			
			if v_count<(v_period-1) then
				v_count<=v_count+1;
			else
				v_count<=0;
			end if;
		
		end if;
		
	end if;
end process contadores;


senial_hsync : process (reloj_pixel) --h_pixel+h_fp+h_pulse= 784
begin
	if rising_edge(reloj_pixel) then

		if h_count>(h_pixels + h_fp) or h_count>(h_pixels + h_fp + h_pulse) then
			h_sync<='0';
		else
			h_sync<='1';
		end if;
	end if;
end process senial_hsync;


senial_vsync : process (reloj_pixel) --vpixels+v_fp+v_pulse=525
begin --checar si se en parte visible es 1 o 0
	if rising_edge(reloj_pixel) then
		
		if v_count>(v_pixels + v_fp) or v_count>(v_pixels + v_fp + v_pulse) then
			v_sync<='0';
		else
			v_sync<='1';
		end if;
	end if;
end process senial_vsync;


coords_pixel: process(reloj_pixel)
begin --asignar una coordenada en parte visible
	if rising_edge(reloj_pixel) then
		
		if (h_count < h_pixels) then
			column <= h_count;
		end if;
		
		if (v_count < v_pixels) then
			row <= v_count;
		end if;
		
	end if;
end process coords_pixel;



with present_state select conectornum <= --decodificador para los números
	"0111111" when "00000",
	"0000110" when "00001",
	"1011011" when "00010",
	"1001111" when "00011",
	"1100110" when "00100",
	"1101101" when "00101",
	"1111101" when "00110",
	"0000111" when "00111",
	"1111111" when "01000",
	"1110011" when "01001",
	"1110111" when "01010",
	"1111100" when "01011",
	"0111001" when "01100",
	"1011110" when "01101",
	"1111001" when "01110",
	"1110001" when "01111",
	"0000001" when "10000",
	"0000010" when "10001",
	"0000100" when "10010",
	"0001000" when "10011",
	"0010000" when "10100",
	"0000000" when others;
	
generador_imagen: process(row, column, conectornum) is
begin

	case conectornum is
	
	when cero=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>100 and column<110)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			E <= '1';
			F <= '1';
		end if;

	when uno=>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			B <= '1';
			C <= '1';
		end if;
		
	when dos=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>100 and column<110)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			D <= '1';
			E <= '1';
			G <= '1';
		end if;
		
	when tres=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			G <= '1';
		end if;
	
	when cuatro=>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			B <= '1';
			C <= '1';
			F <= '1';
			G <= '1';
		end if;
		
	when cinco=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			C <= '1';
			D <= '1';
			F <= '1';
			G <= '1';
		end if;
	
	when seis=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>100 and column<110)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			C <= '1';
			D <= '1';
			E <= '1';
			F <= '1';
			G <= '1';
		end if;
	
	when siete=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
		end if;	

	when ocho=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>100 and column<110)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			E <= '1';
			F <= '1';
			G <= '1';
		end if;
		
	when nueve=>
		if ((row > 200 and row <210) and (column>110 and column<140)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>110 and column<140)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 210 and row <240) and (column>100 and column<110)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>110 and column<140)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			F <= '1';
			G <= '1';
		end if;
		
	when diez =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		-----------------
	
		elsif ((row > 200 and row <210) and (column>180 and column<210)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>210 and column<220)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>210 and column<220)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>180 and column<210)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>170 and column<180)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 210 and row <240) and (column>170 and column<180)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			E <= '1';
			F <= '1';
			G <= '1';
		end if;
	
	when once =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 210 and row <240) and (column>210 and column<220)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>210 and column<220)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			B <= '1';
			C <= '1';
		end if;
	
	when doce =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 200 and row <210) and (column>180 and column<210)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>210 and column<220)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 280 and row <290) and (column>180 and column<210)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 250 and row <280) and (column>170 and column<180)) then -- E cian
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '1');
			E <= '0';
		elsif ((row > 240 and row <250) and (column>180 and column<210)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			D <= '1';
			E <= '1';
			G <= '1';
		end if;
	
	when trece =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 200 and row <210) and (column>180 and column<210)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 210 and row <240) and (column>210 and column<220)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>210 and column<220)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 280 and row <290) and (column>180 and column<210)) then -- D blanco
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '1');
			D <= '0';
		elsif ((row > 240 and row <250) and (column>180 and column<210)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			A <= '1';
			B <= '1';
			C <= '1';
			D <= '1';
			G <= '1';
		end if;
	
	when catorce =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 210 and row <240) and (column>210 and column<220)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>210 and column<220)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 210 and row <240) and (column>170 and column<180)) then -- F amarillo
			red <= (others => '1');
			green <= (others => '1');
			blue <= (others => '0');
			F <= '0';
		elsif ((row > 240 and row <250) and (column>180 and column<210)) then -- G violeta
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '1');
			G <= '0';
		else -- fondo
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '0');
			B <= '1';
			C <= '1';
			F <= '1';
			G <= '1';
		end if;
		
	when quince =>
		if ((row > 210 and row <240) and (column>140 and column<150)) then -- B verde
			red <= (others => '0');
			green <= (others => '1');
			blue <= (others => '0');
			B <= '0';
		elsif ((row > 250 and row <280) and (column>140 and column<150)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');
			C <= '0';
		elsif ((row > 200 and row <210) and (column>180 and column<210)) then -- A azul
			red <= (others => '0');
			green <= (others => '0');
			blue <= (others => '1');
			A <= '0';
		elsif ((row > 250 and row <280) and (column>210 and column<220)) then -- C rojo
			red <= (others => '1');
			green <= (others => '0');
			blue <= (others => '0');