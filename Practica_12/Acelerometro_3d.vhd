library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity Acelerometro is
    port (
        clk: in std_logic;
        scl: inout std_logic;
        sda: inout std_logic;
        leds: out std_logic_vector(9 downto 0);
        error: out std_logic;
        reset: in std_logic;
        mclk: out std_logic;
        direccion: in std_logic_vector(2 downto 0)
    );
end entity Acelerometro;

architecture Behavioral of Acelerometro is
    
    component i2c_master is
        port(
            clk: in std_logic;
            reset_n: in std_logic;
            ena: in std_logic;
            addr: in std_logic_vector(6 downto 0)   ;
            rw: in std_logic;
            data_wr:in std_logic_vector(7 downto 0);
            busy: out std_logic;
            data_rd: out std_logic_vector(7 downto 0);
            ack_error: BUFFER std_logic;
            sda: inout std_logic;
            scl: inout std_logic
        );
    end component i2c_master;

    component Divisor is
        port(
            clk: in std_logic;
            div_clk: out std_logic
        );
    end component Divisor;

    constant adx1345 : std_logic_vector(6 downto 0) := "1010011";
    constant reg_dataX0 : std_logic_vector(7 downto 0):=X"32";
    constant reg_dataY0: std_logic_vector(7 downto 0) :=X"34";
    constant reg_dataZ0: std_logic_vector(7 downto 0) :=X"36";
    constant reg_PWrCtrl: std_logic_vector(7 downto 0):=X"2D";
    signal reg_Lectura: std_logic_vector(7 downto 0);
    signal AX : std_logic_vector(15 downto 0);

    signal i2c_reset_n : std_logic;
    signal i2c_ena : std_logic;
    signal i2c_addr : std_logic_vector(6 downto 0);
    signal i2c_rw : std_logic;
    signal i2c_data_wr : std_logic_vector(7 downto 0);
    signal i2c_busy : std_logic;
    signal i2c_data_rd : std_logic_vector(7 downto 0);
    signal i2c_ack_error : std_logic;
    signal clk_muestra : std_logic;
    signal muestra_prev : std_logic;
    signal busy_cnt : integer range 0 to 15 := 0;
    signal ini_bc : std_logic;

    type estados is (inicia,lee,espera);
    signal edo_actual,edo_sig : estados;

begin
    U1: i2c_master port map(clk,i2c_reset_n,i2c_ena,i2c_addr,i2c_rw,i2c_data_wr,i2c_busy,i2c_data_rd,
    i2c_ack_error,sda,scl);
    U2: Divisor port map(clk,clk_muestra);

    i2c_reset_n<='1';

    with direccion select reg_Lectura <=
            reg_dataX0 when "001",
            reg_dataY0 when "010",
            reg_dataZ0 when "011",
            reg_dataX0 when others;


    --conteo en i2c_busy
    process (i2c_busy, ini_bc)
    begin
        if ini_bc='1' then
            busy_cnt<=0;
        elsif (i2c_busy'event and i2c_busy ='1') then
            busy_cnt <= busy_cnt+1;
        end if;
    end process;

    --sincornizacion de estados
    process (clk)
    begin
        if (clk'event and clk='1') then
            if (reset = '1') then
                edo_actual <=inicia;
            else
                edo_actual <= edo_sig;
                muestra_prev <= clk_muestra;
            end if;
        end if;
    end process;

    --decodificacion de estados
    process (edo_actual,clk_muestra,i2c_busy,i2c_data_rd,busy_cnt,muestra_prev)
    begin
        edo_sig<=edo_actual;
        case (edo_actual) is
            when inicia =>
                ini_bc<='0';
                case busy_cnt is
                    when 0 =>
                        i2c_ena <='1';
                        i2c_addr <= adx1345;
                        i2c_rw <='0';
                        i2c_data_wr <= reg_PWrCtrl;

                    when 1 =>
                        i2c_data_wr <= X"08";
                        i2c_ena <='1';
                        i2c_addr <= adx1345;
                        i2c_rw <= '0';

                    when 2 =>
                        i2c_ena <='0';
                        if (i2c_busy = '0') then
                            edo_sig <=espera;
                        end if;
                        i2c_addr <= adx1345;
                        i2c_rw <='0';
                        i2c_data_wr <= X"08";
                    when others =>
                        i2c_ena <= '0';
                        i2c_addr <= (others => '0');
                        i2c_rw <= '0';
                        i2c_data_wr <= (others => '0');
                end case;
            
            when lee =>
                ini_bc <='0';
                case busy_cnt is
                    when 0 =>
                        i2c_ena <='1';
                        i2c_addr <= adx1345;
                        i2c_rw <='0';
                        i2c_data_wr <= reg_Lectura;

                    when 1 =>
                        i2c_ena <='1';
                        i2c_addr <= adx1345;
                        i2c_rw <='1';
                        i2c_data_wr <= reg_Lectura;
                    
                    when 2 =>
                        if (i2c_busy ='0') then
                            AX(7 downto 0) <= i2c_data_rd;
                        end if;
                        i2c_ena <='1';
                        i2c_addr <= adx1345;
                        i2c_rw <='1';
                        i2c_data_wr <= reg_Lectura;

                    when 3 =>
                        if (i2c_busy ='0') then
                            AX(15 downto 8) <= i2c_data_rd;
                        end if;
                        i2c_ena <='0';
                        if (muestra_prev = '0' and clk_muestra = '1') then
                            edo_sig <= espera;
                        end if;
                        i2c_addr <= adx1345;
                        i2c_rw <='1';
                        i2c_data_wr <= reg_Lectura;
                    when others =>
                        i2c_ena <= '0';
                        i2c_addr <= (others => '0');
                        i2c_rw <= '0';
                        i2c_data_wr <= (others => '0');
                end case;

            when espera =>
                ini_bc <= '1';
                if (muestra_prev ='0' and clk_muestra='1') then
                    edo_sig <=lee;
                end if;
                i2c_ena <= '0';
                i2c_addr <= (others => '0');
                i2c_rw <= '0';
                i2c_data_wr <= (others => '0');
            when others =>
                edo_sig <= espera;
                ini_bc <= '1';
                i2c_ena <= '0';
                i2c_addr <= (others => '0');
                i2c_rw <= '0';
                i2c_data_wr <= (others => '0');
        end case;
    end process;

    error <= i2c_ack_error;
    leds <= AX(9 downto 0);
    mclk <= clk_muestra;

end architecture Behavioral;