# RV32I Processor

A SystemVerilog implementation of a 32-bit RISC-V (RV32I subset) processor core based on the microarchitecture in Patterson & Hennessy's *Computer Organization and Design (RISC-V Edition)*.

## Features
- **Architecture:** 32-bit single-cycle datapath ($\text{CPI} = 1$)
- **Register File:** 32 general-purpose registers (`x0` hardwired to zero)
- **Control:** 2-level decoding (Main Control Unit + ALU Decoder)
- **Supported Instructions:**
  - **R-Type:** `add`, `sub`, `and`, `or`, `slt`
  - **I-Type:** `lw`
  - **S-Type:** `sw`
  - **B-Type:** `beq`

## Project Structure

```text
├── docs/                   # Documentation and reference materials
├── rtl/
│   ├── common/             # Shared architectural blocks & definitions
│   │   ├── alu_control.sv
│   │   ├── alu.sv
│   │   ├── control_unit.sv
│   │   ├── dmem.sv
│   │   ├── imem.sv
│   │   ├── imm_gen.sv
│   │   ├── reg_file.sv
│   │   └── rv32i_pkg.sv
│   ├── pipelined/          # 5-stage pipelined implementation (WIP)
│   └── single_cycle/       # Single-cycle CPU core
│       └── core_single.sv  # Top level wrapper for DUT
├── sim_build/                    # Simulation build outputs and waveforms
├── tb/                     
│   ├── directed_tb.sv      # Self-checking directed testbench
│   ├── dmem.sv             # Dual-port data memory behavioral model
│   ├── imem.sv             # ROM instruction memory
│   ├── test.s              # Directed RISC-V assembly source
│   ├── test.hex 
├── .gitignore
├── Makefile
└── README.md
```

## Verification & Simulation

The test environment uses **Icarus Verilog (`iverilog`)** for simulation and **GTKWave** for waveform analysis. A self-checking directed testbench (`directed_tb.sv`) monitors retired instructions and executes an automated end-of-test scoreboard check against golden architectural state.

### Dependencies
- `iverilog` (v10.3+)
- `vvp`
- `gtkwave`

### Quickstart

```bash
# Clone the repository
git clone https://github.com/publicTransportation/rv32i-cpu.git
cd rv32i-cpu

# Compile and run simulation
make sim

# Open waveform traces in GTKWave
make wave

# Clean build artifacts
make clean
```

## Roadmap
- [X] Baseline RTL Single-Core Processor Core
- [X] Self-Checking Directed Testbench (Hardcoded Golden Reference)
- [X] Run Simulation and Verification
- [ ] 5-Stage Pipelined Processor Core
- [ ] Constrained-Random Testbench
- [ ] Co-Simulation Behavioral Golden Reference


## Author

- **Andrew Liu** – [GitHub](https://github.com/publicTransportation) · [aliu4517@terpmail.umd.edu](mailto:aliu4517@terpmail.umd.edu)