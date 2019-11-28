

set FLAG=-v -PALL_LIB --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\uart8o1tx.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\test\tb_uart8o1tx.vhd
ghdl -e --work=WORK --workdir=ALL_LIB %FLAG% tb_uart8o1tx
ghdl -r --work=WORK --workdir=ALL_LIB %FLAG% tb_uart8o1tx --vcd=toto.vcd 
