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

entity tb_UART8O1TX is
end tb_UART8O1TX;

architecture stimulus of tb_UART8O1TX is

-- COMPONENTS --
	component UART8O1TX
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SELX3		: in	std_logic;
			TX		: out	std_logic;
			DIN		: in	std_logic_vector(7 downto 0);
			LOAD		: in	std_logic;
			READY		: out	std_logic
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SELX3		: std_logic;
	signal TX		: std_logic;
	signal DIN		: std_logic_vector(7 downto 0);
	signal LOAD		: std_logic;
	signal READY		: std_logic;

    signal c : integer range 0 to 7;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_UART8O1TX_0 : UART8O1TX
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SELX3		=> SELX3,
			TX		=> TX,
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

    TTT: process(MCLK,nRST)
    begin
        if (nRST='0') then
            SELX3 <= '0';
            c <= 0;
        elsif(MCLK'event and MCLK='1') then
            if (c=7) then
                c <= 0;
                SELX3 <= '1';
            else
                c <= c + 1;
                SELX3 <= '0';
            end if;
        end if;
    end process TTT;

	GO: process
	begin
		wait for 1 ns;
        LOAD <= '0';
        DIN <= X"5A";
        nRST <= '0';
		wait for 1000 ns;
		nRST <= '1';
        wait for 1000 ns;
        LOAD <= '1';
        wait for 20 ns;
        LOAD <= '0';
        wait for 20 ns;
        DIN <= X"BA";
        wait until READY='1';
        wait until MCLK'event and MCLK='1';
        wait for 1 ns;
        LOAD <= '1';
        wait for 20 ns;
        LOAD <= '0';
        wait for 20 ns;
        wait until READY='1';
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
