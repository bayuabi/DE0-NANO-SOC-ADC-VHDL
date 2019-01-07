LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY xilinx_adc_tb IS
END xilinx_adc_tb;
 
ARCHITECTURE behavior OF xilinx_adc_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spiMaster
    PORT(
         enable_spi : IN  std_logic;
         clk_50Mhz : IN  std_logic;
         clk_10Mhz : INOUT  std_logic;
         cs : OUT  std_logic;
         din : OUT  std_logic;
         dout : IN  std_logic;
         adc_data : OUT  std_logic_vector(11 downto 0);
         adc_data_tempo : OUT  std_logic_vector(11 downto 0);
         count : OUT integer range 0 to 18 := 0;
			state : out std_logic_vector (1 downto 0);
			dout_i : out integer range 0 to 12 := 0
        );
    END COMPONENT;
    

   --Inputs
   signal enable_spi : std_logic := '0';
   signal clk_50Mhz : std_logic := '0';
   signal dout : std_logic := '0';

	--BiDirs
   signal clk_10Mhz : std_logic;

 	--Outputs
   signal cs : std_logic;
   signal din : std_logic;
   signal adc_data : std_logic_vector(11 downto 0);
   signal adc_data_tempo : std_logic_vector(11 downto 0);
   signal count : integer range 0 to 18 := 0;
	signal state : std_logic_vector(1 downto 0);
	signal dout_i : integer range 0 to 12 := 0;

   -- Clock period definitions
   constant clk_50Mhz_period : time := 20 ns;
   --constant clk_10Mhz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spiMaster PORT MAP (
          enable_spi => enable_spi,
          clk_50Mhz => clk_50Mhz,
          clk_10Mhz => clk_10Mhz,
          cs => cs,
          din => din,
          dout => dout,
          adc_data => adc_data,
          adc_data_tempo => adc_data_tempo,
          count => count,
			 state => state,
			 dout_i => dout_i
        );

   -- Clock process definitions
   clk_50Mhz_process :process
   begin
		clk_50Mhz <= '1';
		wait for clk_50Mhz_period/2;
		clk_50Mhz <= '0';
		wait for clk_50Mhz_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      wait for 1580 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		
		wait for 1580 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '1';
		
   end process;

END;
