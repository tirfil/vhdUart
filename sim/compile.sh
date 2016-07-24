
ghdl_mcode -a ../vhdl/uart8n1rx.vhd
ghdl_mcode -a ../test/tb_uart8n1rx.vhd
ghdl_mcode -e tb_uart8n1rx
ghdl_mcode -r tb_uart8n1rx --vcd=toto.vcd 
