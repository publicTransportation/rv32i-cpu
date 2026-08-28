# Source files (Package parsed first)
PKG_SRC       = rtl/common/rv32i_pkg.sv
RTL_SRCS      = $(filter-out $(PKG_SRC), $(wildcard rtl/common/*.sv)) rtl/single_cycle/core_single.sv
TB_SRCS       = $(wildcard tb/*.sv)

VERILOG_FILES = $(PKG_SRC) $(RTL_SRCS) $(TB_SRCS)

# Outputs
SIM_DIR       = sim
SIM_OUT       = $(SIM_DIR)/sim.out
DUMP_VCD      = $(SIM_DIR)/directed_tb.vcd

.PHONY: all compile sim wave clean

all: compile sim

# Create sim directory if not already existing
$(SIM_DIR):
	mkdir -p $(SIM_DIR)

# Compile
$(SIM_OUT): $(VERILOG_FILES) | $(SIM_DIR)
	iverilog -g2012 -I rtl/common -o $(SIM_OUT) $(VERILOG_FILES)

compile: $(SIM_OUT)

# Simulate
$(DUMP_VCD): $(SIM_OUT)
	cd $(SIM_DIR) && vvp ../$(SIM_OUT)

sim: $(DUMP_VCD)

# Waveform viewing
wave: $(DUMP_VCD)
	gtkwave $(DUMP_VCD) &

# Clean up
clean:
	rm -rf $(SIM_DIR)/*
	