# Source files (Package parsed first)
PKG_SRC       = rtl/common/rv32i_pkg.sv
RTL_SRCS      = $(filter-out $(PKG_SRC), $(wildcard rtl/common/*.sv)) rtl/single_cycle/core_single.sv
TB_SRCS       = $(wildcard tb/*.sv)
TESTS 		  = test1 test2
TEST          ?= test2 # Default test, allows override

VERILOG_FILES = $(PKG_SRC) $(RTL_SRCS) $(TB_SRCS)

# Outputs
SIM_DIR       = sim_build
SIM_OUT       = $(SIM_DIR)/sim.out
VCD_FILES     = $(TESTS:%=$(SIM_DIR)/%.vcd) # Substitution reference
#DUMP_VCD      = $(SIM_DIR)/directed_tb.vcd

.PHONY: all compile sim wave clean

all: compile sim

# Create sim directory if not already existing
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# Compile
$(SIM_OUT): $(VERILOG_FILES) | $(SIM_DIR)
	iverilog -g2012 -I rtl/common -o $(SIM_OUT) $(VERILOG_FILES)

compile: $(SIM_OUT)

# Simulate ; vvp is Icarus Verilog's runtime simulator (Verilog Virtual Processor)
$(SIM_DIR)/%.vcd: $(SIM_OUT) tb/%.hex | $(SIM_DIR)
	vvp $(SIM_OUT) +HEX=tb/$*.hex +VCD=$@
#$(DUMP_VCD): $(SIM_OUT)
#	cd $(SIM_DIR) && vvp ../$(SIM_OUT)

sim: $(VCD_FILES)

# Waveform viewing
wave: $(SIM_DIR)/$(TEST).vcd # Run make wave TEST=test1 to see test1 waveform
	gtkwave $< &

# Clean up
clean:
	rm -rf $(SIM_DIR)/*
