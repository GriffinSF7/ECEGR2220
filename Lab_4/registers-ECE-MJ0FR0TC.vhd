--------------------------------------------------------------------------------
--
-- LAB #3
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

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

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
	
	signal out_b0, out_b1, out_b2, out_b3, out_b4, out_b5, out_b6, out_b7: std_logic; 
begin
	r0: bitstorage PORT MAP(datain(0), enout, writein, out_b0); 
	r1: bitstorage PORT MAP(datain(1), enout, writein, out_b1);
	r2: bitstorage PORT MAP(datain(2), enout, writein, out_b2);
	r3: bitstorage PORT MAP(datain(3), enout, writein, out_b3);
	r4: bitstorage PORT MAP(datain(4), enout, writein, out_b4);
	r5: bitstorage PORT MAP(datain(5), enout, writein, out_b5);
	r6: bitstorage PORT MAP(datain(6), enout, writein, out_b6);
	r7: bitstorage PORT MAP(datain(7), enout, writein, out_b7);

	dataout <= out_b0 & out_b1 & out_b2 & out_b3 & out_b4 & out_b5 & out_b6 & out_b7;
end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic := '1';
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
	     	enout:  in std_logic;
	     	writein: in std_logic;
	     	dataout: out std_logic_vector(7 downto 0));
	end component;

	signal r0_out, r1_out, r2_out, r3_out: std_logic_vector(7 downto 0);
	signal en_check, wri_check: std_logic_vector(2 downto 0);
	signal writein_data: std_logic_vector(2 downto 0);	
	signal en_data: std_logic_vector(2 downto 0);
begin
	writein_data <= writein32 & writein16 & writein8;
	en_data <= enout32 & enout16 & enout8;
	with writein_data select
		wri_check <= 	"111" when "100",
				"011" when "010",
				"001" when "001",
				"000" when others;
	with en_data select
		en_check <= 	"000" when "011",
				"100" when "101",
				"110" when "110",
				"111" when others;
				
	
	r0: register8 PORT MAP(datain(7 downto 0), en_check(0), wri_check(0), r0_out);
	r1: register8 PORT MAP(datain(15 downto 8),en_check(1), wri_check(1), r1_out);
	r2: register8 PORT MAP(datain(23 downto 16),en_check(2), wri_check(2), r2_out);
	r3: register8 PORT MAP(datain(31 downto 24), en_check(2), wri_check(2), r3_out);
	
	dataout <=  r0_out &  r1_out &  r2_out &  r3_out;
end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
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
	signal carryin: std_logic;
	signal carryin2: std_logic :='1';
begin
	data_b <= datain_b;
	with add_sub select
		data_b <= not(datain_b) + "0000000000000001" when '1',
			  datain_b when others;
	full_add0: fulladder PORT MAP(datain_a(0), data_b(0), carryin, dataout(0), carryin);
	full_add1: fulladder PORT MAP(datain_a(1), data_b(1), carryin, dataout(1), carryin);
	full_add2: fulladder PORT MAP(datain_a(2), data_b(2), carryin, dataout(2), carryin);
	full_add3: fulladder PORT MAP(datain_a(3), data_b(3), carryin, dataout(3), carryin);
	full_add4: fulladder PORT MAP(datain_a(4), data_b(4), carryin, dataout(4), carryin);
	full_add5: fulladder PORT MAP(datain_a(5), data_b(5), carryin, dataout(5), carryin);
	full_add6: fulladder PORT MAP(datain_a(6), data_b(6), carryin, dataout(6), carryin);
	full_add7: fulladder PORT MAP(datain_a(7), data_b(7), carryin, dataout(7), carryin);
	full_add8: fulladder PORT MAP(datain_a(8), data_b(8), carryin, dataout(8), carryin);	
	full_add9: fulladder PORT MAP(datain_a(9), data_b(9), carryin, dataout(9), carryin);
	full_add10: fulladder PORT MAP(datain_a(10), data_b(10), carryin, dataout(10), carryin);
	full_add11: fulladder PORT MAP(datain_a(11), data_b(11), carryin, dataout(11), carryin);
	full_add12: fulladder PORT MAP(datain_a(12), data_b(12), carryin, dataout(12), carryin);
	full_add13: fulladder PORT MAP(datain_a(13), data_b(13), carryin, dataout(13), carryin);
	full_add14: fulladder PORT MAP(datain_a(14), data_b(14), carryin, dataout(14), carryin);
	full_add15: fulladder PORT MAP(datain_a(15), data_b(15), carryin, dataout(15), carryin);
	full_add16: fulladder PORT MAP(datain_a(16), data_b(16), carryin, dataout(16), carryin);
	full_add17: fulladder PORT MAP(datain_a(17), data_b(17), carryin, dataout(17), carryin);
	full_add18: fulladder PORT MAP(datain_a(18), data_b(18), carryin, dataout(18), carryin);
	full_add19: fulladder PORT MAP(datain_a(19), data_b(19), carryin, dataout(19), carryin);
	full_add20: fulladder PORT MAP(datain_a(20), data_b(20), carryin, dataout(20), carryin);
	full_add21: fulladder PORT MAP(datain_a(21), data_b(21), carryin, dataout(21), carryin);
	full_add22: fulladder PORT MAP(datain_a(22), data_b(22), carryin, dataout(22), carryin);
	full_add23: fulladder PORT MAP(datain_a(23), data_b(23), carryin, dataout(23), carryin);
	full_add24: fulladder PORT MAP(datain_a(24), data_b(24), carryin, dataout(24), carryin);
	full_add25: fulladder PORT MAP(datain_a(25), data_b(25), carryin, dataout(25), carryin);
	full_add26: fulladder PORT MAP(datain_a(26), data_b(26), carryin, dataout(26), carryin);
	full_add27: fulladder PORT MAP(datain_a(27), data_b(27), carryin, dataout(27), carryin);
	full_add28: fulladder PORT MAP(datain_a(28), data_b(28), carryin, dataout(28), carryin);
	full_add29: fulladder PORT MAP(datain_a(29), data_b(29), carryin, dataout(29), carryin);
	full_add30: fulladder PORT MAP(datain_a(30), data_b(30), carryin, dataout(30), carryin);
	full_add31: fulladder PORT MAP(datain_a(31), data_b(31), carryin, dataout(31), carryin);

end architecture calc;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain1: in std_logic_vector(31 downto 0);
	   	datain2: in std_logic_vector(31 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is

begin
	with datain2(5 downto 0) select
		dataout	<=	datain1 (30 downto 0) & "0" when "000001", --shift left by 1
				datain1 (29 downto 0) & "00" when "000010", --shift left by 2
				datain1 (28 downto 0) & "000" when "000011", --shift left by 3
				"0" & datain1(31 downto 1) when "100001", --shift right by 1
				"00" & datain1(31 downto 2) when "100010", --shift right by 2
				"000" & datain1(31 downto 3) when "100011", --shift right by 3
				datain1 when others;

end architecture shifter;



