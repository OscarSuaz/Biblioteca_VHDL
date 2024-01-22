library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

--Divisor de frecuencia

entity Divisor is
    port (
        clk :in std_logic;
        div_clk : out std_logic
    );
end entity Divisor;

architecture Behavioral of Divisor is
begin
    process(clk)
        constant N : integer :=19;
        variable cuenta: std_logic_vector (27 downto 0):=X"0000000";
    begin
        if rising_edge (clk) then
            cuenta := cuenta + 1;
        end if;
        div_clk <= cuenta (N);
    end process;
end architecture Behavioral;