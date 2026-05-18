# FPGA Projects

A collection of digital hardware designs built in Verilog on a Basys 3 Artix-7 FPGA 
board. Projects progress from basic combinational logic up to a complete CPU core.

## Projects

### LED Blinker
A clock divider circuit that toggles an LED at roughly 1Hz using a 27-bit counter 
driven by the board's 100MHz clock.

### 4-Bit Adder
A combinational circuit that takes two 4-bit inputs from the onboard switches and 
displays the sum on the LEDs.

### 7-Segment Display Counter
A sequential circuit that counts from 0 to 9 on the 7-segment display using a 
clock divider and BCD decoder.

### Button Debouncer
A hardware debounce circuit that cleans noisy button signals for reliable 
edge detection.

### Traffic Light FSM
A finite state machine that cycles through traffic light states with a 
pedestrian button override.

### UART Transmitter
A serial transmitter that sends ASCII characters to a PC terminal at a 
defined baud rate.

### ALU
A 4-bit arithmetic logic unit supporting add, subtract, AND, OR, XOR, 
and shift operations.

### VGA Signal Generator
Generates a 640x480 VGA signal from scratch and displays output on a monitor.

### Capstone - RISC-V CPU Core
A minimal RV32I processor core implemented entirely in Verilog capable of 
executing a basic instruction set.

## Tools
- Vivado ML Standard Edition 2025.2
- Basys 3 AMD Artix-7 FPGA Development Board
- Verilog HDL

## About
Independent hardware design project completed Summer 2026, two years ahead of 
the digital systems curriculum at UCF. Built to develop practical skills in 
RTL design and digital systems ahead of internship recruiting.
