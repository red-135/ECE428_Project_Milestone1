---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

library UNISIM;
use UNISIM.VComponents.all;

entity Ram_out_2 is
	port (
		Reset_write : in std_logic ;
		reset : in std_logic ;
		pclk : in std_logic ;
		pclk_180  : in std_logic ;
		data_out_2  : out std_logic_vector(4 downto 0);
		data_in_2  : out std_logic_vector(4 downto 0);
		adr_2_a : out std_logic_vector(17 downto 0);
		enb : in std_logic ;
		adr_2_b : in std_logic_vector(17 downto 0)       -- write address RAM2
	);
end Ram_out_2;

architecture Behavioral of Ram_out_2 is
	signal addrra : std_logic_vector (17 DOWNTO 0);
	signal data : natural := 0 ;
	signal data_in : std_logic_vector(4 downto 0):= "00000";
	signal ena : std_logic ;
	signal wea : std_logic_vector(0 downto 0) ;

	begin
	--------------------------------------------------------------------------
	-- data in counter
	--------------------------------------------------------------------------
	process (pclk)
		begin
			if rising_edge(pclk) then
				if (reset = '1') then 
					data <= 0 ;
				else
					data <= data + 1 ;
				end if ;
			end if;
	end process ;

	data_in <=conv_std_logic_vector(data ,5);

	-----------------------------------------------------------------------------

	RAM2 : Entity work.bram2
	port map (
		clka   => pclk,
		ena    => ena,
		enb    => enb,
		wea    => wea,
		addra  => addrra,
		dina   => data_in,
		-- read ports
		clkb   => pclk_180,
		addrb  => adr_2_b,                    -- read address
		doutb  => data_out_2
	);

	addrgen2a : entity work.addrgen_2_a
	port map (
		clk => pclk ,
		wea => wea,
		cnt1 => addrra,
		reset => Reset_write
	);


	adr_2_a <= addrra ;
	ena <= '1';
	data_in_2 <= data_in ;

end Behavioral;