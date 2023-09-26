library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD LOGIC ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Divisor is
    generic (N: integer :=24);
    Port (clk in std_logic;
    div_clk out std_logic
    );
end Divisor;

architecture Behavioral of Divisor is
begin
    process (clk)
        variable cuenta: std_logic_vector (27 downto 0) := X"0000000";
    begin
        if rising edge (clk) then
            cuenta cuenta + 1;
        end if;
        div clk <- cuenta (N);
        end process;
end Behavioral;
