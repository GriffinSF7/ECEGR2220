---------------------------
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

-------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	if ((WE = '1') and (to_integer(unsigned(Address)) >= 0) and (to_integer(unsigned(Address)) <= 127)) then 
	     i_ram(to_integer(unsigned(Address))) <= DataIn;
	elsif WE = '0' then 
	     null;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	end if;	
    end if;
 

    if ((to_integer(unsigned(Address)) >= 0) and (to_integer(unsigned(Address)) <= 127)) then 
	if OE = '0' then 
		DataOut <= i_ram(to_integer(unsigned(Address)));
	else 
		DataOut <= (others => 'Z');
	end if;
    else
	DataOut <= (others => 'Z');
    end if;

	-- Rest of the RAM implementation

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;
	
 type support_registers is array (7 downto 0) of std_logic_vector(31 downto 0);
   signal registerA0_7 : support_registers;

   signal enReg: std_logic_vector(7 downto 0); --REGISTERS ENABLE

begin
------ Write to register------------------
process(WriteData, WriteCmd) is
begin
	if WriteCmd = '1' then
		if WriteReg = "01010" then 
			enReg(0) <= '1';
		elsif WriteReg = "01011" then 
			enReg(1) <= '1';
		elsif WriteReg = "01100" then 
			enReg(2) <= '1';
		elsif WriteReg = "01101" then 
			enReg(3) <= '1';
		elsif WriteReg = "01110" then 
			enReg(4) <= '1';
		elsif WriteReg = "01111" then 
			enReg(5) <= '1';
		elsif WriteReg = "10000" then 
			enReg(6) <= '1';
		elsif WriteReg = "10001" then 
			enReg(7) <= '1';
		else
			enReg <= (others => '0');
		end if;
	else
		null;
	end if;
end process;

    a0: register32 port map(Writedata, '0', '1', '1', enReg(0), '0', '0', registerA0_7(0));	--en32 = 0 to enable output
    a1: register32 port map(Writedata, '0', '1', '1', enReg(1), '0', '0', registerA0_7(1));	--writein32 = 1 to write to register
    a2: register32 port map(Writedata, '0', '1', '1', enReg(2), '0', '0', registerA0_7(2));
    a3: register32 port map(Writedata, '0', '1', '1', enReg(3), '0', '0', registerA0_7(3));
    a4: register32 port map(Writedata, '0', '1', '1', enReg(4), '0', '0', registerA0_7(4));
    a5: register32 port map(Writedata, '0', '1', '1', enReg(5), '0', '0', registerA0_7(5));
    a6: register32 port map(Writedata, '0', '1', '1', enReg(6), '0', '0', registerA0_7(6));
    a7: register32 port map(Writedata, '0', '1', '1', enReg(7), '0', '0', registerA0_7(7));

----- Read register and output to ReadData ----------------
process(ReadReg1) is 
begin
	if ReadReg1 = "01010" then 
		ReadData1 <= registerA0_7(0);
	elsif ReadReg1 = "01011" then 
		ReadData1 <= registerA0_7(1);
	elsif ReadReg1 = "01100" then 
		ReadData1 <= registerA0_7(2);
	elsif ReadReg1 = "01101" then 
		ReadData1 <= registerA0_7(3);
	elsif ReadReg1 = "01110" then 
		ReadData1 <= registerA0_7(4);
	elsif ReadReg1 = "01111" then 
		ReadData1 <= registerA0_7(5);
	elsif ReadReg1 = "10000" then 
		ReadData1 <= registerA0_7(6);
	elsif ReadReg1 = "10001" then 
		ReadData1 <= registerA0_7(7);
	elsif ReadReg1 <= "00000" then	--X0 register
		ReadData1 <= X"00000000";
	else
		ReadData1 <= (others => 'Z');
	end if;
end process; 

process(ReadReg2) is 
begin
	if ReadReg2 = "01010" then 
		ReadData2 <= registerA0_7(0);
	elsif ReadReg2 = "01011" then 
		ReadData2 <= registerA0_7(1);
	elsif ReadReg2 = "01100" then 
		ReadData2 <= registerA0_7(2);
	elsif ReadReg2 = "01101" then 
		ReadData2 <= registerA0_7(3);
	elsif ReadReg2 = "01110" then 
		ReadData2 <= registerA0_7(4);
	elsif ReadReg2 = "01111" then 
		ReadData2 <= registerA0_7(5);
	elsif ReadReg2 = "10000" then 
		ReadData2 <= registerA0_7(6);
	elsif ReadReg2 = "10001" then 
		ReadData2 <= registerA0_7(7);
	elsif ReadReg2 <= "00000" then	
		ReadData2 <= X"00000000";
	else
		ReadData2 <= (others => 'Z');
	end if;
end process; 
    

end remember;

------------------------------------------------------------------------------------------
