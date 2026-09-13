# RV32I Processor

A SystemVerilog design of a 32-bit RISC-V (RV32I subset) processor core based on the microarchitecture in Patterson & Hennessy's *Computer Organization and Design (RISC-V Edition)* expanded to cover 37 RV32I instructions.

## Features
- **Architecture:** 32-bit single-cycle datapath ($\text{CPI} = 1$)
- **Register File:** 32 general-purpose registers (`x0` hardwired to zero)
- **Control:** 2-level decoding (Main Control Unit + ALU Decoder)
- **Supported Instructions:**
  - 37 RV32I instructions (all 40 RV32I base integer instructions **EXCEPT** for `ECALL`, `EBREAK`, `FENCE`)
    - **R-type:** `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
    - **I-type:** `addi`, `slti`, `sltiu`, `xori`, `ori`, `andi`, `slli`, `srli`, `srai`, `lb`, `lh`, `lw`, `lbu`, `lhu`, `jalr`
    - **S-type:** `sb`, `sh`, `sw`
    - **B-type:** `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`
    - **U-type:** `lui`, `auipc`
    - **J-type:** `jal`

## Project Structure

```text
├── rtl/
│   ├── common/            # Shared architectural blocks & definitions
│   │   ├── alu_control.sv
│   │   ├── alu.sv
│   │   ├── branch_comparator.sv
│   │   ├── control_unit.sv
│   │   ├── imm_gen.sv
│   │   ├── load_formatter.sv
│   │   ├── reg_file.sv
│   │   ├── rv32i_pkg.sv
│   │   └── store_gen.sv
│   ├── pipelined/        # 5-stage pipelined implementation (WIP)
│   └── single_cycle/     # Single-cycle CPU core
│       └── core_single.sv # Top-level wrapper for DUT
├── sim_build/             # Simulation build outputs and waveforms
├── tb/                   
│   ├── cpu_sva.sv         # SystemVerilog assertions (SVA) ; Turned off
│   ├── directed_tb.sv     # Self-checking directed testbench (shared by test1 and test2)
│   ├── dmem.sv            # Behavioral dual-port data memory model
│   ├── imem.sv            # Instruction ROM memory model
│   ├── test1.hex          # Assembled hex image for Test 1
│   ├── test1.s            # Assembly source for Test 1
│   ├── test2.hex          # Assembled hex image for Test 2
│   └── test2.s            # Assembly source for Test 2
├── .gitignore
├── Makefile
└── README.md
```

## Verification & Simulation

The test environment uses **Icarus Verilog (`iverilog`)** for simulation and **GTKWave** for waveform analysis. A self-checking testbench (`directed_tb.sv`) runs two directed tests (`test1.hex` and `test2.hex`) sequentially, monitors retired instructions, and executes an automated end-of-test scoreboard check against a shared golden architectural state.

## Known Limitations & Next Steps

- **Directed Testing Scope:** Verify functional baseline sanity but lack corner-case stress coverage. 
- **SVA Toolchain Constraints** SystemVerilog Assertions (`cpu_sva.sv`) are implemented for formal property checks and core invariants, but are currently disabled due to limited native SVA support in Icarus Verilog (`iverilog`).
- **Constrained-Random Verification:** Future work includes integrating constrained-random instruction generation and an instruction set simulator (ISS) co-simulation environment to expand edge-case coverage.

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
make

# Open waveform trace (default = test2) in GTKWave
make wave

# Open waveform trace for test1 in GTKWave
make wave TEST=test1 

# Clean build artifacts
make clean
```

## Roadmap
- [X] Baseline RTL Single-Core Processor Core
- [X] Self-Checking Directed Testbench (Hardcoded Golden Reference)
- [X] Run Simulation and Verification
- [X] Expanded Support for 37 RV32I Instructions
- [ ] Exception Handling
- [ ] 5-Stage Pipelined Processor Core
- [ ] Constrained-Random Testbench
- [ ] Co-Simulation Behavioral Golden Reference


## Author

- **Andrew Liu** – [GitHub](https://github.com/publicTransportation) · [aliu4517@terpmail.umd.edu](mailto:aliu4517@terpmail.umd.edu)