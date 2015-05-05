
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

-----------------------------------------------------------------------
-- Verilog Module Instantiation
-----------------------------------------------------------------------

	component addrgen_1_b
		port ( clk    : in std_logic ;  
		addr_1b : out std_logic_vector(17 downto 0) ; 
		en_ram1 : out std_logic ; 
		Reset_Main : in std_logic ;
		VtcVde : in std_logic );

	end component;
	
	component addrgen_2_b
		port ( clk    : in std_logic ;  
		addr_2b : out std_logic_vector(17 downto 0) ; 
		en_ram2 : out std_logic ; 
		Reset_Main : in std_logic ;
		VtcVde : in std_logic );

	end component;
------------------------------------------------------------------------

	signal carcas : std_logic;
begin

	video_en <= Vde xor carcas;

	addr_comparator: process(addr_1b)
		begin
		-- if(addr_1b = std_logic_vector(to_unsigned(153599, addr_1b'length))) then
		if(addr_1b = std_logic_vector(to_unsigned(31, addr_1b'length))) then
			fin_addr <= '1';
			carcas <= '1';
		else
			fin_addr <= '0';
			carcas <= '0';
		end if;
	end process;

	Inst_addr_1b : addrgen_1_b
	port map (
		clk    => clk ,
		addr_1b => addr_1b ,
		en_ram1 => en_ram1 ,
		Reset_Main => Reset_Main ,
		VtcVde => Vde
	);

	Inst_addr_2b : addrgen_2_b
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
