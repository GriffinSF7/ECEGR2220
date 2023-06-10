--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
	 WITH selector SELECT
        	Result <= In0 WHEN '0',
                  	In1 WHEN OTHERS;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
begin
-- Add your code here
	
	---Branch---
	WITH opcode & funct3 SELECT
		Branch <= "01" when "1100011000", 	-- BEQ
			"10" when "1100011001", 	-- BNE
			"00" when others;

	--MemRead---
	WITH opcode SELECT
		MemRead <= '0' when "0000011",
			'1' when others;
						
	---MemtoReg---
	WITH opcode SELECT
		MemtoReg <= '1' when "0000011",
			'0' when others;
		
	---ALUCtrl---
	ALUCtrl <= "00000" WHEN opcode = "0110011" AND funct3 = "000" AND funct7 = "0000000" ELSE				--ADD
					"00000" WHEN opcode = "0010011" AND funct3 = "000" ELSE					--ADDI 
					"00000" WHEN opcode = "0000011" OR opcode = "0100011" ELSE				--LW/SW
					"00001" WHEN opcode = "0110011" AND funct3 = "000" AND funct7 = "0100000" ELSE		--SUB
					"00001" WHEN opcode = "1100011" AND (funct3 = "000" OR funct3 = "001") ELSE		--BEQ/BNE
					
					"00010" WHEN opcode = "0110011" AND funct3 = "111" AND funct7 = "0000000" ELSE		--AND
					"00010" WHEN opcode = "0010011" AND funct3 = "111" ELSE					--ANDI
					"00100" WHEN opcode = "0110011" AND funct3 = "110" AND funct7 = "0000000" ELSE		--OR
					"00100" WHEN opcode = "0010011" AND funct3 = "110" ELSE					--ORI
					
					"01000" WHEN opcode = "0110011" AND funct3 = "001" AND funct7 = "0000000" ELSE		--SLL
					"01000" WHEN opcode = "0010011" AND funct3 = "001" ELSE					--SLLI
					"10000" WHEN opcode = "0110011" AND funct3 = "101" AND funct7 = "0000000" ELSE		--SRL
					"10000" WHEN opcode = "0010011" AND funct3 = "101" ELSE					--SRLI
					"11111" WHEN opcode = "0110111" ELSE																--LUI
					"11110";
	---MemWrite---
	WITH opcode SELECT
		MemWrite <= '1' when "0100011",
						'0' when others;

	---ALUSrc---
	ALUSrc <= '0' when (opcode = "0110011"  or opcode = "1100011"  or opcode = "XXXXXXX") 
	else '1';

	---RegWrite---
	RegWrite <= '1' when clk = '0' and (opcode = "0000011" or opcode = "0110111" or opcode = "0110011" or opcode = "0010011") 
	else '0';

	---ImmGen---
	WITH opcode SELECT
		ImmGen <= "00" when "0010011", 		-- I-type
			"01" when "0100011",		-- S-type
			"10" when "1100011", 		-- S-type & B-type
			"11" when others;  		-- R-type & U-type
end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is
begin
-- Add your code here
	PROCESS(Reset, Clock) IS
    	BEGIN
        	IF(Reset = '1') THEN
           	 	PCout <= x"00400000";
       		end IF;
		IF rising_edge(Clock) THEN
			PCout <= PCin;
		END IF;
    END PROCESS;
end executive;
--------------------------------------------------------------------------------
