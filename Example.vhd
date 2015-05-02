
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Example is
	port (
		clk : in std_logic ;
		Reset_Main : in std_logic ;
		data_out1 : out std_logic_vector(4 downto 0);
		data_out2 : out std_logic_vector(4 downto 0)
	);
end Example;

architecture Behavioral of Example is
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
------------------------------------------------------------------------

	begin

	Inst_addr_1b : addrgen_1_b
	port map (
		clk    => clk ,
		addr_1b => addr_1b ,
		en_ram1 => en_ram1 ,
		Reset_Main => Reset_Main ,
		VtcVde => Vde
	);

	Inst_top_module : Entity work.top_module
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
