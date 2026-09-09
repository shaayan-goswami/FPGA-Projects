# FPGA Projects

Verilog on a Basys 3 board, summer 2026. Started with a blinking LED, ended
with a CPU that runs real instructions.

## Projects

### LED Blinker
27-bit counter, 100 million ticks a second, bit 26 flips about once a second
and toggles an LED. First thing I flashed - the "hello world" of FPGAs.

### 4-Bit Adder
Two 4-bit numbers on switches, sum shows up on the LEDs instantly. No clock
involved - flip a switch and the output just changes.

### 7-Segment Display Counter
Counts 0-9 on the display, resets, repeats. Combines a clock divider with a
decoder that maps digits to segment patterns.

### Button Debouncer
A button press bounces 20-30 times before it settles. This filters that out
so the FPGA sees one clean press instead of dozens.

### Traffic Light FSM
Red, green, yellow, loop. A pedestrian button interrupts at any point and
forces it back to red. First real state machine I built.

### UART Transmitter
Sends text to a PC over serial, one bit at a time at a fixed rate.

### ALU with Hex Display
Add, subtract, AND, OR, XOR, shift - picked with switches, result shown in
hex on two digits. Tested unsigned subtraction underflow specifically:
2 - 5 wraps to 0x1D instead of going negative, confirmed on hardware.

### VGA Signal Generator
Generates the timing signals for a 640x480 display from scratch - syncs,
color data, all of it, built to spec for 640x480@60Hz.

### Capstone - RISC-V CPU Core
Six modules - register file, ALU, decoder, immediate generator, PC/instruction
memory, data memory - wired into a single-cycle RV32I core decoding all six
RISC-V instruction formats.

Wrote a test program by hand (add two numbers, subtract them, loop) and ran
it - passed in simulation, then flashed it to the board and read the actual
register values off the LEDs. x3 came out to 15, x4 came out to 5, matching
the simulator exactly.

## Tools
- Vivado ML Standard Edition 2025.2
- Basys 3 AMD Artix-7 FPGA Development Board
- Verilog HDL

## About
Summer 2026, done on my own time. Wanted real RTL experience before internship
season and before this shows up in my actual coursework.
