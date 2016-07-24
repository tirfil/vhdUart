
ghdl_mcode -a ../vhdl/uart8n1rx.vhd
ghdl_mcode -a ../vhdl/uart8n1tx.vhd
ghdl_mcode -a ../vhdl/uart9600_8n1.vhd
ghdl_mcode -a ../test/tb_uart8n1.vhd
ghdl_mcode -e tb_uart8n1
ghdl_mcode -r tb_uart8n1 --wave=all.ghw
