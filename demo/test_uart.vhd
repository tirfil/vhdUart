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

entity TEST_UART is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		RX		    : in	std_logic;
		TX		    : out	std_logic
	);
end TEST_UART;

architecture mixed of TEST_UART is
-- COMPONENTS --
	component UART9600_8N1
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			RX		: in	std_logic;
			TX		: out	std_logic;
			DOK		: out	std_logic;
			DOUT		: out	std_logic_vector(7 downto 0);
			DIN		: in	std_logic_vector(7 downto 0);
			LOAD		: in	std_logic;
			READY		: out	std_logic
		);
	end component;

    signal reg   :  std_logic_vector(7 downto 0);
    signal flag  : std_logic;
	signal DOK		: std_logic;
	signal DOUT		: std_logic_vector(7 downto 0);
	signal DIN		: std_logic_vector(7 downto 0);
	signal LOAD		: std_logic;
	signal READY	: std_logic;

begin
-- PORT MAP --
	I_UART9600_8N1_0 : UART9600_8N1
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


	LB: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            flag <= '0';
            reg <= (others=>'0');
            LOAD <= '0';
            DIN <= (others=>'0');
		elsif (MCLK'event and MCLK = '1') then
            if (DOK = '1') then
                reg <= DOUT;
                flag <= '1';
            elsif (READY = '1' and flag = '1') then
                flag <= '0';
                DIN <= reg xor "00000001";
                LOAD <= '1';
            else
                LOAD <= '0';
            end if;
        end if;     
	end process LB;

end mixed;

