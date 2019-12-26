#!/bin/bash

export PROJECTNAME='.'

# TO DO : test $PROJECTNAME
mkdir -p $PROJECTNAME/LIB/LIB_AES
mkdir -p $PROJECTNAME/LIB/LIB_RTL
mkdir -p $PROJECTNAME/LIB/LIB_BENCH

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
vcom -work LIB_AES $PROJECTNAME/SRC/THIRDPARTY/KeyExpansion_I_O_table.vhd

echo "compile vhdl sources"
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/sbox.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/subbytes.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/subbytes_conf.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/shiftrows.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/addroundkey.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/mixcolumn.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/mixcolumns.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/mixcolumns_conf.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/register_d.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/bit128_to_state.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/state_to_bit128.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/round.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/round_conf.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/counter.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/fsm_aes.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/aes.vhd
vcom -work LIB_RTL $PROJECTNAME/SRC/RTL/aes_conf.vhd

echo "compile vhdl test bench"
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/sbox_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/subbytes_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/subbytes_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/shiftrows_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/shiftrows_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/addroundkey_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/addroundkey_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumn_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumn_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumns_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/mixcolumns_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/register_d_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/register_d_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/bit128_to_state_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/bit128_to_state_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/state_to_bit128_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/state_to_bit128_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/round_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/round_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/counter_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/counter_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/fsm_aes_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/fsm_aes_tb_conf.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/aes_tb.vhd
vcom -work LIB_BENCH $PROJECTNAME/SRC/BENCH/aes_tb_conf.vhd
echo "compilation finished"
