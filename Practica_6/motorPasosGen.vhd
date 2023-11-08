--Este archivo controlará un motor a pasos dados una señal de dirección y 
--un pulso que moverá el motor un paso en la dirección indicada.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;   
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MotPasos is
    Port ( dir : in  STD_LOGIC; --0 horario, 1 antihorario
			rst : in std_logic;
            paso : in  STD_LOGIC; --Si se activa, se mueve un paso
            modo : in STD_LOGIC_VECTOR(1 downto 0); --00 Fase simple, 01 Fase doble, 10 Fase intermedia, 11 Modo bipolar
            MOT : out  STD_LOGIC_VECTOR(3 downto 0)); --Salida de los pines del motor
end MotPasos;

architecture Behavioral of MotPasos is
    TYPE estado IS(sm0,sm1,sm2,sm3,sm4,sm5,sm6,sm7,sm8,sm9,sm10);
	SIGNAL pres_s, next_s : estado; --Estado presente y siguiente
	SIGNAL motor : std_logic_vector(3 downto 0);
begin

	process(paso,rst)
	begin
		if rst='0' then --Si se preciona el reset va a estado 1
			pres_S <= sm0;
		elsif paso'event and paso='1' then --Cada pulso del divisor cambia de estado
			pres_s <= next_s; --Actualiza el estado
		end if;
	end process;

    process(pres_s,dir,rst,modo) 
    begin
            case(pres_S) is
                when sm0 =>
                    next_s <=sm1;
                    
                when sm1 =>
                    if modo="00" then --motor bipolar
                        if dir='1' then
                            next_s <= sm3;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm1;
                    end if;
                    
                when sm2 => --Estado 2
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm4;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm3;
                        else
                            next_s <= sm1;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm2;
                    end if;
                    
                when sm3 => --Estado 3
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm5;
                        else
                            next_s <= sm1;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm4;
                        else
                            next_s <= sm2;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm3;
                    end if;
                    
                when sm4 => -- Estado 4
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm6;
                        else
                            next_s <= sm2;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm5;
                        else
                            next_s <= sm3;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm10;
                        end if;
                    else
                        next_s <= sm4;
                    end if;
                    
                when sm5 => --Estado 5
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm7;
                        else
                            next_s <= sm3;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm6;
                        else
                            next_s <= sm4;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm3;
                    end if;
                    
                when sm6 => --Estado 6
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm8;
                        else
                            next_s <= sm4;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm7;
                        else
                            next_s <= sm5;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm7;
                    end if;
                    
                when sm7 => --Estado 7
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm5;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm8;
                        else
                            next_s <= sm6;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm9;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm7;
                    end if;
                    
                when sm8 => --Estado 8
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm6;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm10;
                        else
                            next_s <= sm9;
                        end if;
                    else
                        next_s <= sm8;
                    end if;
                    
                when sm9 => --Estado 9
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm8;
                        else
                            next_s <= sm4;
                        end if;
                    else
                        next_s <= sm9;
                    end if;
                    
                when sm10 =>	--Estado 10
                    if modo="00" then 
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm7;
                        end if;
                    elsif modo ="01" then
                        if dir='1' then
                            next_s <= sm2;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "10" then
                        if dir='1' then
                            next_s <= sm1;
                        else
                            next_s <= sm8;
                        end if;
                    elsif modo = "11" then
                        if dir='1' then
                            next_s <= sm4;
                        else
                            next_s <= sm8;
                        end if;
                    else
                        next_s <= sm10;
                    end if;
        
                when others => next_s <= sm0;
            end case;
        end process;
        
        process(pres_s)
        begin
            case pres_s is
                when sm0 => motor <= "0000";
                when sm1 => motor <= "1000";
                when sm2 => motor <= "1100";
                when sm3 => motor <= "0100";
                when sm4 => motor <= "0110";
                when sm5 => motor <= "0010";
                when sm6 => motor <= "0011";
                when sm7 => motor <= "0001";
                when sm8 => motor <= "1001";
                when sm9 => motor <= "1010";
                when sm10 => motor <= "0101";
                when others => motor <= "0000";
            end case;
        end process;

        MOT <= motor;
end architecture;
