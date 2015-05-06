--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:23:11 05/04/2015
-- Design Name:   
-- Module Name:   C:/Users/Steven/OneDrive/Documents/School/ECE_428/Project-Xilinx/Project-M1-Xilinx/pixel_sub_tb.vhd
-- Project Name:  Project-M1-Xilinx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pixel_sub
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pixel_sub_tb IS
END pixel_sub_tb;
 
ARCHITECTURE behavior OF pixel_sub_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pixel_sub
    PORT(
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
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal en : std_logic := '0';
   signal fin_addr : std_logic := '0';
   signal cap_pixel : std_logic_vector(4 downto 0) := (others => '0');
   signal ref_pixel : std_logic_vector(4 downto 0) := (others => '0');

 	--Outputs
	signal en_passthru : std_logic;
	signal fin_addr_passthru : std_logic;
	signal cap_pixel_passthru : std_logic_vector(4 downto 0);
	signal ref_pixel_passthru : std_logic_vector(4 downto 0);
   signal dif_pixel : std_logic_vector(4 downto 0);
   signal threshold : std_logic_vector(2 downto 0);
   signal total : std_logic_vector(22 downto 0);
	

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pixel_sub PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          fin_addr => fin_addr,
          cap_pixel => cap_pixel,
          ref_pixel => ref_pixel,
			 en_passthru => en_passthru,
			 fin_addr_passthru => fin_addr_passthru,
			 cap_pixel_passthru => cap_pixel_passthru,
			 ref_pixel_passthru => ref_pixel_passthru,
          dif_pixel => dif_pixel,
		  threshold => threshold,
          total => total
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
	
		--wait for 1/2*clk_period;
		
		rst <= '1';
		wait for 2*clk_period;
		rst <= '0';
		
		wait for 4*clk_period;
		
		en<='1';
		cap_pixel <= "00000";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00001";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00010";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		fin_addr <='0';
		cap_pixel <= "00011";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='0';
		fin_addr <='0';
		cap_pixel <= "11111";
		ref_pixel <= "00000";
		wait for 8*clk_period;
		
		en<='1';
		cap_pixel <= "00011";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00100";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00101";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		fin_addr <='1';
		cap_pixel <= "00110";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='0';
		fin_addr <='0';
		cap_pixel <= "11111";
		ref_pixel <= "00000";
		wait for 8*clk_period;
		
		en<='0';
		fin_addr <='0';
		cap_pixel <= "11111";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00011";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00100";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		cap_pixel <= "00101";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='1';
		fin_addr <='1';
		cap_pixel <= "00110";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
		en<='0';
		fin_addr <='0';
		cap_pixel <= "11111";
		ref_pixel <= "00000";
		wait for 1*clk_period;
		
      wait;
   end process;

END;
