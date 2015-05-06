
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity pixel_sub is
	port (
		clk : in std_logic;
		rst : in std_logic;
		en : in std_logic;
		fin_addr : in std_logic;
		cap_pixel : in std_logic_vector(4 downto 0);
		ref_pixel : in std_logic_vector(4 downto 0);
		
		en_passthru : out std_logic;
		
		threshold : out std_logic_vector(2 downto 0);
		abs_value_out : out std_logic_vector(4 downto 0);
		accum_total : out std_logic_vector(22 downto 0)
	);
end pixel_sub;

architecture Behavioral of pixel_sub is
	signal fin_addr_stage1 : std_logic;	
	signal fin_addr_stage2 : std_logic;
	signal fin_addr_stage3 : std_logic;
	
	signal cap_pixel_stage1 : std_logic_vector(4 downto 0);
	signal ref_pixel_stage1 : std_logic_vector(4 downto 0);

	signal abs_value : std_logic_vector(4 downto 0);
	signal abs_value_temp : std_logic_vector(4 downto 0);
	
	signal accumulator : std_logic_vector(22 downto 0);
	signal accumulator_temp : std_logic_vector(22 downto 0);
	
	signal total : std_logic_vector(22 downto 0);
	signal total_temp : std_logic_vector(22 downto 0);
	
	signal threshold_in : std_logic_vector(2 downto 0);
	signal threshold_con : std_logic_vector(2 downto 0);
	signal threshold_temp : std_logic_vector(2 downto 0);
	
	signal abs_value_stage3 : std_logic_vector(4 downto 0);
	signal abs_value_stage4 : std_logic_vector(4 downto 0);
	
	signal cap_minus_ref : std_logic_vector(5 downto 0);
	signal ref_minus_cap : std_logic_vector(5 downto 0);
	
	signal en_delay1 : std_logic;
	signal en_delay2 : std_logic;
	signal en_delay3 : std_logic;
	
	signal one : std_logic;
	
	constant threshold0_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(8, 23));--2000000, 23));
	constant threshold1_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(16, 23));--1000000, 23));
	constant threshold2_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(24, 23));--100000, 23));
begin
	one <= '1';
	
	process_reset: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				fin_addr_stage1 <= '0';
				fin_addr_stage2 <= '0';
				fin_addr_stage3 <= '0';
				
				cap_pixel_stage1 <= (others => '0');
				ref_pixel_stage1 <= (others => '0');
			
				abs_value <= (others => '0');
				accumulator <= (others => '0');
				total <= (others => '0');
				
				abs_value_stage3 <= (others => '0');
				abs_value_stage4 <= (others => '0');
				
				en_delay1 <= '0';
				en_delay2 <= '0';
				en_delay3 <= '0';
				
				threshold_in <= (others => '0');
			else
				if (en = '1') then
				--if (one = '1') then
					cap_pixel_stage1 <= cap_pixel;
					ref_pixel_stage1 <= ref_pixel;
					
					fin_addr_stage1 <= fin_addr;
				end if;
				
				if (en_delay1 = '1') then
				--if (one = '1') then
					abs_value <= abs_value_temp;
					fin_addr_stage2 <= fin_addr_stage1;
				
				end if;
				
				if (en_delay2 = '1') then
				--if (one = '1') then
					abs_value_stage3 <= abs_value;
					fin_addr_stage3 <= fin_addr_stage2;
					accumulator <= accumulator_temp;
				end if;
				
				total <= total_temp;
				threshold_in <= threshold_temp;
				abs_value_stage4 <= abs_value_stage3;
				
				en_delay1 <= en;
				en_delay2 <= en_delay1;
				en_delay3 <= en_delay2;
			end if;
		end if;
	end process;
	
	process_stage1: process(cap_pixel_stage1, ref_pixel_stage1, cap_minus_ref, ref_minus_cap)
	begin
		cap_minus_ref <= std_logic_vector(signed('0'&cap_pixel_stage1) - signed('0'&ref_pixel_stage1));
		ref_minus_cap <= std_logic_vector(signed('0'&ref_pixel_stage1) - signed('0'&cap_pixel_stage1));
		
		if(cap_minus_ref(5) = '0') then
			abs_value_temp <= cap_minus_ref(4 downto 0);
		else
			abs_value_temp <= ref_minus_cap(4 downto 0);
		end if;
	end process;
	
	process_stage2: process(abs_value, accumulator, fin_addr_stage3, en_delay2)
	begin
		if(fin_addr_stage3 = '1') then
			--accumulator_temp <= (others => '0');
			if(en_delay2 = '1') then
				accumulator_temp(4 downto 0) <= abs_value;
				accumulator_temp(22 downto 5) <= (others => '0');
			else
				accumulator_temp <= (others => '0');
			end if;
		else
			accumulator_temp <= std_logic_vector(unsigned(accumulator) + unsigned(abs_value));
		end if;
	end process;
	
	process_stage3: process(fin_addr_stage3, accumulator, total, threshold_con, threshold_in)
	begin
		if (accumulator >= threshold0_value) then
			threshold_con(0) <= '1';
		else
			threshold_con(0) <= '0';
		end if;
		
		if (accumulator >= threshold1_value) then
			threshold_con(1) <= '1';
		else
			threshold_con(1) <= '0';
		end if;
		
		if (accumulator >= threshold2_value) then
			threshold_con(2) <= '1';
		else
			threshold_con(2) <= '0';
		end if;
	
		if(fin_addr_stage3 = '1') then		
			total_temp <= accumulator;
			threshold_temp <= threshold_con;
		else
			total_temp <= total;
			threshold_temp <= threshold_in;
		end if;
	end process;
	
	abs_value_out <= abs_value_stage3;
	en_passthru <= en_delay3;
	accum_total <= total;
	threshold <= threshold_in;
	
end Behavioral;

