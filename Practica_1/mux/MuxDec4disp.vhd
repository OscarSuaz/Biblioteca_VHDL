library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity MuxDec4disp is
    port( reloj : in std_logic;
		  D0 : in std_logic_vector (3 downto 0);
		  D1 : in std_logic_vector (3 downto 0);
		  D2 : in std_logic_vector (3 downto 0);
		  D3 : in std_logic_vector (3 downto 0);
        AN : out std_logic_vector (3 downto 0);
		  L : out std_logic_vector (6 downto 0));
end MuxDec4disp;

architecture Behavioral of MuxDec4disp is
    signal segundo : std_logic;
    signal rapido : std_logic;
    signal Qs : std_logic_vector (3 downto 0);
    signal Qr : std_logic_vector (1 downto 0);
--    signal u : std_logic;
--    signal d : std_logic;
--    signal reset :std_logic;

begin
    divisor : process (reloj)
        variable CUENTA: std_logic_vector(27 downto 0) := X"0000000";
    begin
        if rising_edge (reloj) then
            if CUENTA =X"48009E0" then
                CUENTA :=X"0000000";
            else
                CUENTA := CUENTA + 1;
            end if;
        end if;
        segundo <= CUENTA(22);
        rapido <= CUENTA(10);
    end process;
    


    CONTRAPID: process (rapido)
        variable CUENTA: std_logic_vector(1 downto 0) :="00";
    begin
        if rising_edge (rapido) then
            CUENTA := CUENTA +1;
        end if;
        Qr <= CUENTA;
    end process;

    MUXY: process (Qr)
    begin
        if Qr = "00" then
            Qs<=D3;
        elsif Qr = "01" then
            Qs<=D2;
        elsif Qr = "10" then
            Qs<=D1;
        elsif Qr = "11" then
            Qs<=D0;
        end if;
    end process;

    seledisplay: process (Qr)
    begin
        case Qr is
            when "00" =>
                AN<= "1110";
            when "01" =>
                AN<= "1101";
            when "10" =>
                AN<= "1011";
            when others =>
                AN<= "0111";
        end case;
    end process;

with Qs Select
        L <= "1000000" when "0000", --0
            "1111001" when "0001", --1
            "0100100" when "0010", --2
            "0110000" when "0011", --3
            "0011001" when "0100", --4
            "0010010" when "0101", --5
            "0000010" when "0110", --6
            "1111000" when "0111", --7
            "0000000" when "1000", --8
            "0010000" when "1001", --9
            "1000000" when others; --F

end Behavioral;