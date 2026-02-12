library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all;

entity ALU is
	port(
			A			:	in std_logic_vector(7 downto 0);
			B			:	in std_logic_vector(7 downto 0);
			SelR	 	:	in std_logic_vector(2 downto 0);
			R 			:	out std_logic_vector(7 downto 0);
			Status	:	out std_logic
			);
end ALU;

architecture ALU_a of ALU is
signal diff : std_logic_vector(7 downto 0);

begin
	compute : process(A, B, SelR)
		begin
		case SelR is
			when "000" =>
				R <= std_logic_vector(signed(A) + signed(B));
				if signed(std_logic_vector(signed(A) - signed(B))) = 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "001" =>
				R <= std_logic_vector(signed(A) - signed(B));
				if signed(std_logic_vector(signed(A) - signed(B))) /= 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "010" =>
				R <= A and B;
				if signed(std_logic_vector(signed(A) - signed(B))) >= 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "011" => 
				R <= A or B;
				if (signed(A) - signed(B)) > 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "100" =>
				R <= A xor B;
				if (signed(A) - signed(B)) <= 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "101" =>
				R <= not(A);
				if (signed(A) - signed(B)) < 0 then
					Status <= '1';
				else 
					Status <= '0';
				end if;
			when "110" =>
				R <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
				Status <= '1';
			when "111" =>
				R <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
				Status <= '0';
			when others => 
				R <= (others => '0');
				Status <= '0';
		end case;
	end process;
	
end alu_a;
	