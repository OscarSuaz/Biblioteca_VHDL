library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Mux4disp is
    port( reloj : in std_logic;
		  D0 : in std_logic_vector (6 downto 0);
		  D1 : in std_logic_vector (6 downto 0);
		  D2 : in std_logic_vector (6 downto 0);
		  D3 : in std_logic_vector (6 downto 0);
        AN : out std_logic_vector (3 downto 0);
		  L : out std_logic_vector (6 downto 0));
end Mux4disp;

architecture Behavioral of Mux4disp is
    signal segundo : std_logic;
    signal rapido : std_logic;
    signal Qs : std_logic_vector (3 downto 0);
    signal Qr : std_logic_vector (1 downto 0);

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
            L<=D3;
        elsif Qr = "01" then
            L<=D2;
        elsif Qr = "10" then
            L<=D1;
        elsif Qr = "11" then
            L<=D0;
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

end Behavioral;