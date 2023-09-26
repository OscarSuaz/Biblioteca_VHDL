library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD LOGIC ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Leds is
port (
    clk : in std_logic;
    Led1,Led2,Led3,Led4 : out std_logic
);
end Leds;

architecture Behavioral of Leds is

    component Divisor is
        generic (N: integer :=24);
        generic (N: integer :=24);
        Port (clk in std_logic;
        div_clk out std_logic
        );
    end component;
    component PWM is
        Port(    Reloj in STD_LOGIC;
        D : in STD_LOGIC_VECTOR (7 downto 0);
        S out  STD_LOGIC);
    end component;

    signal relojPWM: std_logic;
    signal relojCiclo: std_logic;
    signal a1: std_logic_vector (7 downto 0) := X"08";
    signal a2: std_logic_vector (7 downto 0) := X"20";
    signal a3: std_logic_vector (7 downto 0) := X"60";
    signal a4: std_logic_vector (7 downto 0) := X"F8";

begin
    D1: Divisor generic map (10) port map (clk,relojPWM);
    D2: Divisor generic map (23) port map (clk,relojCiclo);
    P1: PWM port map (relojPWM,a1,Led1);
    P2: PWM port map (relojPWM,a2,Led2);
    P3: PWM port map (relojPWM,a3,Led3);
    P4: PWM port map (relojPWM,a4,Led4);

    process( relojCiclo )
    begin
        if relojCiclo = '1' and relojCiclo'event then
            a1 <= a4;
            a2 <= a1;
            a3 <= a2;
            a4 <= a3;
        end if;
    end process;
end Behavioral ; -- Behavioral