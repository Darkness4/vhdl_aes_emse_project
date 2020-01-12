# Makefile by Marc NGUYEN
# Project Name
TARGET?=$(shell basename $(CURDIR))

# Project structure
SRCDIR?=SRC
LIBDIR?=LIB

VCOM?=vcom
VLIB?=vlib
VMAP?=vmap

LIB_AES:=LIB_AES
LIB_RTL:=LIB_RTL
LIB_BENCH:=LIB_BENCH
LIBS:=$(LIBDIR)/$(LIB_AES) $(LIBDIR)/$(LIB_RTL) $(LIBDIR)/$(LIB_BENCH)

SOURCES_AES:=$(wildcard $(SRCDIR)/THIRDPARTY/*.vhd)
SOURCES_RTL:=$(wildcard $(SRCDIR)/RTL/*.vhd)
SOURCES_RTL_CONF:=$(wildcard $(SRCDIR)/RTL/*_conf.vhd)
SOURCES_RTL:=$(filter-out $(SOURCES_RTL_CONF),$(SOURCES_RTL))
SOURCES_TB:=$(wildcard $(SRCDIR)/BENCH/*_tb.vhd)
SOURCES_TB_CONF:=$(wildcard $(SRCDIR)/BENCH/*_tb_conf.vhd)
SOURCES:=$(SOURCES_AES) $(SOURCES_RTL) $(SOURCES_RTL_CONF) $(SOURCES_TB) $(SOURCES_TB_CONF)

OBJECTS_AES:=$(SOURCES_AES:$(SRCDIR)/THIRDPARTY/%.vhd=$(LIBDIR)/$(LIB_AES)/%/)
OBJECTS_RTL:=$(SOURCES_RTL:$(SRCDIR)/RTL/%.vhd=$(LIBDIR)/$(LIB_RTL)/%/)
SOURCES_RTL_CONF:=$(SOURCES_RTL_CONF:$(SRCDIR)/RTL/%.vhd=$(LIBDIR)/$(LIB_RTL)/%/)
OBJECTS_TB:=$(SOURCES_TB:$(SRCDIR)/BENCH/%.vhd=$(LIBDIR)/$(LIB_BENCH)/%/)
OBJECTS_TB_CONF:=$(SOURCES_TB_CONF:$(SRCDIR)/BENCH/%.vhd=$(LIBDIR)/$(LIB_BENCH)/%/)
OBJECTS:=$(OBJECTS_AES) $(OBJECTS_RTL) $(SOURCES_RTL_CONF) $(OBJECTS_TB) $(OBJECTS_TB_CONF)

# Cleaner
rm = rm -rf

.PHONY: build
build: $(LIBDIR)/$(LIB_RTL)/aes_conf/ test

.PHONY: test
test: $(OBJECTS_TB_CONF)

# -- Compile LIB_AES --
$(LIBDIR)/$(LIB_AES)/CryptPack/: $(SRCDIR)/THIRDPARTY/CryptPack.vhd $(LIBDIR)/$(LIB_AES)
	$(VCOM) -quiet -work $(LIB_AES) $<
	@echo "Compiled "$<" successfully!"

$(LIBDIR)/$(LIB_AES)/KeyExpansion_I_O_table/: $(SRCDIR)/THIRDPARTY/KeyExpansion_I_O_table.vhd $(LIBDIR)/$(LIB_AES)/CryptPack/ $(LIBDIR)/$(LIB_AES)
	$(VCOM) -quiet -work $(LIB_AES) $<
	@echo "Compiled "$<" successfully!"

# -- Compile LIB_RTL : depends on LIB_AES --
# Compile objects

$(OBJECTS_RTL): $(LIBDIR)/$(LIB_RTL)/%/: $(SRCDIR)/RTL/%.vhd $(LIBS) $(OBJECTS_AES)
	$(VCOM) -quiet -work $(LIB_RTL) $<
	@echo "Compiled "$<" successfully!"

$(LIBDIR)/$(LIB_RTL)/subbytes_conf/: $(SRCDIR)/RTL/subbytes_conf.vhd $(LIBDIR)/$(LIB_RTL)/subbytes/ $(LIBDIR)/$(LIB_RTL)/sbox/ $(LIBS) $(OBJECTS_AES)
	$(VCOM) -quiet -work $(LIB_RTL) $<
	@echo "Compiled "$<" successfully!"

$(LIBDIR)/$(LIB_RTL)/mixcolumns_conf/: $(SRCDIR)/RTL/mixcolumns_conf.vhd $(LIBDIR)/$(LIB_RTL)/mixcolumn/ $(LIBDIR)/$(LIB_RTL)/mixcolumns/ $(LIBS) $(OBJECTS_AES)
	$(VCOM) -quiet -work $(LIB_RTL) $<
	@echo "Compiled "$<" successfully!"

$(LIBDIR)/$(LIB_RTL)/round_conf/: $(SRCDIR)/RTL/round_conf.vhd $(LIBDIR)/$(LIB_RTL)/round/ $(LIBDIR)/$(LIB_RTL)/addroundkey/ $(LIBDIR)/$(LIB_RTL)/register_d/ $(LIBDIR)/$(LIB_RTL)/mixcolumns_conf/ $(LIBDIR)/$(LIB_RTL)/shiftrows/ $(LIBDIR)/$(LIB_RTL)/subbytes_conf/ $(LIBDIR)/$(LIB_RTL)/bit128_to_state/ $(LIBDIR)/$(LIB_RTL)/state_to_bit128/ $(LIBS) $(OBJECTS_AES)
	$(VCOM) -quiet -work $(LIB_RTL) $<
	@echo "Compiled "$<" successfully!"

$(LIBDIR)/$(LIB_RTL)/aes_conf/: $(SRCDIR)/RTL/aes_conf.vhd $(LIBDIR)/$(LIB_RTL)/aes/ $(LIBDIR)/$(LIB_RTL)/counter/ $(LIBDIR)/$(LIB_RTL)/fsm_aes/ $(LIBDIR)/$(LIB_RTL)/round_conf/ $(LIBS) $(OBJECTS_AES)
	$(VCOM) -quiet -work $(LIB_RTL) $<
	@echo "Compiled "$<" successfully!"

# -- Compile LIB_BENCH : depends on LIB_AES and LIB_RTL --
# Compile first
$(OBJECTS_TB): $(LIBDIR)/$(LIB_BENCH)/%/: $(SRCDIR)/BENCH/%.vhd $(LIBS) $(OBJECTS_AES) $(OBJECTS_RTL) $(OBJECTS_RTL_CONF)
	$(VCOM) -quiet -work $(LIB_BENCH) $<
	@echo "Compiled "$<" successfully!"
# Compile second
$(OBJECTS_TB_CONF): $(LIBDIR)/$(LIB_BENCH)/%/: $(SRCDIR)/BENCH/%.vhd $(OBJECTS_TB) $(LIBS) $(OBJECTS_AES) $(OBJECTS_RTL) $(OBJECTS_RTL_CONF)
	$(VCOM) -quiet -work $(LIB_BENCH) $<
	@echo "Compiled "$<" successfully!"

# -- Create libraries and map --
$(LIBS): $(LIBDIR)/%: %
	$(VLIB) $@
	$(VMAP) $< $@
	@echo "Library "$<" set successfully!"

$(LIB_AES) $(LIB_RTL) $(LIB_BENCH): ;

.PHONY: echoes
echoes:
	@echo "LIBS :"
	@echo "$(LIBS)"
	@echo "SOURCES :"
	@echo "$(SOURCES)"
	@echo "OBJECTS :"
	@echo "$(OBJECTS)"

.PHONY: clean
clean:
	vdel -lib ./$(LIBDIR)/$(LIB_AES) -all
	vdel -lib ./$(LIBDIR)/$(LIB_RTL) -all
	vdel -lib ./$(LIBDIR)/$(LIB_BENCH) -all
	@echo "Cleanup complete!"
