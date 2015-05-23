library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity memory_system is
	port (
		clk : in std_logic ;
		Reset_Main : in std_logic;
		video_en : out std_logic;
		fin_addr : out std_logic;
		data_out1 : out std_logic_vector(4 downto 0);
		data_out2 : out std_logic_vector(4 downto 0)
	);
end memory_system;

architecture Behavioral of memory_system is
	signal addr_1b,addr_2b : std_logic_vector(17 downto 0);
	signal Vde, en_ram1,en_ram2 : std_logic ;
	signal fin_addr_pre : std_logic;

begin

	video_en <= Vde;

	addr_comparator: process(clk, Reset_Main, addr_1b)
	begin
		if (Reset_Main = '1') then
			fin_addr_pre <= '0';
			fin_addr <= '0';
		else
			--USE DURING TESTING
			--if(addr_1b = std_logic_vector(to_unsigned(31, addr_1b'length))) then
			
			if(addr_1b = std_logic_vector(to_unsigned(153599, addr_1b'length))) then
				fin_addr_pre <= '1';
			else
				fin_addr_pre <= '0';
			end if;
			
			if (rising_edge(clk)) then
				fin_addr <= fin_addr_pre;
			end if;
		end if;
	end process;

	Inst_addr_1b : Entity work.addrgen_1_b
	port map (
		clk    => clk ,
		addr_1b => addr_1b ,
		en_ram1 => en_ram1 ,
		Reset_Main => Reset_Main ,
		VtcVde => Vde
	);

	Inst_addr_2b : Entity work.addrgen_2_b
	port map (
		clk    => clk ,
		addr_2b => addr_2b ,
		en_ram2 => en_ram2 ,
		Reset_Main => Reset_Main ,
		VtcVde => Vde
	);
	
	Inst_memory_subsystem : Entity work.memory_subsystem
	port map (
		Reset   => Reset_Main,						  
		PClk    => clk ,        
		ram_out_1  => data_out1 ,  
		ram_out_2  => data_out2 ,
		addr_1_b   => addr_1b ,
		addr_2_b   => addr_2b , 
		en_1       => en_ram1 , 
		en_2       => en_ram2 ,
		VtcVde     => Vde 
	);

end Behavioral;
