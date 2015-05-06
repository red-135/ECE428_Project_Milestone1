
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_module is
	port
	(
		clk : in std_logic ;
		rst : in std_logic ;
		
		en_out : out std_logic;
		fin_addr_out : out std_logic;
		cap_pixel_out : out std_logic_vector(4 downto 0);
		ref_pixel_out : out std_logic_vector(4 downto 0);
		dif_pixel_out : out std_logic_vector(4 downto 0);
		total_out : out std_logic_vector(22 downto 0);
		threshold_out : out std_logic_vector(2 downto 0)
	);
end Top_module;

architecture Behavioral of Top_module is
	signal video_en : std_logic;
	signal fin_addr : std_logic;
	signal cap_pixel : std_logic_vector(4 downto 0);
	signal ref_pixel : std_logic_vector(4 downto 0);
begin

	PX1 : Entity work.pixel_sub
	port map
	(
		clk => clk,
		rst => rst,
		en => video_en,
		fin_addr => fin_addr,
		cap_pixel => cap_pixel,
		ref_pixel => ref_pixel,
		en_passthru => en_out,
		fin_addr_passthru => fin_addr_out,
		cap_pixel_passthru => cap_pixel_out,
		ref_pixel_passthru => ref_pixel_out,
		dif_pixel => dif_pixel_out,
		threshold => threshold_out,
		total => total_out
	);
	
	MS1 : Entity work.memory_system
	port map (
		clk => clk,
		Reset_Main => rst,
		video_en => video_en,
		fin_addr => fin_addr,
		data_out1 => cap_pixel,
		data_out2 => ref_pixel
	);

end Behavioral;
