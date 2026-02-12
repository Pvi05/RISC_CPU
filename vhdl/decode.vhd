library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;

entity decode is
	port(
			clk		:	in std_logic;
			rst		:	in std_logic;
			RegA		:	in std_logic_vector(7 downto 0);
			RegB		:	in std_logic_vector(7 downto 0);
			Instr 		:	in std_logic_vector(31 downto 0);
			Status		:	in std_logic;
			AddrRA		:	out std_logic_vector(7 downto 0);
			AddrRB		: 	out std_logic_vector(7 downto 0);
			AddrRDest 	:	out std_logic_vector(7 downto 0);
			En_R 		: 	out std_logic;
			En_RAM		: out std_logic;
			En_Fetch 	: out std_logic;
			En_sp 		: out std_logic;
			RAM_rw		: out std_logic;
			PC_load		: out std_logic;
			PC_mux 		: out std_logic;
			SelR 		:	out std_logic_vector(2 downto 0);
			A		:	out std_logic_vector(7 downto 0);
			B		:	out std_logic_vector(7 downto 0)
			);
end decode;

architecture decode_a of decode is
signal na : std_logic_vector(2 downto 0);
signal format : std_logic_vector(1 downto 0);
signal OpA 	: std_logic;
signal OpB 	: std_logic;
signal Op	: std_logic_vector(7 downto 0);
signal ParseA : std_logic_vector(7 downto 0);
signal ParseB : std_logic_vector(7 downto 0);
signal ParseDest : std_logic_vector(7 downto 0);
signal En_JMP : std_logic;
signal stall : std_logic;

begin
	decode_instr : process(clk, rst)
	begin
	
	if rst = '1' then
--		stall <= '0';
--		En_JMP <= '0';
		ParseB <= "00000000";
		ParseA <= "00000000";
		ParseDest <= "00000000";
		Op <= "00010000";
	else
		if rising_edge(clk) then
			if stall = '1' then
					Op <= "10000000";
			else 
				if En_JMP = '1' then
					-- INOP : Adds 0 to R0 into R0
					ParseB <= "00000000";
					ParseA <= "00000000";
					ParseDest <= "00000000";
					Op <= "00010000";
				else 
					ParseB <= Instr(7 downto 0);
					ParseA <= Instr(15 downto 8);
					ParseDest <= Instr(23 downto 16);
					Op <= Instr(31 downto 24);
				end if;	
				
			end if;
		end if;
	end if;
	end process;

	AddrRA <= ParseA;
	AddrRB <= ParseB;
	AddrRDest <= ParseDest;


	choose_valA : process(ParseA, RegA, OpA)
	begin
		if OpA = '1' then
			A <= ParseA;
		else 
			A <= RegA;
		end if;
	end process;

	choose_valB : process(ParseB, RegB, OpB) 
	begin
		if OpB = '1' then
			B <= ParseB;
		else 
			B <= RegB;
		end if;
	end process;

	Op_handler : process(Op, Status)
	begin
	if Op(7 downto 5) = "100" then -- STALL
		stall <= '0';
		En_Fetch <= '1';
		En_sp <= '0';
		-- Keeps any other out signal unchanged
	else 
		En_Fetch <= '1';
		stall <= '0';
		En_R <= '1';
		En_JMP <= '0';
		En_sp <= '0';
		OpB <= Op(3);
		OpA <= Op(4);
		SelR <= Op(2 downto 0); 
		case Op(7 downto 5) is
			when "001" => -- Conditional Jump
				En_RAM <= '0';
				En_R <= '0';
				PC_Mux <= '0';
				if Status = '1' then
					En_JMP <= '1';
				else 
					En_JMP <= '0';
				end if;
			when "101" => -- Conditional Jump to REG Address
				En_RAM <= '0';
				En_R <= '0';
				PC_Mux <= '1';
				if Status = '1' then
					En_JMP <= '1';
				else 
					En_JMP <= '0';
				end if;
			when "010" => -- RAM Load
				En_RAM <= '1';
				Ram_rw <= '0';
				-- Stall execution for RAM data to arrive / be registered
				stall <= '1';
				En_Fetch <= '0';
			when "011" => -- RAM store
				En_RAM <= '1';
				Ram_rw <= '1';
				En_R <= '0';
			when "110" => -- POP
				En_sp <= '1';
				En_RAM <= '1';
				Ram_rw <= '0';
				-- Stall execution for RAM data to arrive / be registered
				stall <= '1';
				En_Fetch <= '0';
			when "111" => -- PUSH
				En_sp <= '1';
				En_R <= '0';
				En_RAM <= '1';
				Ram_rw <= '1';
			when others => -- Standart Arithmetic / Logic
				En_RAM <= '0';
		end case;
	end if;
end process;

	PC_load <= En_JMP;

end decode_a;
	
			
			
			
			
			