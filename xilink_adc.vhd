library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity coba_upload is
	Generic(
		clk_scaler : integer := 5;
		byte_long : integer := 18
	);
	Port(
--		enable_spi : in STD_LOGIC;
		clk_50Mhz : in STD_LOGIC;
		clk_10Mhz : out STD_LOGIC;
		cs : out STD_LOGIC;
		din : out STD_LOGIC;
		dout : in STD_LOGIC;
--		adc_data : out STD_LOGIC_VECTOR(11 downto 0);
		led_out : out STD_LOGIC_VECTOR(7 downto 0) := "00000000"
--		adc_data_tempo : out STD_LOGIC_VECTOR(11 downto 0);
--		count : out integer range 0 to 12 := 0;
--		state : out std_logic_vector(1 downto 0);
--		dout_i : out integer range 0 to 12 := 0
	);
end entity;

architecture spiMaster_arc of coba_upload is

type spi_state is (idle, execute);
type execute_state is (din_state, dout_state);
signal trig_spi : spi_state := idle;
signal trig_execute : execute_state := din_state;  
signal scale_cnt : integer range 0 to clk_scaler - 1 := 0;
signal clk_10Mhz_temp : STD_LOGIC := '1';
signal adc_data_temp : STD_LOGIC_VECTOR(11 downto 0);
signal enable_out : STD_LOGIC;
signal din_byte : STD_LOGIC_VECTOR(0 to 5):= "100010";
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

	spi_proc : process(clk_10Mhz_temp)
	begin
		if rising_edge(clk_10Mhz_temp) then
			case trig_spi is
				when idle =>
--					adc_data <= adc_data_temp;
					led_out <= adc_data_temp(7 downto 0);
					adc_data_temp <= "000000000000";
--					adc_data_tempo <= "000000000000";
					din <= '0';
					cs <= '1';
					byte_cnt <= 0;
					trig_spi <= execute;
--					state <= "00";
				when execute =>
					cs <= '0';
					case trig_execute is
						when din_state =>
							if byte_cnt = 5 then
								din <= din_byte(din_index);
								trig_execute <= dout_state;
								byte_cnt <= 0;
								din_index <= 0;
							else
								byte_cnt <= byte_cnt + 1;
								din <= din_byte(din_index);
								din_index <= din_index + 1;
--								state <= "01";
								end if;
						when dout_state =>
							din <= '0';
							if byte_cnt = 11 then
								adc_data_temp(dout_index) <= dout;
--								adc_data_tempo(dout_index) <= dout;
								dout_index <= 0;
								byte_cnt <= 0;
								trig_execute <= din_state;
								trig_spi <= idle;
							else
								adc_data_temp(dout_index) <= dout;
--								adc_data_tempo(dout_index) <= dout;
								byte_cnt <= byte_cnt + 1;
								dout_index <= dout_index + 1;
--								state <= "10";
							end if;						
					end case;
--					count <= byte_cnt;
--					dout_i <= dout_index;
					
			end case;
		end if;
	end process spi_proc;
end spiMaster_arc;
