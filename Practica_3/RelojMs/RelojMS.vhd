library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--generador de señal de reloj con periodo dado en milisegundos

entity RelojMS is
    port (
        clk : in std_logic;
        Tms : in std_logic_vector(19 downto 0);
        reloj : out std_logic
    );
end entity RelojMS;

architecture Behavioral of RelojMS is
    constant fclk : integer := 50_000_000;
    signal clk1ms : std_logic;
begin
    process (clk)
        variable cuenta: integer :=0;
    begin
        if rising_edge(clk) then
            if cuenta >= fclk/1000-1 then
                cuenta :=0;
                clk1ms <='1';
            end if;
        end if;
    end process;

    process (clk1ms)
        variable tiempo: std_logic_vector(19 downto 0):= X"00000";
    begin
        if rising_edge(clk1ms) then
            if tiempo >= Tms-1 then
                tiempo := X"00000";
                reloj <='1';
            else
                tiempo := tiempo +1;
                reloj <='0';
            end if;
        end if;
    end process;
end architecture Behavioral;