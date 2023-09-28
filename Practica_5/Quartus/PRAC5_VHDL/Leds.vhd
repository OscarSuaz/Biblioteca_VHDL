library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Leds is
port (
    clk : in std_logic;
    Led1,Led2,Led3,Led4,Led5,Led6,Led7,Led8 : out std_logic
);
end Leds;

architecture Behavioral of Leds is

    component Divisor is
        generic (N: integer :=24);
        Port (clk: in std_logic;
        div_clk: out std_logic
        );
    end component;
    component PWM is
        Port(    Reloj : in STD_LOGIC;
        D : in STD_LOGIC_VECTOR (7 downto 0);
        S : out  STD_LOGIC);
    end component;

    signal relojPWM: std_logic;
    signal relojCiclo: std_logic;
    signal a1: std_logic_vector (7 downto 0) := X"08";
    signal a2: std_logic_vector (7 downto 0) := X"1A";
    signal a3: std_logic_vector (7 downto 0) := X"46";
    signal a4: std_logic_vector (7 downto 0) := X"4D";
	 signal a5: std_logic_vector (7 downto 0) := X"80";
	 signal a6: std_logic_vector (7 downto 0) := X"B4";
	 signal a7: std_logic_vector (7 downto 0) := X"DA";
	 signal a8: std_logic_vector (7 downto 0) := X"F8";

begin
    D1: Divisor generic map (10) port map (clk,relojPWM);
    D2: Divisor generic map (23) port map (clk,relojCiclo);
    P1: PWM port map (relojPWM,a1,Led1);
    P2: PWM port map (relojPWM,a2,Led2);
    P3: PWM port map (relojPWM,a3,Led3);
    P4: PWM port map (relojPWM,a4,Led4);
	 P5: PWM port map (relojPWM,a5,Led5);
	 P6: PWM port map (relojPWM,a6,Led6);
	 P7: PWM port map (relojPWM,a7,Led7);
	 P8: PWM port map (relojPWM,a8,Led8);

    process( relojCiclo )
		variable conta: integer :=0;
    begin
        if relojCiclo = '1' and relojCiclo'event then
			if conta < 9 then
				a1 <= a8;
				a2 <= a1;
				a3 <= a2;
				a4 <= a3;
				a5 <= a4;
				a6 <= a5;
				a7 <= a6;
				a8 <= a7;
				conta := conta + 1;
			end if;
			if conta = 9 then
				a1<=x"F8";
				a2<=x"DA";
				a3<=x"B4";
				a4<=x"80";
				a5<=x"4D";
				a6<=x"46";
				a7<=x"1A";
				a8<=x"08";
				conta := conta +1;
			end if;
			if conta > 9 then
				a1 <= a2;
				a2 <= a3;
				a3 <= a4;
				a4 <= a5;
				a5 <= a6;
				a6 <= a7;
				a7 <= a8;
				a8 <= a1;
				conta := conta + 1;
				if conta =19 then
				--invierte signaciones
					a1<=x"08";
					a2<=x"1A";
					a3<=x"B4";
					a4<=x"80";
					a5<=x"4D";
					a6<=x"46";
					a7<=x"dA";
					a8<=x"f8";
				end if;
			end if;
	  end if;
    end process;
end Behavioral ; -- Behavioral