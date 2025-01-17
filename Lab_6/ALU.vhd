--------------------------------------------------------------------------------
--
-- LAB #4
--

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

-----supporting ADD, ADDI, SUB instructions------
entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		control: in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder is
    		port (a : in std_logic;
	          b : in std_logic;
	          cin : in std_logic;
	          sum : out std_logic;
	          carry : out std_logic);
	end component;
	signal data_b: std_logic_vector(31 downto 0);
	signal carryin: std_logic_vector(31 downto 0);
	
begin
	
	with control select
		data_b <= not(datain_b) when "00001", --converting data to 2's complement for substraction
			  datain_b when "00000",  --data for addition
			 (others => '0') when others;
	with control(0) select
		carryin(0) <= '1' when '1',
				'0' when others;

	full_add0: fulladder PORT MAP(datain_a(0), data_b(0), carryin(0), dataout(0), carryin(1));
	full_add1: fulladder PORT MAP(datain_a(1), data_b(1), carryin(1), dataout(1), carryin(2));
	full_add2: fulladder PORT MAP(datain_a(2), data_b(2), carryin(2), dataout(2), carryin(3));
	full_add3: fulladder PORT MAP(datain_a(3), data_b(3), carryin(3), dataout(3), carryin(4));
	full_add4: fulladder PORT MAP(datain_a(4), data_b(4), carryin(4), dataout(4), carryin(5));
	full_add5: fulladder PORT MAP(datain_a(5), data_b(5), carryin(5), dataout(5), carryin(6));
	full_add6: fulladder PORT MAP(datain_a(6), data_b(6), carryin(6), dataout(6), carryin(7));
	full_add7: fulladder PORT MAP(datain_a(7), data_b(7), carryin(7), dataout(7), carryin(8));
	full_add8: fulladder PORT MAP(datain_a(8), data_b(8), carryin(8), dataout(8), carryin(9));	
	full_add9: fulladder PORT MAP(datain_a(9), data_b(9), carryin(9), dataout(9), carryin(10));
	full_add10: fulladder PORT MAP(datain_a(10), data_b(10), carryin(10), dataout(10), carryin(11));
	full_add11: fulladder PORT MAP(datain_a(11), data_b(11), carryin(11), dataout(11), carryin(12));
	full_add12: fulladder PORT MAP(datain_a(12), data_b(12), carryin(12), dataout(12), carryin(13));
	full_add13: fulladder PORT MAP(datain_a(13), data_b(13), carryin(13), dataout(13), carryin(14));
	full_add14: fulladder PORT MAP(datain_a(14), data_b(14), carryin(14), dataout(14), carryin(15));
	full_add15: fulladder PORT MAP(datain_a(15), data_b(15), carryin(15), dataout(15), carryin(16));
	full_add16: fulladder PORT MAP(datain_a(16), data_b(16), carryin(16), dataout(16), carryin(17));
	full_add17: fulladder PORT MAP(datain_a(17), data_b(17), carryin(17), dataout(17), carryin(18));
	full_add18: fulladder PORT MAP(datain_a(18), data_b(18), carryin(18), dataout(18), carryin(19));
	full_add19: fulladder PORT MAP(datain_a(19), data_b(19), carryin(19), dataout(19), carryin(20));
	full_add20: fulladder PORT MAP(datain_a(20), data_b(20), carryin(20), dataout(20), carryin(21));
	full_add21: fulladder PORT MAP(datain_a(21), data_b(21), carryin(21), dataout(21), carryin(22));
	full_add22: fulladder PORT MAP(datain_a(22), data_b(22), carryin(22), dataout(22), carryin(23));
	full_add23: fulladder PORT MAP(datain_a(23), data_b(23), carryin(23), dataout(23), carryin(24));
	full_add24: fulladder PORT MAP(datain_a(24), data_b(24), carryin(24), dataout(24), carryin(25));
	full_add25: fulladder PORT MAP(datain_a(25), data_b(25), carryin(25), dataout(25), carryin(26));
	full_add26: fulladder PORT MAP(datain_a(26), data_b(26), carryin(26), dataout(26), carryin(27));
	full_add27: fulladder PORT MAP(datain_a(27), data_b(27), carryin(27), dataout(27), carryin(28));
	full_add28: fulladder PORT MAP(datain_a(28), data_b(28), carryin(28), dataout(28), carryin(29));
	full_add29: fulladder PORT MAP(datain_a(29), data_b(29), carryin(29), dataout(29), carryin(30));
	full_add30: fulladder PORT MAP(datain_a(30), data_b(30), carryin(30), dataout(30), carryin(31));
	full_add31: fulladder PORT MAP(datain_a(31), data_b(31), carryin(31), dataout(31), co);

end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

