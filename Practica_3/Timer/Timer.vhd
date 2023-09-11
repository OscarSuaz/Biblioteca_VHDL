library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--temporozador con ancho de pulso dado en milisegundos
entity Timer is
    port (
        clk : in std_logic;
        start : in std_logic;
        Tms : in std_logic_vector(19 downto 0);
        P : out std_logic
    );
end entity Timer;

architecture Behavioral of Timer is
    constant fclk : integer := 50_000_000;
    signal clk1ms : std_logic;
    signal previo : std_logic :='0';
begin
    process (clk)
        variable cuenta : integer := 0;
    begin
        if rising_edge (clk) then
            if cuenta >= fclk/1000-1 then
                cuenta :=0;
                clk1ms <= '1';
            else
                cuenta := cuenta + 1;
                clk1ms <= '0';
            end if;
        end if;
    end process;

    process (clk1ms, start)
        variable cuenta: std_logic_vector(19 downto 0):= X"00000";
        variable contando: bit :='0';
    begin
        if rising_edge (clk1ms) then
            if contando='0' then
                if start /= previo and start='1' then
                    cuenta := X"00000";
                    contando := '1';
                    P<='1';
                else
                    P<='0';
                    contando :='0';
                end if;
            end if;
            previo<=start;
        end if;
    end process;
end architecture Behavioral;