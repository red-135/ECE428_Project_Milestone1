library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pixel_sub is
	port (
		clk : in std_logic;
		rst : in std_logic;
		en : in std_logic;
		fin_addr : in std_logic;
		cap_pixel : in std_logic_vector(4 downto 0);
		ref_pixel : in std_logic_vector(4 downto 0);
		
		en_passthru : out std_logic;
		fin_addr_passthru : out std_logic;
		cap_pixel_passthru : out std_logic_vector(4 downto 0);
		ref_pixel_passthru : out std_logic_vector(4 downto 0);
		dif_pixel : out std_logic_vector(4 downto 0);
		threshold : out std_logic_vector(2 downto 0);
		total : out std_logic_vector(22 downto 0)
	);
end pixel_sub;

architecture Behavioral of pixel_sub is
	signal fin_addr_stage1 : std_logic;	
	signal fin_addr_stage2 : std_logic;
	signal fin_addr_stage3 : std_logic;
	signal fin_addr_stage4_temp : std_logic;
	signal fin_addr_stage4 : std_logic;
	
	signal cap_pixel_stage1 : std_logic_vector(4 downto 0);
	signal cap_pixel_stage2 : std_logic_vector(4 downto 0);
	signal cap_pixel_stage3 : std_logic_vector(4 downto 0);
	signal ref_pixel_stage1 : std_logic_vector(4 downto 0);
	signal ref_pixel_stage2 : std_logic_vector(4 downto 0);
	signal ref_pixel_stage3 : std_logic_vector(4 downto 0);
	
	signal cap_minus_ref : std_logic_vector(5 downto 0);
	signal ref_minus_cap : std_logic_vector(5 downto 0);
	
	signal dif_pixel_stage2_temp : std_logic_vector(4 downto 0);
	signal dif_pixel_stage2 : std_logic_vector(4 downto 0);
	signal dif_pixel_stage3 : std_logic_vector(4 downto 0);
	signal dif_pixel_stage4 : std_logic_vector(4 downto 0);
	
	signal accumulator_stage3_temp : std_logic_vector(22 downto 0);
	signal accumulator_stage3 : std_logic_vector(22 downto 0);
	
	signal total_stage4_temp : std_logic_vector(22 downto 0);
	signal total_stage4 : std_logic_vector(22 downto 0);
	
	signal threshold_stage4_new : std_logic_vector(2 downto 0);
	signal threshold_stage4_temp : std_logic_vector(2 downto 0);
	signal threshold_stage4 : std_logic_vector(2 downto 0);
	
	signal en_stage1 : std_logic;
	signal en_stage2 : std_logic;
	signal en_stage3 : std_logic;
	
	constant threshold0_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(2000000, 23));
	constant threshold1_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(1000000, 23));
	constant threshold2_value : std_logic_vector(22 downto 0) := std_logic_vector(to_unsigned(100000, 23));
