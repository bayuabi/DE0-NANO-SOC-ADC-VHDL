library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spiMaster is
	Port(
		cs : out STD_LOGIC;
		din : out STD_LOGIC;
		dout : in STD_LOGIC;
		iClk : in STD_LOGIC;
		oClk : out STD_LOGIC;
		adcData : out STD_LOGIC_VECTOR(11 downto 0)
	);
end entity;

architecture spiMaster_arc of spiMaster is
signal count : integer range 0 to 17 := 0;
signal count_sc : integer range 0 to 4 ;
signal oClk_i : STD_LOGIC := '1';
begin
	process(iClk)
	begin
		if rising_edge(iClk) then
			if count_sc = 4 then
				oClk_i <= not(oClk_i);
				count_sc <= 0;
			else
				count_sc <= count_sc + 1;
			end if;
		end if;
	end process;
	oClk <= oClk_i;
	cs <= '0';
	process(oClk_i)
	begin
		if rising_edge(oClk_i) then
			if count < 17 then
				count <= count + 1;
			else
				count <= 0;
			end if;
		end if;
	end process;
	
	process(count)
	begin
		case count is
			when 0 => din <= '1';
			when 1 => din <= '0';
			when 2 => din <= '0';
			when 3 => din <= '0';
			when 4 => din <= '1';
			when 5 => din <= '0';
			when 6 => adcData(0) <= dout;
			when 7 => adcData(1) <= dout;
			when 8 => adcData(2) <= dout;
			when 9 => adcData(3) <= dout;
			when 10 => adcData(4) <= dout;
			when 11 => adcData(5) <= dout;
			when 12 => adcData(6) <= dout;
			when 13 => adcData(7) <= dout;
			when 14 => adcData(8) <= dout;
			when 15 => adcData(9) <= dout;
			when 16 => adcData(10) <= dout;
			when 17 => adcData(11) <= dout;
		end case;
	end process;
end spiMaster_arc;