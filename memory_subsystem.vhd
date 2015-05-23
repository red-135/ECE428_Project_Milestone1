
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

library UNISIM;
use UNISIM.VComponents.all;


entity memory_subsystem is
	port (

		Reset    : in std_logic ;
		-- resets the counter used for data input 
		-- and resets the write address generation mechanism

		-- PClk is the clock for read operation		
		PClk         : in std_logic ;                
			
		-- data output from RAM1 and RAM2		
		ram_out_1   : out std_logic_vector(4 downto 0);  -- data out from RAM1
		ram_out_2   : out std_logic_vector(4 downto 0);	 -- data out from RAM1	

		-- address ports of RAM1
		addr_1_b    : in std_logic_vector(17 downto 0);  -- Read  Port RAM1
			
		-- address ports of RAM2
		addr_2_b    : in  std_logic_vector(17 downto 0); -- Read  Port RAM2
			
		-- READ enable ports for RAM1 and RAM2
			
		en_1         : in std_logic ;   -- Read Enable RAM1
		en_2         : in std_logic ;	-- Read Enable RAM2

		-- VtcVde (Video transmitter control video data enable)
		-- Goes to 1 after 1 clock cycle when Reset is pulled to zero
		
		VtcVde       : out std_logic   
	);
		
end memory_subsystem;

architecture Behavioral of memory_subsystem is
	signal data_in_1 , data_in_2 : std_logic_vector(4 downto 0);
	signal addr_1_a , addr_2_a : std_logic_vector(17 downto 0);
	signal PClk_in, PClk_180_in : std_logic ;
	signal not_Reset : std_logic;
	signal VtcVde_inter : std_logic;
begin

	RAM_1 : Entity work.Ram_out_1
	port map (
		Reset_write => Reset,
		Reset       => Reset ,
		pclk        => PClk_in ,
		pclk_180    => PClk_180_in ,
		data_out_1  => ram_out_1 ,
		data_in_1   => data_in_1 ,
		adr_1_a     => addr_1_a ,
		enb         => en_1 ,
		adr_1_b     => addr_1_b
	);

	RAM_2 : Entity work.Ram_out_2
	port map (
		Reset_write => Reset,
		Reset       => Reset ,
		pclk        => PClk_in ,
		pclk_180    => PClk_180_in ,
		data_out_2  => ram_out_2 ,
		data_in_2   => data_in_2 ,
		adr_2_a     => addr_2_a ,
		enb         => en_2 ,
		adr_2_b     => addr_2_b
	);

	--------------------------------------------------------------------
	-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
	-- Clock Enable (posedge clk).
	-- Spartan-6
	-- Xilinx HDL Libraries Guide, version 14.1
	--------------------------------------------------------------------

	FDCE_inst1 : FDCE
	generic map (
		INIT => '0') -- Initial value of register ('0' or '1')
	port map (
		Q => VtcVde, -- Data output
		C => PClk, -- Clock input
		CE => not_Reset, -- Clock enable input
		CLR => Reset, -- Asynchronous clear input
		D => '1' -- Data input
	);
	
	not_Reset <= not Reset;

	Pclk_in <= Not PClk ;
	PClk_180_in <= PClk ; 

end Behavioral;

