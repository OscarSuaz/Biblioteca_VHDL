library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity corr is
    port(
        reloj : in std_logic;
		  sele : in std_logic;
        display1,display2,display3,display4,
        display5,display6 : buffer std_logic_vector (6 downto 0)
    );
end corr;

architecture Behavioral of corr is
        signal segundo : std_logic;
        signal Q : std_logic_vector (3 downto 0) :="0000";

    begin
        divisor : process (reloj)
            variable cuenta : std_logic_vector (27 downto 0) :=X"0000000";
        begin
            if rising_edge (reloj) then
                if cuenta = X"48009E0" then
                    cuenta := X"0000000";
                else
                    cuenta := cuenta + 1;
                end if;
            end if;
            segundo <= cuenta(22);
        end process;
        
        contador : process (segundo)
        begin
            if rising_edge (segundo) then
                Q <= Q +1;
            end if;
        end process;

		  
		  selector : process (sele,Q)
		  begin
				if (sele = '1') then
					  case Q is 
							when "0000" => 
								display1 <="0000110";
							when "0001" => 
								display1 <="0101011";
							when "0010" => 
								display1 <="1111111";
							when "0011" => 
								display1 <="1000111";
							when "0100" => 
								display1 <="0001000";
							when "0101" => 
								display1 <="1111111";
							when "0110" => 
								display1 <="1000000";
							when "0111" => 
								display1 <="1000111";
							when "1000" => 
								display1 <="0001000";
							when others => 
								display1 <="1111111";
						end case;	
				else
						case Q is 
							when "0000" => 
								display1 <="1000000";
							when "0001" => 
								display1 <="0010010";
							when "0010" => 
								display1 <="1000110";
							when "0011" => 
								display1 <="0001000";
							when "0100" => 
								display1 <="0001000";
							when "0101" => 
								display1 <="1111111";
							when "0110" => 
								display1 <="0001000";
							when "0111" => 
								display1 <="1000111";
							when "1000" => 
								display1 <="1000000";
							when others => 
								display1 <="1111111";
							end case;
				end if;
		  end process;


        FF1 : process (segundo)
        begin
            if rising_edge (segundo) then
                display2 <= display1;
            end if;
        end process;

        FF2 : process (segundo)
        begin
            if rising_edge (segundo) then
                display3 <= display2;
            end if;
        end process;

        FF3 : process (segundo)
        begin
            if rising_edge (segundo) then
                display4 <= display3;
            end if;
        end process;

        FF5 : process (segundo)
        begin
            if rising_edge (segundo) then
                display6 <= display5;
            end if;
        end process;


end Behavioral;