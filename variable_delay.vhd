library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity variable_delay is
	generic
	(
		line_width : integer := 8;
		line_length : integer := 4
	);
	port (
		clk : in std_logic;
		ena : in std_logic;
		rst : in std_logic;
		input : in std_logic_vector(line_width-1 downto 0);
		output : out std_logic_vector(line_width-1 downto 0)
	);
end variable_delay;

architecture behavioral of variable_delay is
	subtype line_type is std_logic_vector (line_width-1 downto 0);
	type delay_line_type is array (line_length-1 downto 0) of line_type;
	
	signal delay_line : delay_line_type;
begin
	output <= delay_line(0);
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				for i in 0 to line_length-1 loop
					delay_line(i) <= (others => '0');
				end loop;
			elsif (ena = '1') then
				for i in 0 to line_length-2 loop
					delay_line(i) <= delay_line(i+1);
				end loop;
				delay_line(line_length-1) <= input;
			end if;
		end if;
	end process;
end behavioral;
