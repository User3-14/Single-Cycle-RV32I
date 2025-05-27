# RV32I Single-Cycle Processor (VHDL)

This repository contains a single-cycle implementation of a RISC-V processor supporting the **RV32I base instruction set**, written in VHDL. It was developed as our Computer Architecture course's project at university.

The processor features a clean datapath design, custom control unit, and a built-in data memory controller to support a wide range of memory access instructions.

> 🧠 This project will serve as the base for a planned summer upgrade to a **5-stage pipelined RV64I** processor.

---

## 🏗️ Architecture Overview

- **Instruction Set Architecture (ISA):** RV32I (Base Integer)
- **Design Type:** Single-cycle
- **Data Width:** 32-bit
- **Register File:** 32 × 32-bit registers
- **Execution:** All instructions completed in a single clock cycle

---

## ✅ Supported Instructions

### Base Instructions
- `lw`, `sw`, `add`, `sub`, `and`, `or`, `xor`

### Additional Implemented Instructions
- **Immediate/ALU:** `addi`, `slli`, `sll`, `srl`, `sra`
- **Branch:** `beq`, `blt`, `bltu`, `bge`, `bgeu`, `jal`, `jalr`
- **Data Movement:** `lb`, `lbu`, `lh`, `lwu`, `sb`, `sh`
- **Pseudo:** `nop`

For a full list with opcodes and function codes, see [`Instructions.txt`](Instructions.txt).

---

## 📦 File Structure
/src # VHDL source files
/testbench # Simulation files
/docs # Diagrams and documentation
Instructions.txt
Processor Specifications.txt
Datapath.png
README.md


---

## 🧠 Data Memory Controller

To support byte and halfword load/store instructions (e.g., `lb`, `lh`, `lbu`, `sb`, `sh`), a custom **Data Memory Controller** was implemented within the memory module.

Key features:
- **Byte-addressable memory array** using 8-bit elements
- **Alignment masking** to ensure correctness for `sw/lw`, `sh/lh`, and `sb/lb`
- **Sign-extension & zero-extension** handling for `lb` and `lbu`
- **Offset-based access control** to simplify operation decoding
- Seamless integration into the single-cycle datapath

This design enhances instruction support while minimizing datapath complexity—allowing future upgrades to a pipelined architecture with fewer changes.

---

## 🔭 Future Work

This project is planned to evolve into a:
- **5-stage pipelined RV64I processor**
- Full instruction and hazard support
- Branch prediction unit
- Memory-mapped IO integration
- Synthesis on FPGA hardware

---

## 🧾 License

This project is for educational and academic purposes only.  
For collaboration or external use inquiries, please reach out via email.

