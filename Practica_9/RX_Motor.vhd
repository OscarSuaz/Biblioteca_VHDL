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

	 component motorPasosGen is
			Port ( dir : in  STD_LOGIC; --0 horario, 1 antihorario
				rst : in std_logic;
            paso : in  STD_LOGIC; --Si se activa, se mueve un paso
            modo : in STD_LOGIC_VECTOR(1 downto 0); --00 Fase simple, 01 Fase doble, 10 Fase intermedia, 11 Modo bipolar
            MOT : out  STD_LOGIC_VECTOR(3 downto 0)
			); --Salida de los pines del motor
		end component;
	 
    signal temporal: std_logic_vector(7 downto 0);
    signal valor: std_logic_vector(7 downto 0);
    signal activar: std_logic;
	 
	 signal direccion: std_logic;
	 signal stop: std_logic;
	 signal step: std_logic;
	 signal clk_div : std_logic := '0';
    signal div : std_logic_vector(17 downto 0);

	 

begin
    C1: RX_Gen port map(clk,valor,dato,activar,"011");
    M1: motorPasosGen port map(direccion,stop,step,"00",salida);
	 
	process (clk,stop)--divisor
	begin
		if stop='0' then
			div <= (others=>'0');
		elsif clk'event and clk= '1' then
			div <= div + 1;
		end if;
	end process;
	clk_div <= div(16);
	 
    lectura : process( clk,activar )
    begin
        if (rising_edge(clk)) then
            if (activar ='1') then
                temporal<=valor;
            end if;
        end if;
    end process ; -- lectura

    acciones : process( clk )
		variable contador : integer := 0;
		variable pasos : integer := 10;
    begin
        if rising_edge(clk) then
            if temporal = X"49" then--I
					 direccion<='1';
					 stop<='0';
                if stop = '0' then
						if contador < pasos then
                    contador := contador + 1;
						else
                    contador := 0;
						end if;
					else
						if contador < 381 then
                    contador := contador + 1;
						else
                    contador := 0;
                    stop := '0';
						end if;
					end if;  
            elsif temporal =X"44" then--D
					 direccion<='0';
					 stop<='0';					 
                if stop = '0' then
						if contador < pasos then
                    contador := contador + 1;
						else
                    contador := 0;
						end if;
					else
						if contador < 381 then
                    contador := contador + 1;
						else
                    contador := 0;
                    stop := '0';
						end if;
					end if;  
            elsif temporal =X"41"then--A
					 stop<='1';
                
            elsif temporal =X"54" then--INTENSIDAD
					 stop<='0';
				
                salida<="1100";
            elsif temporal =X"4E" then--NOMBRE
					 stop<='0';
				
                salida<="0011";
            end if ;
        end if;
    end process ; -- acciones
end architecture behevioral;