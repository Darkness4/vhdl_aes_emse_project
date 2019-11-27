#!/bin/bash

export PROJECTNAME=$(dirname $(realpath $0))

# TO DO : test $PROJECTNAME
echo "the project location is : $PROJECTNAME"
echo "removing libs : folder plus line declaration in Modelsim.ini file"
vdel -lib $PROJECTNAME/LIB/LIB_AES -all
vdel -lib $PROJECTNAME/LIB/LIB_RTL -all
vdel -lib $PROJECTNAME/LIB/LIB_BENCH -all

echo "creating VHDL LIBRARY"
vlib $PROJECTNAME/LIB/LIB_AES
vmap LIB_AES $PROJECTNAME/LIB/LIB_AES
vlib $PROJECTNAME/LIB/LIB_RTL
vmap LIB_RTL $PROJECTNAME/LIB/LIB_RTL
vlib $PROJECTNAME/LIB/LIB_BENCH
vmap LIB_BENCH $PROJECTNAME/LIB/LIB_BENCH

echo "compile third party library  : type definition package"
vcom -work LIB_AES $PROJECTNAME/SRC/THIRDPARTY/CryptPack.vhd

echo "compile vhdl sources"
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/sbox.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/subbytes.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/shiftrows.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/addroundkey.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/mixcolumns.vhd

echo "compile vhdl test bench"
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/subbytes_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/subbytes_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/shiftrows_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/shiftrows_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/addroundkey_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/addroundkey_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumns_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumns_tb_conf.vhd

echo "compilation finished"
# echo "start simulation..."
# vsim  LIB_BENCH.SBox_I_O_tb &



