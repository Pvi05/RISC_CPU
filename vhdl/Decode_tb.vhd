library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode_tb is
end entity decode_tb;

architecture sim of decode_tb is
	signal	clk		:	std_logic;
	signal	rst		:	std_logic;
	signal	RegA		:	std_logic_vector(7 downto 0);
	signal	RegB		:	std_logic_vector(7 downto 0);
	signal	Instr 		:	std_logic_vector(31 downto 0);
	signal	Status		:	std_logic;
	signal	AddrRA		:	std_logic_vector(7 downto 0);
	signal	AddrRB		: 	std_logic_vector(7 downto 0);
	signal	AddrRDest 	:	std_logic_vector(7 downto 0);
	signal	En_R 		: 	std_logic;
	signal	En_RAM		: 	std_logic;
	signal	En_Fetch	: 	std_logic;
	signal	En_sp		:	std_logic;
	signal	RAM_rw		:	std_logic;
	signal 	PC_load		:	std_logic;
	signal	PC_mux	:	std_logic;
	signal	SelR 		:	std_logic_vector(2 downto 0);
	signal	A		:	std_logic_vector(7 downto 0);
	signal	B		:	std_logic_vector(7 downto 0);
	
	constant CLK_PERIOD : time := 100 ns;
	
begin

	clk <= not clk after CLK_PERIOD/2;
	
	DUT : entity work.decode
		port map(
			clk => clk,
			rst => rst,
			RegA => RegA,
			RegB => RegB,
			Instr => Instr,
			Status => Status,
			AddrRA => AddrRA,
			AddrRB => AddrRB,
			AddrRDest => AddrRDest,
			En_R => En_R,
			En_RAM => En_RAM,
			En_Fetch => En_Fetch,
			En_sp => En_sp,
			RAM_rw => RAM_rw,
			PC_load => PC_Load,
			PC_mux => PC_mux,
			SelR => SelR,
			A => A,
			B => B
		);
		
	stim_proc : process 
	begin 
		rst <= '1';
		RegA <= (others => '0');
		RegB <= (others => '0');
		Instr <= (others => '0');
		Status <= '0';
		wait for CLK_PERIOD;
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		rst <= '0';
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "00011000" & "00001101" & "00001110" & "00001100";
		RegA <= "00101000";
		RegB <= "00101000";
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "00001000" & "00001101" & "00001110" & "00001100";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "00010000" & "00001101" & "00001110" & "00001100";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "00011010" & "00001101" & "00001110" & "00001100";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "00111000" & "00001101" & "00101100" & "00001100";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "10111000" & "00001101" & "00101100" & "00101100";
		
		wait until rising_edge(clk);
		Status <= '1';
		
		wait for CLK_PERIOD/2;
		
		Instr <= "00010000" & "00001101" & "00001110" & "00001100";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "01011000" & "00001000" & "00101100" & "00000001";
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "01111000" & "00001000" & "00101000" & "00000000";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "11001000" & "00010000" & "00001110" & "00000000";
		
		wait until rising_edge(clk);
		wait for CLK_PERIOD/2;
		
		Instr <= "11101000" & "00010000" & "00001110" & "00000001";

		wait;
	end process;

end architecture sim;
		
		
			
			