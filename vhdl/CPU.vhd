LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		MAX10_CLK1_50 :  IN  STD_LOGIC;
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		rst : in std_logic;
		HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
		
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 



--COMPONENT seg7_lut
--	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
--	);
--END COMPONENT;

--COMPONENT dig2dec
--	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
--		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
--	);
--END COMPONENT;

COMPONENT ALU
	port(
			A			:	in std_logic_vector(7 downto 0);
			B			:	in std_logic_vector(7 downto 0);
			SelR	 	:	in std_logic_vector(2 downto 0);
			R 			:	out std_logic_vector(7 downto 0);
			Status	:	out std_logic
			);
end component;

component decode
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
			En_RAM		: 	out std_logic;
			En_Fetch 	:	out std_logic;
			En_sp			:	out std_logic;
			RAM_rw		: 	out std_logic;
			PC_load 	: 	out std_logic;
			PC_mux	: 	out std_logic;
			SelR 		:	out std_logic_vector(2 downto 0);
			A		:	out std_logic_vector(7 downto 0);
			B		:	out std_logic_vector(7 downto 0)
			);
end component;

component Register_file
	port(
			AddrRA			:	in std_logic_vector(7 downto 0);
			AddrRB			:	in std_logic_vector(7 downto 0);
			Addr	 		:	in std_logic_vector(7 downto 0);
			En 			:	in std_logic;
			En_RAM			:	in std_logic;
			En_sp			: 	in std_logic;
			Clk 			:	in std_logic;
			rst 			: 	in std_logic;
			RAM_out			: 	in std_logic_vector(7 downto 0);
			R 			: 	in std_logic_vector(7 downto 0);
			PC 			: 	in std_logic_vector(7 downto 0);
			OutA			:	out std_logic_vector(7 downto 0);
			OutB			:	out std_logic_vector(7 downto 0);
			OutDest 		:	out std_logic_vector(7 downto 0)
			);
end component;

component Fetch
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			PC_load	:	in std_logic;
			PC_mux 	:	in std_logic;
			AddrRDest	:	in std_logic_vector(7 downto 0);
			RegDest	: in std_logic_vector(7 downto 0);
			PC_out	:	out std_logic_vector(7 downto 0)
			);
end component;

component Rom
port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(31 downto 0)
			);
end component;

component Ram
port(
			rw,en		:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_in	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(7 downto 0)
			);
end component;


SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);


signal RegA : std_logic_vector(7 downto 0);  
signal RegB : std_logic_vector(7 downto 0); 
signal RegDest : std_logic_vector(7 downto 0); 
signal ROM_out : std_logic_vector(31 downto 0);
signal Status : STD_LOGIC;
signal AddrRA : std_logic_vector(7 downto 0);  
signal AddrRB : std_logic_vector(7 downto 0);  
signal AddrRDest : std_logic_vector(7 downto 0);  
signal En_Rf : STD_LOGIC;
signal SelR : std_logic_vector(2 downto 0);
signal A : std_logic_vector(7 downto 0);  
signal B : std_logic_vector(7 downto 0);  

signal R : std_logic_vector(7 downto 0);  

signal En_Fetch : STD_LOGIC;
signal PC_Load :  std_logic;
signal PC_mux : std_logic;  
signal PC_out :  std_logic_vector(7 downto 0); 

signal En_Rom : STD_LOGIC;

signal En_RAM : std_logic;
signal RAM_out : std_logic_vector(7 downto 0);
signal RAM_rw : std_logic;

signal En_sp : std_logic;

BEGIN 

Decode_1 : Decode
port map(clk => MAX10_CLK1_50,
			rst => rst,
			RegA => RegA,
			RegB => RegB,
			Instr => ROM_Out,
			Status => Status,
			AddrRA => AddrRA,
			AddrRB => AddrRB,
			AddrRDest => AddrRDest,
			En_R => En_Rf,
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
		
ALU_1 : ALU
port map(
			A => A,
			B => B,
			SelR => SelR,
			R => R,
			Status => Status
		);
		
Rf_1 : Register_file
port map(
			AddrRA => AddrRA,
			AddrRB => AddrRB,
			Addr => AddrRDest,
			En => En_Rf,
			En_RAM => En_RAM,
			En_sp => En_sp,
			Clk => MAX10_CLK1_50,
			rst => rst,
			R => R,
			RAM_out => RAM_out,
			PC => PC_out,
			OutA => RegA,
			OutB => RegB,
			OutDest => RegDest
			);
			
Fetch_1 : Fetch
	port map(
			en	=> En_Fetch,
			clk => MAX10_CLK1_50,
			rst => rst,
			PC_load => PC_Load,
			PC_mux => PC_mux,
			AddrRDest => AddrRDest,
			RegDest => RegDest,
			PC_out => PC_out
			);

Rom_1 : rom
	port map(
			en	=> En_Rom,
			clk => MAX10_CLK1_50,
			rst => rst,
			Adress => PC_out,
			Data_out => ROM_out
			);

Ram_1 : Ram
	port map(
			rw => Ram_rw,
			en => En_RAM,
			clk => MAX10_CLK1_50,
			rst => rst,
			Adress => R,
			Data_in => RegDest,
			Data_out => RAM_out
			);
			

En_Rom <= '1';






--
--b2v_inst : seg7_lut
--PORT MAP(iDIG => seg7_in0,
--		 oSEG => HEX_out4(6 DOWNTO 0));
--
--
--b2v_inst1 : seg7_lut
--PORT MAP(iDIG => seg7_in1,
--		 oSEG => HEX_out3(6 DOWNTO 0));
--
--
--
--
--
--
--
--
--
--b2v_inst2 : seg7_lut
--PORT MAP(iDIG => seg7_in2,
--		 oSEG => HEX_out2(6 DOWNTO 0));
--
--
--b2v_inst3 : seg7_lut
--PORT MAP(iDIG => seg7_in3,
--		 oSEG => HEX_out1(6 DOWNTO 0));
--
--
--b2v_inst4 : seg7_lut
--PORT MAP(iDIG => seg7_in4,
--		 oSEG => HEX_out0(6 DOWNTO 0));
--
--
--b2v_inst5 : dig2dec
--PORT MAP(		 vol => "1101010110101010",
--		 seg0 => seg7_in4,
--		 seg1 => seg7_in3,
--		 seg2 => seg7_in2,
--		 seg3 => seg7_in1,
--		 seg4 => seg7_in0);




HEX0 <= HEX_out0;
HEX1 <= HEX_out1;
HEX2 <= HEX_out2;
HEX3 <= HEX_out3;
HEX4 <= HEX_out4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;

zero <= '0';
one <= '1';
HEX_out0(7) <= '1';
HEX_out1(7) <= '1';
HEX_out2(7) <= '1';
HEX_out3(7) <= '1';
HEX_out4(7) <= '1';



LEDR <= SW;

END bdf_type;