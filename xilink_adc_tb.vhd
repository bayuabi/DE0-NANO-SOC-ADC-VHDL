LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY xilink_adc_tb IS
END xilink_adc_tb;
 
ARCHITECTURE behavior OF xilink_adc_tb IS 
	 COMPONENT spiMaster
    PORT(
         cs : OUT  std_logic;
         din : OUT  std_logic;
         dout : IN  std_logic;
         iClk : IN  std_logic;
         oClk : OUT  std_logic;
         adcData : OUT  std_logic_vector(11 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal dout : std_logic := '0';
   signal iClk : std_logic := '0';

   --Outputs
   signal cs : std_logic;
   signal din : std_logic;
   signal oClk : std_logic;
   signal adcData : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant iClk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spiMaster PORT MAP (
          cs => cs,
          din => din,
          dout => dout,
          iClk => iClk,
          oClk => oClk,
          adcData => adcData
        );

   -- Clock process definitions
   iClk_process :process
   begin
		iClk <= '1';
		wait for iClk_period/2;
		iClk <= '0';
		wait for iClk_period/2;
   end process;
	process
	begin
		wait for 1100 ns; dout <= '1';
		wait for 200 ns; dout <= '0'; 
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '0';
		wait for 200 ns; dout <= '1';
		wait for 200 ns; dout <= '1';
	end process;
END;
