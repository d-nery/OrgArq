##
GHDL := ghdl
WORKDIR := work
VERSION := 08

PACKAGES := pkgTypes.vhd pkgConstants.vhd # Manter essa ordem pq Constants usa types
TARGETS  := add4.vhd MP.vhd mux2.vhd mux3.vhd register_bank.vhd PC.vhd RI.vhd sign_extend.vhd ULA.vhd ICache.vhd DCache.vhd UC.vhd FD.vhd

TARGETS += $(wildcard */*.vhd)

DEBUG := 1

GHDLFLAGS := --std=$(VERSION) --workdir=$(WORKDIR)

ifeq ($(DEBUG), 1)
GHDLFLAGS += -v
endif

analyse: | $(WORKDIR)
	$(GHDL) -i $(GHDLFLAGS) $(PACKAGES) $(TARGETS)
	$(GHDL) -a $(GHDLFLAGS) $(PACKAGES)
	$(GHDL) -a $(GHDLFLAGS) $(TARGETS)

all_tests: mp_test pc_test ri_test ula_test instructions_test

mp_test:
	$(GHDL) -r $(GHDLFLAGS) MP_tb --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

pc_test:
	$(GHDL) -r $(GHDLFLAGS) PC_tb --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

ri_test:
	$(GHDL) -r $(GHDLFLAGS) RI_tb --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

ula_test:
	$(GHDL) -r $(GHDLFLAGS) ULA_tb --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

icache_test:
	$(GHDL) -r $(GHDLFLAGS) ICache_tb --stop-time=4700ns --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

dcache_test:
	$(GHDL) -r $(GHDLFLAGS) DCache_tb --stop-time=8us --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

instructions_test:
	$(GHDL) -r $(GHDLFLAGS) instruction_fetch_tb --stop-time=7us --vcd=$(WORKDIR)/$@.vcd
	gtkwave $(WORKDIR)/$@.vcd

check_syntax: | $(WORKDIR)
	$(GHDL) -s $(GHDLFLAGS) $(PACKAGES) $(TARGETS)

clean:
	rm -rf $(WORKDIR)

$(WORKDIR):
	mkdir -p $(WORKDIR)

.PHONY: all analyse check_syntax clean
