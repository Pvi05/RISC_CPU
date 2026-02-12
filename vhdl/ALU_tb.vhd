library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end entity ALU_tb;

architecture sim of ALU_tb is
    signal A      : std_logic_vector(7 downto 0);
    signal B      : std_logic_vector(7 downto 0);
    signal SelR   : std_logic_vector(2 downto 0);
    signal R      : std_logic_vector(7 downto 0);
    signal Status : std_logic;

begin

    DUT: entity work.ALU
        port map (
            A      => A,
            B      => B,
            SelR   => SelR,
            R      => R,
            Status => Status
        );

    stim_proc : process
    begin
        -- Apply all-zero inputs
        A    <= (others => '0');
        B    <= (others => '0');
        SelR <= (others => '0');
        wait for 100 ns;
		  
	A    <= "00101001";
        B    <= "00100111";
        SelR <= (others => '0');
        wait for 100 ns;
		  
	A    <= "00101001";
        B    <= "00100111";
        SelR <= "001";
        wait for 100 ns;

	A    <= "00100111";
        B    <= "00100111";
        SelR <= "000";
        wait for 100 ns;
		  
	A    <= "00101001";
        B    <= "00100111";
        SelR <= "000";
        wait for 100 ns;  
	
	A    <= "00101001";
        B    <= "00101001";
        SelR <= "000";
        wait for 100 ns;

        wait;
    end process;

end architecture sim;

	
		
