library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spiMaster is
	Generic(
		clk_scaler : integer := 5;
		byte_long : integer := 18
	);
	Port(
		enable_spi : in STD_LOGIC;
		clk_50Mhz : in STD_LOGIC;
		clk_10Mhz : inout STD_LOGIC;
		cs : out STD_LOGIC;
		din : out STD_LOGIC;
		dout : in STD_LOGIC;
		adc_data : out STD_LOGIC_VECTOR(11 downto 0);
		adc_data_tempo : out STD_LOGIC_VECTOR(11 downto 0);
		count : out integer range 0 to 12 := 0
	);
end entity;

architecture spiMaster_arc of spiMaster is

type spi_state is (idle, execute);
signal trig_spi : spi_state := idle;  
signal scale_cnt : integer range 0 to clk_scaler - 1 := 0;
signal clk_10Mhz_temp : STD_LOGIC := '0';
signal adc_data_temp : STD_LOGIC_VECTOR(11 downto 0);
signal enable_out : STD_LOGIC;
signal din_byte : STD_LOGIC_VECTOR(5 downto 0):= "111111";
signal din_index : integer range 0 to 5 := 0;
signal dout_index : integer range 0 to 11 := 0;
signal byte_cnt : integer range 0 to byte_long - 1 := 0;

begin
	clock_scale_proc : process(clk_50Mhz)
	begin
		if rising_edge(clk_50Mhz) then
			if scale_cnt = clk_scaler -1  then
				clk_10Mhz_temp <= not(clk_10Mhz_temp);
				scale_cnt <= 0;
			else
				scale_cnt <= scale_cnt + 1;
			end if;
		end if;
	end process clock_scale_proc;
	
	clk_10Mhz <= clk_10Mhz_temp;

	spi_proc : process(clk_10Mhz)
	begin
		if rising_edge(clk_10Mhz) then
			case trig_spi is
				when idle =>
					din <= '0';
					cs <= '1';
					byte_cnt <= 0;
					trig_spi <= execute;
				when execute =>
					cs <= '0';
					if byte_cnt < byte_long - 1 then
						if byte_cnt < 5 then
							din <= din_byte(din_index);
							din_index <= din_index + 1;
						else
							din <= '0';
							adc_data_temp(dout_index) <= dout;
							adc_data_tempo <= adc_data_temp;
							dout_index <= dout_index + 1;
						end if;
						byte_cnt <= byte_cnt + 1;
					else 
						adc_data <= adc_data_temp;
						adc_data_temp <= "000000000000";
						byte_cnt <= 0;
						din_index <= 0;
						dout_index <= 0;
						trig_spi <= idle;
					end if;
					count <= byte_cnt;
			end case;
		end if;
	end process spi_proc;
end spiMaster_arc;
