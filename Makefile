GHDL=ghdl
GHDLFLAGS=
MODULES=\
    SRC/THIRDPARTY/CryptPack.o \
    SRC/BENCH/sbox_tb.o \
    SRC/RTL/sbox.o \
    SRC/BENCH/sbox_tb_conf


test: $(MODULES)
	./sbox_tb_conf --vcd=sbox_tb_conf.vcd

# Binary depends on the object file
%: %.o
	$(GHDL) -e $(GHDLFLAGS) $@

SRC/THIRDPARTY/CryptPack.o: SRC/THIRDPARTY/CryptPack.vhd
	$(GHDL) --work=lib_aes --workdir=SRC/THIRDPARTY $<

clean:
	echo "Cleaning up..."
	rm -f *.o *_testbench full_adder carry_ripple_adder work*.cf e*.lst