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
├── sim/                    # Simulation build outputs and waveforms
├── tb/                     # Testbenches and test vectors
├── .gitignore
└── README.md
```

## Roadmap
- [X] Baseline RTL Single-Core Processor Core
- [ ] Self-Checking Testbench (WIP)
- [ ] Run Simulation and Verification
- [ ] 5-Stage Pipelined Processor Core