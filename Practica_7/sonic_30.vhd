library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sonic_30 is
    port (
        clk: in std_LOGIC;
        inicio: in std_LOGIC;
        sensor_disp: out STD_LOGIC;
        sensor_eco: in STD_LOGIC;
        display: out std_logic_vector(7 downto 0)
    );
end entity sonic_30;

architecture Behavioral of sonic_30 is
    
begin
    
    
    
end architecture Behavioral;