
ghdl_mcode -a ../vhdl/uart8n1rx.vhd
ghdl_mcode -a ../vhdl/uart8n1tx.vhd
ghdl_mcode -a ../test/tb_uart8n1tx.vhd
ghdl_mcode -e tb_uart8n1tx
ghdl_mcode -r tb_uart8n1tx --wave=tx.ghw
