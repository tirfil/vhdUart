--###############################
--# Project Name : "low cost" uart
--# File         : uart9600_8n1.vhd
--# Author       : Philippe THIRION
--# Description  : uart 9600 bauds
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART9600_8N1 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		RX		: in	std_logic;
		TX		: out	std_logic;
		DOK		: out	std_logic;
		DOUT		: out	std_logic_vector(7 downto 0);
		DIN		: in	std_logic_vector(7 downto 0);
		LOAD		: in	std_logic;
        READY       : out std_logic
	);
end UART9600_8N1;

architecture struct of UART9600_8N1 is
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
	component UART8N1TX
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

    signal counter : std_logic_vector(10 downto 0);
    signal baud9600x3 : std_logic;
    signal SELX3		: std_logic;
begin
    -- MCLK is 48 MHz
    -- generate 9600 baud bit (104uS) 
    -- baud9600x3 is three time faster
    -- only this part must be adapted for other baud rate or other master clock frequency
    baud9600x3 <= counter(10) and counter(9) and counter(7) and counter(1);

	CNT: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            counter <= (others=>'0');
            SELX3 <= '0';
		elsif (MCLK'event and MCLK = '1') then
            if (baud9600x3 = '1') then
                counter <= (others=>'0');
                SELX3 <= '1';
            else
                counter <= std_logic_vector(unsigned(counter)+1);
                SELX3 <= '0';
            end if;
        end if;
	end process CNT;

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
	I_UART8N1TX_0 : UART8N1TX
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SELX3		=> SELX3,
			TX		=> TX,
			DIN		=> DIN,
			LOAD		=> LOAD,
			READY		=> READY
		);

end struct;

