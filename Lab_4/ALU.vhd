--------------------------------------------------------------------------------
--
-- LAB #4
--
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


