--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_TEST_UART is
end tb_TEST_UART;

architecture stimulus of tb_TEST_UART is

-- COMPONENTS --
	component TEST_UART
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			RX		: in	std_logic;
			TX		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal RX		: std_logic;
	signal TX		: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_TEST_UART_0 : TEST_UART
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			RX		=> RX,
			TX		=> TX
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 11 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
	begin
		wait for 1 ns;
        nRST <= '0';
        RX <= '1';
		wait for 1000 ns;
		nRST <= '1';
        wait for 100 us;
        RX <= '0';
        wait for 104 us;
        RX <= '0';
        wait for 104 us;
        RX <= '0';
        wait for 104 us;
        RX <= '1';
        wait for 104 us;
        RX <= '0';
        wait for 104 us;
        RX <= '1';
        wait for 104 us;
        RX <= '0';
        wait for 104 us;
        RX <= '1';
        wait for 104 us;
        RX <= '0';
        wait for 104 us;
        RX <= '1';
        wait for 2080 us;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
