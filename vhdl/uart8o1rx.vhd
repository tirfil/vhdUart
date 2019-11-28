--###############################
--# Project Name : "low cost" uart
--# File         : uart8o1rx.vhd
--# Author       : Philippe THIRION
--# Description  : uart reception part
--# Modification History
--# LSB first
--# add parity
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART8O1RX is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SELX3		: in	std_logic;
		RX		    : in	std_logic;
		DOK		    : out	std_logic;
		DOUT		: out	std_logic_vector(7 downto 0);
		PERR		: out	std_logic
	);
end UART8O1RX;

architecture rtl of UART8O1RX is
    type t_state is (S_WAIT_START,S_START, S_ERROR, S_SAMPLE, S_STOP, S_PARITY);
    signal counter : integer range 0 to 2;
    signal state : t_state;
    signal change : std_logic;
    signal sample : std_logic;
    signal falling : std_logic;
    signal rising : std_logic;
    signal rx_q, rx_qq, rx_qqq : std_logic;
    signal data : std_logic_vector(8 downto 0);
    signal parity : std_logic;
    signal perror : std_logic;
begin
    -- resynchronize input
	RESYNC: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            rx_q <= '1';
            rx_qq <= '1';
            rx_qqq <= '1';
		elsif (MCLK'event and MCLK = '1') then
            rx_q <= rx;
            rx_qq <= rx_q;
            rx_qqq <= rx_qq;
        end if;
	end process RESYNC;

    -- edge detection
    rising <= not(rx_qqq) and rx_qq;
    falling <= rx_qqq and not(rx_qq);
    change <= rising or falling;

    -- input sampling
    sample <= '1' when ((counter = 1) and (SELX3 = '1')) else '0';

    -- counter div 3 + resynchro after change
    CCNT: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            counter <= 0;
        elsif (MCLK'event and MCLK = '1') then
            if (change = '1') then
                counter <= 0;
            elsif (SELX3 = '1') then
                if (counter = 2) then
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process CCNT;

    OTO: process(MCLK, nRST)
	begin
		if (nRST = '0') then
            state <= S_WAIT_START;
            DOK <= '0';
            data <= (others=>'0');
            parity <= '0';
            perror <= '0';
        elsif (MCLK'event and MCLK = '1') then
            if (state = S_WAIT_START) then
                if (falling = '1') then
                    state <= S_START;
                    parity <= '1'; -- odd parity
                    -- parity <= '0'; -- even parity
                    perror <= '0';
                end if;
            elsif (state = S_START) then
                if (sample = '1') then
                    if (rx_qqq = '0') then
                        state <= S_SAMPLE;
                        data <= (8=>'1',others=>'0');
                    else
                        state <= S_ERROR;
                    end if;
                end if;
            elsif (state = S_SAMPLE) then
                if (sample = '1') then
                    if (data(0)='1') then
						if (rx_qqq = parity) then
							perror <= '0';
						else
							perror <= '1';
						end if;
						state <= S_PARITY;
                    else
                        DOK <= '0';
                        data(7 downto 0) <= data(8 downto 1);
                        data(8) <= rx_qqq;
                        if (rx_qqq = '1') then
							parity <= not parity;
						end if;					
					end if;
				end if;
			elsif (state = S_PARITY) then
                if (sample = '1') then    
					-- end of reception
					if (rx_qqq = '1') then
						state <= S_STOP;
						DOK <= '1';
					else
						state <= S_ERROR;
						DOK <= '0';
					end if;
                end if;
            elsif (state = S_STOP) then
                DOK <= '0';
                perror <= '0';
                parity <= '0';
                state <= S_WAIT_START;
            elsif (state = S_ERROR) then
                DOK <= '0';
                perror <= '0';
                parity <= '0';
                state <= S_WAIT_START;
            end if;
        end if;
    end process OTO;   

    DOUT <= data(8 downto 1);
    
    PERR <= perror;

end rtl;

