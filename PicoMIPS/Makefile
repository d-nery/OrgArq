##
GHDL := ghdl
WORKDIR := work
VERSION := 08

PACKAGES := pkgConstants.vhd
TARGETS := $(filter-out $(PACKAGES), $(wildcard *.vhd) $(wildcard */*.vhd))

DEBUG := 1

GHDLFLAGS := --std=$(VERSION) --workdir=$(WORKDIR)

ifeq ($(DEBUG), 1)
GHDLFLAGS += -v
endif

analyse: | $(WORKDIR)
	$(GHDL) -i $(GHDLFLAGS) $(PACKAGES) $(TARGETS)
	$(GHDL) -a $(GHDLFLAGS) $(PACKAGES)
	$(GHDL) -a $(GHDLFLAGS) $(TARGETS)
	@echo

all_tests: mp_test pc_test

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

check_syntax: | $(WORKDIR)
	$(GHDL) -s $(GHDLFLAGS) $(PACKAGES) $(TARGETS)

clean:
	rm -rf $(WORKDIR)

$(WORKDIR):
	mkdir -p $(WORKDIR)

.PHONY: all analyse check_syntax clean
