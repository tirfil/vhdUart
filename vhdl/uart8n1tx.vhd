--###############################
--# Project Name : "low cost" uart
--# File         : uart8n1tx.vhd
--# Author       : Philippe THIRION
--# Description  : uart transmit part
--# Modification History
--# LSB first !
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART8N1TX is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SELX3		: in	std_logic;
		TX		: out	std_logic;
		DIN		: in	std_logic_vector(7 downto 0);
		LOAD		: in	std_logic;
		READY		: out	std_logic
	);
end UART8N1TX;

architecture rtl of UART8N1TX is
    type t_state is (S_IDLE,S_START0,S_START,S_BIT, S_STOP, S_STOP1);
    signal state : t_state;
    signal counter : integer range 0 to 2;
    signal bitcnt : integer range 0 to 7;
    signal shift : std_logic_vector(7 downto 0);
    signal change : std_logic;
begin

    change <= '1' when ((counter = 1) and (SELX3='1')) else '0';
    
    -- counter div 3 + synchro on load
	CCC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            counter <= 0;
		elsif (MCLK'event and MCLK = '1') then
            if (LOAD='1') then 
                counter <= 0;
            elsif (SELX3='1') then
                if (counter = 2) then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
	end process CCC;

    SOUT: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            TX <= '1';
            state <= S_IDLE;
            READY <= '1';
            shift <= (others=>'0');
        elsif (MCLK'event and MCLK = '1') then
            if (state = S_IDLE) then
                if (LOAD = '1') then
                    shift <= DIN;
                    state <= S_START0;
                    READY <= '0';
                else
                    READY <= '1';
                end if;
            elsif (state = S_START0) then
                state <= S_START;
            elsif (state = S_START) then
                if (change = '1') then 
                    TX <= '0'; -- start bit
                    bitcnt <= 0;
                    state <= S_BIT;
                end if;
            elsif (state = S_BIT) then
                if (change = '1') then 
                    TX <= shift(0);
                    if (bitcnt = 7) then
                        state <= S_STOP;
                    else
                        shift(6 downto 0) <= shift(7 downto 1);
                        bitcnt <= bitcnt + 1;
                    end if;
                end if;
             elsif ( state = S_STOP ) then
                if (change = '1') then
                    TX <= '1';
                    state <= S_STOP1;
                end if;
             elsif ( state = S_STOP1 ) then
                if (change = '1') then
                    TX <= '1';
                    state <= S_IDLE;
                    READY <= '1';
                end if;
            end if;
        end if;
    end process SOUT;
end rtl;

