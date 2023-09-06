library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity reldig is
    port( reloj : in std_logic;
        A : out std_logic_vector (6 downto 0);
		  Y : out std_logic_vector (6 downto 0);
		  X : out std_logic_vector (6 downto 0);
		  W : out std_logic_vector (6 downto 0));
end reldig;

architecture Behavioral of reldig is
    signal segundo : std_logic;
    signal rapido : std_logic;
    signal n : std_logic;
    signal Qum : std_logic_vector (3 downto 0);
    signal Qdm : std_logic_vector (3 downto 0);
    signal e : std_logic;
    signal Quh : std_logic_vector (3 downto 0);
    signal Qdh : std_logic_vector (3 downto 0);
    signal z : std_logic;
    signal u : std_logic;
    signal d : std_logic;
    signal reset :std_logic;

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
    
    UNIDADES: process (segundo)
        variable CUENTA: std_logic_vector(3 downto 0) :="0000";
    begin
        if rising_edge (segundo) then
            if CUENTA = "1001" then
                CUENTA := "0000";
                N <= '1';
            else
                CUENTA := CUENTA + 1;
                N <= '0';
            end if;
        end if;
        Qum <= CUENTA;
    end process;

    DECENAS: process (N)
        variable CUENTA: std_logic_vector(3 downto 0) :="0000";
    begin
        if rising_edge (N) then
            if CUENTA = "0101" then
                CUENTA := "0000";
                E<='1';
            else
                CUENTA := CUENTA + 1;
                E<='0';
            end if;
        end if;
        Qdm <= CUENTA;
    end process;

    HoraU: process(E,reset)
        variable CUENTA: std_logic_vector(3 downto 0) :="0000";
    begin
        if rising_edge (E) then
            if CUENTA = "1001" then
                CUENTA := "0000";
                Z<='1';
            else
                CUENTA := CUENTA + 1;
                Z<='0';
            end if;
        end if;
        if reset='1' then
            cuenta:="0000";
        end if;
        Quh <= CUENTA;
        U<=CUENTA(2);
    end process;

    HORAD: process(Z,reset)
        variable CUENTA: std_logic_vector(3 downto 0) :="0000";
    begin
        if rising_edge (Z) then
            if CUENTA = "0010" then
                CUENTA := "0000";
            else
                CUENTA := CUENTA + 1;
            end if;
        end if;
        if reset='1' then
            cuenta:="0000";
        end if;
        Qdh <= CUENTA;
        D<=CUENTA(1);
    end process;

    inicia: process (U,D)
    begin
        reset <=(U and D);
    end process;
   
--    alarma: process (n,qdh,quh,qdm,qum)
--    variable index : integer := 0;
--    begin
--        if (Qdh="0001" and Quh="0000" and Qdm="0010" and Qum="0000")then
--            while index<20 loop
--				if rising_edge (N) then
--                Qdh <= "0000";
--                Quh <= "0000";
--                Qdm <= "0000";
--                Qum <= "0000";
--				 else
--                Qdh <= "0001";
--                Quh <= "0000";
--                Qdm <= "0010";
--                Qum <= "0000";
--                index:=index+1;
--				 end if;
--            end loop;
--        end if;
--    end process;

    
    with Qum Select
        A <= "1000000" when "0000", --0
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
	with Qdm Select
        Y <= "1000000" when "0000", --0
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
	with Quh Select
        X <= "1000000" when "0000", --0
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
	with Qdh Select
        W <= "1000000" when "0000", --0
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