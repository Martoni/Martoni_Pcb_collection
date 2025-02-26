## config.mk

COLOGNEDIR = /opt/gatemate/cc-toolchain-linux

## toolchain
YOSYS = $(COLOGNEDIR)/bin/yosys/yosys
PR    = $(COLOGNEDIR)/bin/p_r/p_r
OFL   = openFPGALoader

GTKW = gtkwave
IVL = iverilog
VVP = vvp
IVLFLAGS = -g2012 -gspecify -Ttyp

## simulation libraries
CELLS_SYNTH = $(COLOGNEDIR)/bin/yosys/share/gatemate/cells_sim.v
CELLS_IMPL = $(COLOGNEDIR)/bin/p_r/cpelib.v

## target sources
VLOG_SRC = $(shell find ./src/ -type f \( -iname \*.v -o -iname \*.sv \))
VHDL_SRC = $(shell find ./src/ -type f \( -iname \*.vhd -o -iname \*.vhdl \))

## misc tools
RM = rm -rf

## toolchain targets
synth: synth_vlog

synth_vlog: $(VLOG_SRC)
	$(YOSYS) -qql log/synth.log -p 'read_verilog $^; synth_gatemate -top $(TOP) -nomx8 -vlog net/$(TOP)_synth.v'

synth_vhdl: $(VHDL_SRC)
	$(YOSYS) -ql log/synth.log -p 'ghdl --warn-no-binding -C --ieee=synopsys $^ -e $(TOP); synth_gatemate -top $(TOP) -nomx8 -vlog net/$(TOP)_synth.v'

impl:
	$(PR) -i net/$(TOP)_synth.v -o $(TOP) $(PRFLAGS) > log/$@.log


jtag:
	$(OFL) $(OFLFLAGS) -b olimex_gatemateevb $(TOP)_00.cfg

### untested part
jtag-flash:
	$(OFL) $(OFLFLAGS) -b olimex_gatemateevb -f --verify $(TOP)_00.cfg

spi:
	$(OFL) $(OFLFLAGS) -b olimex_gatemateevb_spi -m $(TOP)_00.cfg

spi-flash:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_spi -f --verify $(TOP)_00.cfg
### untested part end

all: synth impl jtag

## verilog simulation targets
vlog_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ $(VLOG_SRC) sim/iverilog/$(TOP)_tb.v $(CELLS_SYNTH) $(CELLS_IMPL)

synth_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ net/$(TOP)_synth.v sim/iverilog/$(TOP)_tb.v $(CELLS_SYNTH) $(CELLS_IMPL)

impl_sim.vvp:
	$(IVL) $(IVLFLAGS) -o sim/iverilog/$@ $(TOP)_00.v sim/iverilog/$(TOP)_tb.v $(CELLS_IMPL)

.PHONY: %sim %sim.vvp
%sim: %sim.vvp
	$(VVP) -N sim/iverilog/$< -fst
	@$(RM) sim/$^

wave:
	$(GTKW) sim/iverilog/$(TOP)_tb.vcd sim/config.gtkw

clean:
	$(RM) log/*.log
	$(RM) net/*_synth.v
	$(RM) *.history
	$(RM) *.txt
	$(RM) *.refwire
	$(RM) *.refparam
	$(RM) *.refcomp
	$(RM) *.pos
	$(RM) *.pathes
	$(RM) *.path_struc
	$(RM) *.net
	$(RM) *.id
	$(RM) *.prn
	$(RM) *_00.v
	$(RM) *.used
	$(RM) *.sdf
	$(RM) *.place
	$(RM) *.pin
	$(RM) *.cfg*
	$(RM) *.cdf
	$(RM) sim/*.vcd
	$(RM) sim/*.vvp
	$(RM) sim/*.gtkw

