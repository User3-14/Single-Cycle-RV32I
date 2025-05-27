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

