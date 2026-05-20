# FPGA Projects

Verilog designs built on a Basys 3 Artix-7 board over Summer 2026. Starts with a
blinking LED and ends with a working CPU core.

## Projects

### LED Blinker
A 27-bit counter runs at 100 million ticks per second. Bit 26 flips roughly once
per second, toggling an LED. The chip is not running code - it is the counter
circuit. Every clock tick, the hardware adds 1 across thousands of logic blocks
in parallel.

### 4-Bit Adder
Eight switches feed two 4-bit numbers into a combinational adder. The 5-bit sum
appears on the LEDs instantly. No clock, no state, no delay. Flip a switch and
the output updates. Same fundamental circuit that lives inside every ALU in every
processor ever built.

### 7-Segment Display Counter
A 27-bit divider counts to 134 million before resetting, producing a 1Hz tick.
Each tick increments a 4-bit digit from 0 to 9. A decoder converts that digit
into 7 cathode signals that light the correct segments. All of it runs in
hardware at once, not line by line.

### Button Debouncer
A mechanical button press looks like 20-30 rapid toggles to an FPGA. This circuit
filters that noise with a shift register and majority logic, producing one clean
edge per press. Every real project that uses buttons needs this.

### Traffic Light FSM
Four states: red, green, yellow, red. Each state drives a different LED pattern.
A pedestrian button forces an immediate jump to red. Same design pattern used in
real traffic controllers, elevator logic, and serial protocols.

### UART Transmitter
Transmits one bit at a time at a fixed baud rate: start bit, 8 data bits, stop
bit. A PC terminal receives the signal over USB and displays ASCII characters.
The timing of each bit is controlled by a clock divider. This is how hardware
has talked to computers for decades.

### ALU
Two 4-bit operands go in, one result comes out, based on the selected operation:
add, subtract, AND, OR, XOR, or shift. Scale this to 64 bits with pipelining
and forwarding and you have the execution unit of a modern processor.

### VGA Signal Generator
Two counters track horizontal and vertical position across a 640x480 grid.
Sync pulses fire at precise intervals to tell the monitor when each row and
frame starts. Color data goes onto the RGB lines during the active window.
The monitor sees a valid VGA signal and has no idea it is talking to an FPGA.

### Capstone - RISC-V CPU Core
Fetches 32-bit instructions from memory, decodes the opcode, executes in the
ALU, writes results back to a register file. The program counter steps forward
each cycle. Branch instructions redirect it. Load and store instructions move
data between registers and memory. Every stage is hardware described in Verilog,
running on the same chip as the LED blinker from week one.

## Tools
- Vivado ML Standard Edition 2025.2
- Basys 3 AMD Artix-7 FPGA Development Board
- Verilog HDL

## About
Independent hardware design project, Summer 2026. Built to develop practical RTL design skills.
