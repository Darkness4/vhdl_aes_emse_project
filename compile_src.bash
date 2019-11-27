#!/bin/bash

export PROJECTNAME="."

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


echo "compile vhdl test bench"
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb_conf.vhd

echo "compilation finished"
echo "start simulation..."
# vsim  LIB_BENCH.SBox_I_O_tb &