begin
	
	en_passthru <= en_stage3;
	fin_addr_passthru <= fin_addr_stage4;
	cap_pixel_passthru <= cap_pixel_stage3;
	ref_pixel_passthru <= ref_pixel_stage3;
	dif_pixel <= dif_pixel_stage3;
	threshold <= threshold_stage4;
	total <= total_stage4;
	
	process_synch: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				fin_addr_stage1 <= '0';
				fin_addr_stage2 <= '0';
				fin_addr_stage3 <= '0';
				fin_addr_stage4 <= '0';
				
				cap_pixel_stage1 <= (others => '0');
				cap_pixel_stage2 <= (others => '0');
				cap_pixel_stage3 <= (others => '0');
				ref_pixel_stage1 <= (others => '0');
				ref_pixel_stage2 <= (others => '0');
				ref_pixel_stage3 <= (others => '0');
			
				dif_pixel_stage2 <= (others => '0');
				dif_pixel_stage3 <= (others => '0');
				dif_pixel_stage4 <= (others => '0');
				
				accumulator_stage3 <= (others => '0');
				
				total_stage4 <= (others => '0');
				threshold_stage4 <= (others => '0');
				
				en_stage1 <= '0';
				en_stage2 <= '0';
				en_stage3 <= '0';
			else
				if (en = '1') then
					cap_pixel_stage1 <= cap_pixel;
					ref_pixel_stage1 <= ref_pixel;
					fin_addr_stage1 <= fin_addr;
				end if;
				
				if (en_stage1 = '1') then
					cap_pixel_stage2 <= cap_pixel_stage1;
					ref_pixel_stage2 <= ref_pixel_stage1;
					dif_pixel_stage2 <= dif_pixel_stage2_temp;
					fin_addr_stage2 <= fin_addr_stage1;
				end if;
				
				if (en_stage2 = '1') then
					cap_pixel_stage3 <= cap_pixel_stage2;
					ref_pixel_stage3 <= ref_pixel_stage2;
					dif_pixel_stage3 <= dif_pixel_stage2;
					accumulator_stage3 <= accumulator_stage3_temp;
					fin_addr_stage3 <= fin_addr_stage2;
				end if;
				
				fin_addr_stage4 <= fin_addr_stage4_temp;
				dif_pixel_stage4 <= dif_pixel_stage3;
				total_stage4 <= total_stage4_temp;
				threshold_stage4 <= threshold_stage4_temp;
				
				en_stage1 <= en;
				en_stage2 <= en_stage1;
				en_stage3 <= en_stage2;
			end if;
		end if;
	end process;
	
	process_stage1: process(cap_pixel_stage1, ref_pixel_stage1, cap_minus_ref, ref_minus_cap)
	begin
		cap_minus_ref <= std_logic_vector(signed('0'&cap_pixel_stage1) - signed('0'&ref_pixel_stage1));
		ref_minus_cap <= std_logic_vector(signed('0'&ref_pixel_stage1) - signed('0'&cap_pixel_stage1));
		
		if(cap_minus_ref(5) = '0') then
			dif_pixel_stage2_temp <= cap_minus_ref(4 downto 0);
		else
			dif_pixel_stage2_temp <= ref_minus_cap(4 downto 0);
		end if;
	end process;
	
	process_stage2: process(dif_pixel_stage2, accumulator_stage3, fin_addr_stage3, en_stage2)
	begin
		
		if(fin_addr_stage3 = '1') then
			if(en_stage2 = '1') then
				accumulator_stage3_temp(22 downto 5) <= (others => '0');
				accumulator_stage3_temp(4 downto 0) <= dif_pixel_stage2;
			else
				accumulator_stage3_temp <= (others => '0');
			end if;	
		else
			accumulator_stage3_temp <= std_logic_vector(unsigned(accumulator_stage3) + unsigned(dif_pixel_stage2));
		end if;
	end process;
	
	process_stage3: process(fin_addr_stage3, accumulator_stage3, total_stage4, threshold_stage4_new, threshold_stage4, en_stage3)
	begin
		if (accumulator_stage3 >= threshold0_value) then
			threshold_stage4_new(0) <= '1';
		else
			threshold_stage4_new(0) <= '0';
		end if;
		
		if (accumulator_stage3 >= threshold1_value) then
			threshold_stage4_new(1) <= '1';
		else
			threshold_stage4_new(1) <= '0';
		end if;
		
		if (accumulator_stage3 >= threshold2_value) then
			threshold_stage4_new(2) <= '1';
		else
			threshold_stage4_new(2) <= '0';
		end if;
		
		if(fin_addr_stage3 = '1') then
			total_stage4_temp <= accumulator_stage3;
			threshold_stage4_temp <= threshold_stage4_new;
			fin_addr_stage4_temp <= en_stage3;
		else
			total_stage4_temp <= total_stage4;
			threshold_stage4_temp <= threshold_stage4;
			fin_addr_stage4_temp <= '0';
		end if;
	end process;
	
end Behavioral;

