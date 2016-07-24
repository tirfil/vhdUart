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

entity tb_UART8N1 is
end tb_UART8N1;

architecture stimulus of tb_UART8N1 is

-- COMPONENTS --
	component UART9600_8N1
		port(
			MCLK	: in	std_logic;
			nRST	: in	std_logic;
			RX		: in	std_logic;
			TX		: out	std_logic;
			DOK		: out	std_logic;
			DOUT	: out	std_logic_vector(7 downto 0);
			DIN		: in	std_logic_vector(7 downto 0);
			LOAD	: in	std_logic;
			READY	: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal RX		: std_logic;
	signal TX		: std_logic;
	signal DOK		: std_logic;
	signal DOUT		: std_logic_vector(7 downto 0);
	signal DIN		: std_logic_vector(7 downto 0);
	signal LOAD		: std_logic;
	signal READY	: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_UART8N1_0 : UART9600_8N1
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			RX		=> RX,
			TX		=> TX,
			DOK		=> DOK,
			DOUT		=> DOUT,
			DIN		=> DIN,
			LOAD		=> LOAD,
			READY		=> READY
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

    RX <= TX;

	GO: process
	begin
		wait for 1 ns;
        nRST <= '0';
        DIN <= X"AA";
        LOAD <= '0';
		wait for 1000 ns;
		nRST <= '1';
        wait for 1000 ns;
        LOAD <= '1';
        wait for 20 ns;
        LOAD <= '0';
        wait for 1500 us;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
