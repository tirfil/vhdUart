
ghdl_mcode -a ../vhdl/uart8n1rx.vhd
ghdl_mcode -a ../vhdl/uart8n1tx.vhd
ghdl_mcode -a ../vhdl/uart9600_8n1.vhd
ghdl_mcode -a ../demo/test_uart.vhd
ghdl_mcode -a ../demo/tb_test_uart.vhd
ghdl_mcode -e tb_test_uart
ghdl_mcode -r tb_test_uart --vcd=toto.vcd
