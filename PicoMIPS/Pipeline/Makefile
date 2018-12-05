GHDL := ghdl
WORKDIR := work
VERSION := 08

PACKAGES := pkgTypes.vhd pkgConstants.vhd # Manter essa ordem pq Constants usa types
TARGETS :=
TARGETS += add4.vhd MP.vhd mux2.vhd mux3.vhd               \
	register_bank.vhd PC.vhd RI.vhd sign_extend.vhd        \
	ULA.vhd ICache.vhd DCache.vhd ULA_control.vhd          \
	IC_control.vhd DC_control.vhd

TARGETS += $(wildcard stages/*.vhd)
TARGETS += $(wildcard pipes/*.vhd)

TARGETS += UC.vhd FD.vhd

TARGETS += $(wildcard testbenches/*.vhd)

DEBUG  := 1
VISUAL := 1

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
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

pc_test:
	$(GHDL) -r $(GHDLFLAGS) PC_tb --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

ri_test:
	$(GHDL) -r $(GHDLFLAGS) RI_tb --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

fd_test:
	$(GHDL) -r $(GHDLFLAGS) FD_tb --stop-time=3000ns --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

ula_test:
	$(GHDL) -r $(GHDLFLAGS) ULA_tb --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

icache_test:
	$(GHDL) -r $(GHDLFLAGS) ICache_tb --stop-time=3us --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

dcache_test:
	$(GHDL) -r $(GHDLFLAGS) DCache_tb --stop-time=4500ns --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

instruction_fetch_test:
	$(GHDL) -r $(GHDLFLAGS) instruction_fetch_tb --stop-time=3us --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

instruction_decode_test:
	$(GHDL) -r $(GHDLFLAGS) instruction_decode_tb --stop-time=400ns --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

uc_test:
	$(GHDL) -r $(GHDLFLAGS) UC_tb --stop-time=3us --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

full_test:
	$(GHDL) -r $(GHDLFLAGS) full_tb --stop-time=8us --vcd=$(WORKDIR)/$@.vcd
ifeq ($(VISUAL), 1)
	gtkwave $(WORKDIR)/$@.vcd
endif

check_syntax: | $(WORKDIR)
	$(GHDL) -s $(GHDLFLAGS) $(PACKAGES) $(TARGETS)

clean:
	rm -rf $(WORKDIR)

$(WORKDIR):
	mkdir -p $(WORKDIR)

.PHONY: all analyse check_syntax clean
