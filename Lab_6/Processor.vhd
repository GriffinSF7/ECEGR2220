--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
            ReadReg2: in std_logic_vector(4 downto 0); 
            WriteReg: in std_logic_vector(4 downto 0);
				WriteData: in std_logic_vector(31 downto 0);
				WriteCmd: in std_logic;
				ReadData1: out std_logic_vector(31 downto 0);
				ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			control: in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;


	-- Add your code here

	---Program Counter--
	signal PC_Out, Mux_to_PC: std_logic_vector(31 downto 0);
	
	---Add 1 & 2---
	signal carry1, carry2: std_logic;
	signal add1_out, add2_out: std_logic_vector(31 downto 0);
	
	---Instruction memmory---
	signal InstructMem_out: std_logic_vector(31 downto 0);
	
	---Control--- 
	signal branch: std_logic_vector(1 downto 0);
	signal memread: std_logic;
	signal memtoreg: std_logic;
	signal aluctrl: std_logic_vector(4 downto 0);
	signal memwrite: std_logic;
	signal alusrc: std_logic;
	signal regwrite: std_logic;
	signal immgen: std_logic_vector(1 downto 0);
	
	---Registers---
	signal Mux_to_Registers: std_logic_vector(31 downto 0);
	signal read_data1: std_logic_vector(31 downto 0);
	signal read_data2: std_logic_vector(31 downto 0);
	
	---Imm Gen---
	signal ImmGen_out: std_logic_vector(31 downto 0);
	
	---ALU---
	signal MuxALU_out: std_logic_vector(31 downto 0);
	signal ALU_out: std_logic_vector(31 downto 0);
	signal zero: std_logic;
	
	---RAM---
	signal memAddress: std_logic_vector(31 downto 0);
	signal RAM_out: std_logic_vector(31 downto 0);
	
	signal carry: std_logic;
	signal BEQ_BNE_out: std_logic;
	
	
	begin
	
		add1: adder_subtracter port map(PC_out, "00010000000000000000000000000000", "00000", add1_out, carry1);
		add2: adder_subtracter port map(PC_out, ImmGen_out ,"00000", add2_out, carry2);
		BEQ_BNE_out <= '1' when (branch = "01" and zero = '1') or (branch = "10" and zero = '0') else '0';
		
		MUX_PC: BusMux2to1 port map(BEQ_BNE_out, add1_out, add2_out, Mux_to_PC);
		ProcPC: ProgramCounter port map(reset, clock, Mux_to_PC, PC_Out);
		
		with immgen select
			ImmGen_out(31 downto 12) <= InstructMem_out(31 downto 12) when "11",
						(others=>InstructMem_out(31)) when others;
		with immgen select
			ImmGen_out(11 downto 0) <= InstructMem_out(31 downto 20) when "00",
						InstructMem_out(31 downto 25) & InstructMem_out(11 downto 7) when "01",
						InstructMem_out(7) & InstructMem_out(30 downto 25) & InstructMem_out(11 downto 8) & '0' when "10",
						(others=>'0') when others;
		
		Instruction_memory: InstructionRAM port map(reset, clock, PC_Out(31 downto 2), InstructMem_out);
		ProCtrl: Control port map(clock, InstructMem_out(6 downto 0), InstructMem_out(14 downto 12), InstructMem_out(31 downto 25), branch, memread, memtoreg, aluctrl, memwrite, alusrc, regwrite, immgen);
		REG: Registers port map(InstructMem_out(19 downto 15), InstructMem_out(24 downto 20) , InstructMem_out(11 downto 7), Mux_to_Registers, regwrite, read_data1, read_data2);
		
		MUX_to_ALU: BusMux2to1 port map(alusrc, read_data2, ImmGen_out, MuxALU_out);
		ProALU: ALU port map(read_data1, MuxALU_out, aluctrl, zero, ALU_out);
		
		Memoryaddress: adder_subtracter port map(ALU_out, "00000000000000000000000000001000", "00001", memAddress, carry);
		Data_memory: RAM port map(reset, clock, memread, memwrite, memAddress(31 downto 2), read_data2, RAM_out);
		MUX_Registers: BusMux2to1 port map(memtoreg, ALU_out, RAM_out, Mux_to_Registers);
	
		
	
		
end holistic;

