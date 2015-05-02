----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:34:43 04/25/2013 
-- Design Name: 
-- Module Name:    addrgen_1_a - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity addrgen_2_a is
port (

  clk : in std_logic ;
  wea : out std_logic_vector(0 downto 0);
  cnt1 : out std_logic_vector(17 DOWNTO 0);
  reset : in std_logic 
);

end addrgen_2_a;

architecture Behavioral of addrgen_2_a is
signal cnt : std_logic_vector(17 DOWNTO 0);
signal addr1	: natural := 3;
begin

	ADDRCNT_PROC: process (CLK)
   begin
      if Rising_Edge(CLK) then
		if (reset = '1') then 
		  addr1 <= 3 ;
		  else
				if (addr1 >= 153603) then                    
					wea   <= "1";
					addr1 <= 3 ;
				else
					addr1 <= addr1 + 1;
					wea   <= "1";
				end if;
			end if ;
		end if ;
   end process;
	
cnt <=conv_std_logic_vector(addr1 ,18);
cnt1 <= cnt ;
end Behavioral;