# Verilog FSM-Based Switch Debouncing Circuit

A complete Verilog HDL implementation and testbench of an FSM-based digital switch debouncing circuit. Mechanical switches and pushbuttons suffer from contact bounce, creating erratic voltage glitches upon opening or closing. This module uses a parameterized timer combined with an 8-state Mealy/Moore Finite State Machine (FSM) to sample inputs and filter out high-frequency mechanical contact noise, outputting a clean, debounced digital signal.

---

## System Architecture & State Machine Logic

```
               +------------------------------------------------------+
               |                  Debouncing_Circuit                  |
               |                                                      |
 [CLK] ------->| [Modulo-N Counter] ---> m_tic                        |
 [RST] --------+-----> [FSM Control Logic] <--- SW                     |
               |             |                                        |
               |             +--------------------------------------> db
               +------------------------------------------------------+
```

### Module Components
1. **Ticker Counter (`m_tic`)**: A modulo-N timer regulated by the parameter `tic`. Generates periodic single-cycle sampling pulses (`m_tic`) to strobe switch state stability.
2. **FSM Controller**: An 8-state state machine requiring the input state to remain consistently `HIGH` or `LOW` across 3 consecutive sampling intervals before transitioning the debounced output (`db`).

### FSM State Definitions

| State | Encoding | `db` Output | Description |
| :--- | :--- | :--- | :--- |
| `Zero` | `3'b000` | `0` | Stable logic low state. |
| `Wait_1_1` | `3'b010` | `0` | First stability check phase for high transition. |
| `Wait_1_2` | `3'b011` | `0` | Second stability check phase for high transition. |
| `Wait_1_3` | `3'b100` | `0` | Third stability check phase for high transition. |
| `One` | `3'b001` | `1` | Stable logic high state. |
| `Wait_0_1` | `3'b101` | `1` | First stability check phase for low transition. |
| `Wait_0_2` | `3'b110` | `1` | Second stability check phase for low transition. |
| `Wait_0_3` | `3'b111` | `1` | Third stability check phase for low transition. |

---

## Directory Structure

```text
.
├── rtl/
│   └── Debouncing_Circuit.v    # Top debouncer module with FSM logic
├── tb/
│   └── Debouncing_Circuit_TB.v # Simulation testbench with noise injection
├── docs/
│   └── Waveform.png            # ModelSim simulation waveform capture
└── README.md                   # Documentation
```

---

## Interface Specifications (`Debouncing_Circuit.v`)

### Parameters
* `tic` (Default: `10`): Clock cycles required to trigger each sampling tick `m_tic`. Adjust based on the operating system clock frequency to achieve standard 10ms–20ms debouncing windows.

### Ports

| Signal | Type | Width | Description |
| :--- | :--- | :--- | :--- |
| `CLK` | Input | `1` | System Clock input |
| `RST` | Input | `1` | Asynchronous active-low reset |
| `SW` | Input | `1` | Raw/noisy mechanical switch input |
| `db` | Output | `1` | Clean, debounced output signal |

---

## Testbench & Waveform Verification

The provided testbench (`Debouncing_Circuit_TB.v`) simulates real-world switch chatter by driving noisy pulses on `SW_tb`:
* **Glitch Rejection**: Rapid switch toggles shorter than $3 	imes 	ext{tic}$ cycles fail to move the state machine to `One` or `Zero`, preventing false triggers.
* **Stable Assertion**: Once `SW` stabilizes high for 3 consecutive `m_tic` ticks, `db` smoothly transitions to `1'b1`.
* **VCD Waveform Output**: Generates `debouncing circuit.vcd` for analysis in GTKWave or ModelSim.

---

## Getting Started & Simulation Guide

### Running with ModelSim / EDA Playground
1. **Compile RTL and Testbench**:
   ```bash
   vlib work
   vlog rtl/Debouncing_Circuit.v tb/Debouncing_Circuit_TB.v
   ```
2. **Start Simulation**:
   ```bash
   vsim -c Debouncing_Circuit_TB -do "run -all; quit"
   ```
3. **Inspect Waveforms**: Open the generated `debouncing circuit.vcd` waveform file to verify glitch suppression and `db` assertion timing.
