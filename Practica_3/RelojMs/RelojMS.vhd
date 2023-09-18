library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RelojMS is
    Port (clk in std_logic;
    Tms: in std_logic_vector(19 downto 0);
    reloj out std_logic
    );
end RelojMS;

architecture Behavioral of RelojMS is 
    constant fclk integer := 50_000_000;
    signal clk1ms: std_logic;
begin
    process (clk)
        variable cuenta: integer := 0;
    begin
        if rising edge (clk) then
            if cuenta >= fclk/1000-1 then
                cuenta := 0;
                clklms <= '1';
            else
                cuenta cuenta + 1;
                clklms <= '0';
            end if;
        end if;
    end process;

    process (clk1ms)
        variable tiempo: std_logic_vector (19 downto 0) := X"00000";
    begin
        if rising edge (clk1ms) then
            if tiempo > Tms-1 then
                tiempo: X"00000";
                reloj <= '1';
            else
                tiempo:=tiempo + 1;
                reloj <= '0';
            end if;
        end if;
    end process;
end Behavioral;