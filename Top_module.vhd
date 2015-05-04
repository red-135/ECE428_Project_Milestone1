
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_module is
	port
	(
		clk : in std_logic ;
		rst : in std_logic ;
		
		fin_addr_out : out std_logic;
		cap_pixel_out : out std_logic_vector(4 downto 0);
		ref_pixel_out : out std_logic_vector(4 downto 0);
		abs_value_out : out std_logic_vector(4 downto 0);
		accum_total : out std_logic_vector(22 downto 0)
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
		abs_value_out => abs_value_out,
		accum_total => accum_total
	);
	
	DL_cap : Entity work.variable_delay
	generic map
	(
		line_width => 5,
		line_length => 4
	)
	port map
	(
		clk => clk,
		ena => '1',
		rst => rst,
		input => cap_pixel,
		output => cap_pixel_out
	);
	
	DL_ref : Entity work.variable_delay
	generic map
	(
		line_width => 5,
		line_length => 4
	)
	port map
	(
		clk => clk,
		ena => '1',
		rst => rst,
		input => ref_pixel,
		output => ref_pixel_out
	);
	
	DL_fin_addr : Entity work.variable_delay_bit
	generic map
	(
		line_length => 4
	)
	port map
	(
		clk => clk,
		ena => '1',
		rst => rst,
		input => fin_addr,
		output => fin_addr_out
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
