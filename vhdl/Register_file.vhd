library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;

entity register_file is
	port(
			AddrRA			:	in std_logic_vector(7 downto 0);
			AddrRB			:	in std_logic_vector(7 downto 0);
			Addr	 		:	in std_logic_vector(7 downto 0);
			En 			:	in std_logic;
			En_RAM			:	in std_logic;
			En_sp			: 	in std_logic;
			Clk 			:	in std_logic;
			rst 			: 	in std_logic;
			R 			: 	in std_logic_vector(7 downto 0);
			RAM_out 		: 	in std_logic_vector(7 downto 0);
			PC 			:	in std_logic_vector(7 downto 0);
			OutA			:	out std_logic_vector(7 downto 0);
			OutB			:	out std_logic_vector(7 downto 0);
			OutDest		:	out std_logic_vector(7 downto 0)
			);
end register_file;

architecture register_file_a of register_file is

type memory is array(0 to 15) of std_logic_vector(7 downto 0);

signal registers : memory ;
signal mux_out : std_logic_vector(7 downto 0);

begin 

	mux : process(R, En_RAM, RAM_out)
		begin
		if En_RAM = '0' then
			mux_out <= R;
		else
			mux_out <= RAM_out;
		end if;
	end process mux;

	get_values : process(clk, rst)
	begin
		
		if rst='1' then
		
			for k in 0 to 13 loop
				registers(k) <= (others=>'0');
			end loop;
			registers(14) <= "11111111";
			registers(15) <= (others=>'0');
		
		else
			if rising_edge(clk) then
				if En='1' then
					registers(to_integer(unsigned(Addr))) <= mux_out;
				end if;
				if En_sp='1' then 
					if R = registers(14) then -- characterizes the use of PUSH or POP
						registers(14) <= std_logic_vector(signed(registers(14)) - 1); -- PUSH
					else 
						registers(14) <= std_logic_vector(signed(registers(14)) + 1); -- POP
					end if;
				end if;
			end if;
		end if;
	end process get_values;
	
	--OutA <= registers(to_integer(unsigned(AddrRA)));
	choose_A : process(AddrRA, PC, registers)
	begin
		if AddrRA = "00010000" then -- 16 refer to PCounter
			OutA <= std_logic_vector(unsigned(PC) + 4);
		else 
			OutA <= registers(to_integer(unsigned(AddrRA)) mod 16);
		end if;
	end process choose_A;
	
	--OutB <= registers(to_integer(unsigned(AddrRB)));
	choose_B : process(AddrRB, PC, registers)
	begin
		if AddrRB = "00010000" then -- 16 refer to PCounter
			OutB <= std_logic_vector(unsigned(PC) + 4);
		else 
			OutB <= registers(to_integer(unsigned(AddrRB)) mod 16);
		end if;
	end process choose_B;
	
	choose_dest : process(Addr, PC, registers)
	begin
		if Addr = "00010000" then -- 18 refer to PCounter
			OutDest <= std_logic_vector(unsigned(PC) + 4);
		else 
			OutDest <= registers(to_integer(unsigned(Addr)) mod 16);
		end if;
	end process choose_dest;

end register_file_a;
	

