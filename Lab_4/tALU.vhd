--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		-- Test cases here to drive the ALU implementation
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0
		
		datain_a <= X"C0765A22";
		datain_b <= X"B4059ADD";
		control <= "00001";	--substraction, result = 0x0C70BF45, zeroOut = 0
		wait for 20 ns;
		
		--Shifting left check, sll/slli
		datain_a <= X"0D310F22";
		datain_b <= X"00000001";
		control <= "01000"; ---left by 1 bits, result = 0x1A621E44
		wait for 20 ns;

		datain_a <= X"0D310F22";
		datain_b <= X"00000002";  
		control <= "01000"; --left immediate by 2 bits, result = 34C43C88 
		wait for 20 ns;
		
		--Shifting right check, srl/srli
		datain_a <= X"5A20BF47";
		datain_b <= X"00000003"; 
		control <= "10000"; --right by 3 bits, result = 0B4417EB 
		wait for 20 ns;

		--and/andi & or/ori check
		datain_a <= X"0000A159";
		datain_b <= X"0000F471"; 
		control <= "00010"; --and/andi, result = 0x0000A051
		wait for 20 ns;

		datain_a <= X"0000A159";
		datain_b <= X"0000F471"; 
		control <= "00100"; --or/ori, result = 0x0000F579 
		wait for 20 ns;
		wait; -- will wait forever
	END PROCESS;

END;