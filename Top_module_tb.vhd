--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:00:08 05/02/2015
-- Design Name:   
-- Module Name:   C:/Users/Steven/OneDrive/Documents/School/ECE_428/Project/Project-M1-Xilinx/Top_module_tb.vhd
-- Project Name:  Project-M1-Xilinx
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Top_module
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
 
ENTITY Top_module_tb IS
END Top_module_tb;
 
ARCHITECTURE behavior OF Top_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top_module
    PORT(
			clk : IN  std_logic;
			rst : IN  std_logic;
			en_out : OUT std_logic;
			fin_addr_out : OUT  std_logic;
			cap_pixel_out : OUT  std_logic_vector(4 downto 0);
			ref_pixel_out : OUT  std_logic_vector(4 downto 0);
			dif_pixel_out : OUT  std_logic_vector(4 downto 0);
			total_out : OUT std_logic_vector(22 downto 0);
			threshold_out : OUT std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

	--Inputs
	signal clk : std_logic := '0';
	signal rst : std_logic := '1';

 	--Outputs
	signal en_out : std_logic;
	signal fin_addr_out : std_logic;
	signal cap_pixel_out : std_logic_vector(4 downto 0);
	signal ref_pixel_out : std_logic_vector(4 downto 0);
	signal dif_pixel_out : std_logic_vector(4 downto 0);
	signal total_out : std_logic_vector(22 downto 0);
	signal threshold_out : std_logic_vector(2 downto 0);

	-- Clock period definitions
	constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top_module PORT MAP (
			clk => clk,
			rst => rst,
			en_out => en_out,
			fin_addr_out => fin_addr_out,
			cap_pixel_out => cap_pixel_out,
			ref_pixel_out => ref_pixel_out,
			dif_pixel_out => dif_pixel_out,
			total_out => total_out,
			threshold_out => threshold_out
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
		rst <= '1';
		wait for 2*clk_period;	
		rst <= '0';

		wait;
   end process;

END;
