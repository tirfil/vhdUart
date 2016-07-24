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

entity tb_UART8N1RX is
end tb_UART8N1RX;

architecture stimulus of tb_UART8N1RX is

-- COMPONENTS --
	component UART8N1RX
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SELX3		: in	std_logic;
			RX		: in	std_logic;
			DOK		: out	std_logic;
			DOUT		: out	std_logic_vector(7 downto 0)
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SELX3		: std_logic;
	signal RX		: std_logic;
	signal DOK		: std_logic;
	signal DOUT		: std_logic_vector(7 downto 0);
    signal c : integer range 0 to 7;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
	I_UART8N1RX_0 : UART8N1RX
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SELX3		=> SELX3,
			RX		=> RX,
			DOK		=> DOK,
			DOUT		=> DOUT
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
		nRST <= '0';
        RX <= '1';
		wait for 1000 ns;
		nRST <= '1';
        wait for 1600 ns;
        RX <= '0'; -- start
        wait for 501 ns;
        RX <= '1'; -- 0
        wait for 501 ns;
        RX <= '0';
        wait for 501 ns;
        RX <= '1';
        wait for 501 ns;
        RX <= '0';
        wait for 501 ns;
        RX <= '1';
        wait for 501 ns;
        RX <= '0';
        wait for 501 ns;
        RX <= '1';
        wait for 501 ns;
        RX <= '0'; -- 7
        wait for 501 ns;
        RX <= '1'; -- STOP
        wait for 1000 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
