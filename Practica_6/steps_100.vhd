library ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity steps_100 is
    port (
        clk : in std_logic;
		rst : in STD_LOGIC;
        MOT : out std_logic_vector(3 downto 0)
    );
end entity steps_100;

architecture behavioral of steps_100 is
    component MotPasos is
        port (
            dir : in  STD_LOGIC;
				rst : in STD_LOGIC;
            paso : in  STD_LOGIC; 
            modo : in STD_LOGIC_VECTOR(1 downto 0);
            MOT : out  STD_LOGIC_VECTOR(3 downto 0)
        );
    end component MotPasos;

    
    
    signal div : std_logic_vector(17 downto 0);
    signal clk_div : std_logic := '0';

    signal direccion : std_logic := '0'; --Empieza en sentido horario
    signal paso : std_logic;
    signal motor : std_logic_vector(3 downto 0);

begin
    m1 : MotPasos port map (direccion, rst, paso, "00", motor);

    --Divisor de frecuencia
	process (clk,rst)
	begin
		if rst='0' then
			div <= (others=>'0');
		elsif clk'event and clk= '1' then
			div <= div + 1;
		end if;
	end process;
	clk_div <= div(16); --N=16 Estará alternando entre cero y uno cada 2.52 ms
    -- Para un segundo se requieren 381 pulsos

    process (clk_div)
        variable contador : integer := 0;
        variable pasos : integer := 100;
        variable pausa : std_logic := '0';

    begin
        if clk_div'event and clk_div = '1' then
            if pausa = '0' then
                if contador < pasos then
                    contador := contador + 1;
                else
                    contador := 0;
                    pausa := '1';
                end if;
            else
                if contador < 381 then
                    contador := contador + 1;
                else
                    contador := 0;
                    pausa := '0';
                    if direccion = '0' then
                        direccion <= '1';
                        pasos := 1040;
                    else
                        direccion <= '0';
                        pasos := 200;
                    end if;
                end if;
            end if;
        end if;

        if pausa = '0' then
            paso <= clk_div;
        else
            paso <= '0';
        end if;
    end process;  
	 
	 
	 MOT <= motor;
    
end architecture behavioral;
