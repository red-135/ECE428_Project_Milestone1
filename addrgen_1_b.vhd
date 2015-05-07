library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addrgen_1_b is
	port
	(
	clk : in std_logic;
	Reset_Main : in std_logic;
	VtcVde : in std_logic;
	
	en_ram1 : out std_logic;
	addr_1b : out std_logic_vector (17 downto 0)
	);
end addrgen_1_b;

architecture behavior of addrgen_1_b is
	signal cnt : std_logic_vector(17 downto 0);
begin
	addr_1b <= cnt;
	
	counter: process(clk, Reset_Main, VtcVde, cnt)
	begin
		if (rising_edge(clk)) then
			if (Reset_Main = '1') then
				cnt <= (others => '0');
				en_ram1 <= '0';
			else
				if (VtcVde = '1') then
					if (cnt = "100101011111111111") then
						cnt <= (others => '0');
						en_ram1 <= '1';
					else
						cnt <= std_logic_vector(unsigned(cnt) + 1);
						en_ram1 <= '1';
					end if;
				else
					cnt <= cnt;
					en_ram1 <= '0';
				end if;
			end if;
		end if;
	end process;
end behavior;