----supporting SLL/SLLI/SRL/SRLI instructions----
entity shift_register is
	port(	datain1: in std_logic_vector(31 downto 0);
		datain2: in std_logic_vector(31 downto 0);
		control: in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is

begin
	-- insert code here.
	with control & datain2(2 downto 0) select
		dataout	<=	datain1 (30 downto 0) & "0" when "01000001", --shift left by 1
				datain1 (29 downto 0) & "00" when "01000010", --shift left by 2
				datain1 (28 downto 0) & "000" when "01000011", --shift left by 3
				"0" & datain1(31 downto 1) when "10000001", --shift right by 1
				"00" & datain1(31 downto 2) when "10000010", --shift right by 2
				"000" & datain1(31 downto 3) when "10000011", --shift right by 3
				datain1 when others;

end architecture shifter;

-----------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

----supporting AND/ ANDI/ OR/ ORI instructions----
entity and_or_register is
	port(	datain1: in std_logic_vector(31 downto 0);
		datain2: in std_logic_vector(31 downto 0);
		control: in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity and_or_register;

architecture bitwise of and_or_register is
	signal and_out: std_logic_vector(31 downto 0);
	signal or_out: std_logic_vector(31 downto 0);
begin
	and_out <= (datain1(31) and datain2(31))&(datain1(30) and datain2(30))&(datain1(29) and datain2(29))&(datain1(28) and datain2(28))&(datain1(27) and datain2(27))&(datain1(26) and datain2(26))
					&(datain1(25) and datain2(25))&(datain1(24) and datain2(24))&(datain1(23) and datain2(23))&(datain1(22) and datain2(22))&(datain1(21) and datain2(21))&(datain1(20) and datain2(20))
					&(datain1(19) and datain2(19))&(datain1(18) and datain2(18))&(datain1(17) and datain2(17))&(datain1(16) and datain2(16))&(datain1(15) and datain2(15))&(datain1(14) and datain2(14))
					&(datain1(13) and datain2(13))&(datain1(12) and datain2(12))&(datain1(11) and datain2(11))&(datain1(10) and datain2(10))&(datain1(9) and datain2(9))&(datain1(8) and datain2(8))
					&(datain1(7) and datain2(7))&(datain1(6) and datain2(6))&(datain1(5) and datain2(5))&(datain1(4) and datain2(4))&(datain1(3) and datain2(3))&(datain1(2) and datain2(2))&(datain1(1) and datain2(1))&(datain1(0) and datain2(0));
	or_out <= (datain1(31) or datain2(31))&(datain1(30) or datain2(30))&(datain1(29) or datain2(29))&(datain1(28) or datain2(28))&(datain1(27) or datain2(27))&(datain1(26) or datain2(26))
					&(datain1(25) or datain2(25))&(datain1(24) or datain2(24))&(datain1(23) or datain2(23))&(datain1(22) or datain2(22))&(datain1(21) or datain2(21))&(datain1(20) or datain2(20))
					&(datain1(19) or datain2(19))&(datain1(18) or datain2(18))&(datain1(17) or datain2(17))&(datain1(16) or datain2(16))&(datain1(15) or datain2(15))&(datain1(14) or datain2(14))
					&(datain1(13) or datain2(13))&(datain1(12) or datain2(12))&(datain1(11) or datain2(11))&(datain1(10) or datain2(10))&(datain1(9) or datain2(9))&(datain1(8) or datain2(8))
					&(datain1(7) or datain2(7))&(datain1(6) or datain2(6))&(datain1(5) or datain2(5))&(datain1(4) or datain2(4))&(datain1(3) or datain2(3))&(datain1(2) or datain2(2))&(datain1(1) or datain2(1))&(datain1(0) or datain2(0));
	
	with control select
		dataout <= and_out when "00010", --and selected,
		 	   or_out when "00100", --or selected,
			   x"00000000" when others;
end bitwise;
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			control: in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain1: in std_logic_vector(31 downto 0);
			datain2: in std_logic_vector(31 downto 0);
			control: in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;
	
	component and_or_register
		port(	datain1: in std_logic_vector(31 downto 0);
			datain2: in std_logic_vector(31 downto 0);
			control: in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component and_or_register;

	signal addsub_out: std_logic_vector(31 downto 0);
	signal shift_out: std_logic_vector(31 downto 0);
	signal andor_out: std_logic_vector(31 downto 0);
	signal carryout: std_logic;
	signal aluRe_internal: std_logic_vector(31 downto 0);
begin
	-- Add ALU VHDL implementation here
	ALU_addsub: adder_subtracter PORT MAP (DataIn1, DataIn2, ALUCtrl, addsub_out, carryout);
	ALU_shift: shift_register PORT MAP (DataIn1, DataIn2, ALUCtrl, shift_out);
	ALU_and_or: and_or_register PORT MAP (DataIn1, DataIn2, ALUCtrl, andor_out);

	with ALUCtrl select
		aluRe_internal <= addsub_out when "00000",
				addsub_out when "00001",
				andor_out when "00010",
				andor_out when "00100",
				shift_out when "01000",
				shift_out when "10000",
				x"00000000" when others;
	
	with aluRe_internal select
		Zero <= '1' when x"00000000",
		        '0' when others;

	ALUResult <= aluRe_internal;
end architecture ALU_Arch;


