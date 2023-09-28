library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--50 Hz 20ms  => divisor
--5 y 10%
entity PWM is
    Port(Reloj : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR (15 downto 0);
    S : out  STD_LOGIC);
end PWM;


architecture Behavioral of PWM is
begin
    process (Reloj)
        variable Cuenta: integer  range 0 to 65_535 := 0;
    begin
        if Reloj='1' and Reloj'event then
            Cuenta := (Cuenta + 1) mod 65_536; 
            if Cuenta < D then
                S <= '1';
            else
                S <= '0';
            end if;
        end if;
end process;

end Behavioral;