# x86-bootloader

## Project Goal
Build a simple 2-stage bootloader from scratch using x86 Assembly and C that starts up a computer, switches the processor from 16-bit mode to 32-bit mode, and loads a basic C kernel into memory.

## Project Architecture
```text
BIOS
 ↓
Stage 1 Bootloader
 ↓
Stage 2 Bootloader
 ↓
Protected Mode
 ↓
C Kernel
```
## Development Roadmap

### Stage 0: Setup and Core Concepts
```text
Objective: Set up the development tools and understand what happens in the first few milliseconds after pressing a computer's power button.

Tools to Install:
NASM (Netwide Assembler): Converts our Assembly code into raw machine code (0s and 1s) that the CPU understands.
QEMU (qemu-system-i386): A virtual PC emulator so we can test our bootloader safely without needing to reboot a real computer every time.
GDB (GNU Debugger): Helps us pause the CPU step-by-step to inspect memory and fix bugs.
Make: Automates the commands needed to build and run the project.
Topics to Learn:
How a PC Boots: When a PC turns on, the motherboard runs firmware called BIOS. For this project, we are implementing the traditional BIOS/MBR boot path. The BIOS selects a bootable disk, loads its boot sector into memory at 0x7C00, verifies the boot signature 0xAA55, and begins executing it.
Basic x86 CPU Registers: Understanding small storage slots inside the CPU (AX, BX, CX, DX, Stack Pointer SP, and Instruction Pointer IP) and how 16-bit Assembly uses them.
```
### Stage 1: "Hello World" Boot Sector
```text
Objective: Write our first 512-byte boot sector in Assembly and display text on the screen inside QEMU.

What We Will Build:
Set the starting memory address to 0x7C00 using [org 0x7C00] so our code knows where the BIOS placed it in RAM.
Use BIOS screen functions (Interrupt 0x10) to print single characters to the monitor.
Write a loop (print_string) to print full sentences, and a helper function (print_hex) to print memory addresses on screen for troubleshooting.
Fill any unused space with zeros up to 510 bytes and place the 0xAA55 boot signature in the final two bytes of the sector so the BIOS recognizes it as bootable.
Create a basic Makefile to assemble the code and launch it in QEMU.
Milestone: QEMU boots from our binary file and prints "Hello from our bootloader!" on the screen.
```
### Stage 2: Reading More Code from the Disk
```text
Objective: Overcome the 512-byte size limit by writing a first-stage loader that reads a larger second file (Stage 2) from the disk into RAM.

Why This Is Needed: 512 bytes is too small to hold a full bootloader. The first sector only needs to act as a small loader that pulls the rest of our program from the disk into memory.
What We Will Build:
Use BIOS disk services (Interrupt 0x13) to read additional sectors from the storage drive into RAM (For example, if the boot sector is loaded at 0x7C00, the next sector begins at 0x7E00).
Save the boot drive number that the BIOS gives us in the DL register.
Add basic error checking: if reading the disk fails (indicated by the CPU's Carry Flag), reset the disk controller and retry up to 3 times before showing an error message.
Combine Stage 1 and Stage 2 into a single disk image and jump from Stage 1 into the newly loaded Stage 2 code.
Things to Watch Out For: Sector numbering on disk starts at 1 (not 0), and memory segment registers (ES:BX) must be set properly before calling the disk read interrupt.
```
### Stage 3: Switching to 32-Bit Protected Mode
```text
Objective: Move the CPU out of its old 16-bit startup mode ("Real Mode") into modern 32-bit "Protected Mode".

Why This Is Needed: Every x86 CPU starts in 16-bit Real Mode for backward compatibility with old 1980s computers. In this mode, we can only access 1 MB of RAM and have no memory security. Switching to 32-bit Protected Mode unlocks up to 4 GB of RAM and allows us to run C code.
What We Will Build (inside Stage 2):
Detect System RAM: Ask the BIOS how much memory is installed (using Interrupt 0x15) before turning off BIOS services.
Enable the A20 Line: Unlock a hardware gate from older PC designs so the CPU can access memory above 1 MB.
Set Up the GDT (Global Descriptor Table): Create a simple lookup table that tells the CPU how memory is organized and protected in 32-bit mode (defining a 4 GB code region and a 4 GB data region).
Perform the Mode Switch: Disable interrupts (cli), load our GDT (lgdt), flip the Protected Mode switch inside the CPU's control register (CR0), and jump into 32-bit code.
Direct Screen Output: Once in 32-bit mode, BIOS shortcuts no longer work. We will print text by writing characters directly into the video card's text memory at address 0xB8000.
```
### Stage 4: Loading a Basic C Kernel
```text
Objective: Connect our Assembly bootloader to a simple program written in C (a mini kernel) and hand over control to it.

What We Will Build:
Write a minimal C file with a kmain() function that clears the screen and prints a welcome message using video memory (0xB8000).
Compile the C code using a cross-compiler (gcc in 32-bit freestanding mode, meaning it runs directly on hardware without needing Windows or Linux libraries).
Write a basic linker script (linker.ld) to make sure our C kernel is placed at a fixed memory location (such as 0x10000 or the 1 MB mark 0x100000).
Update the bootloader to load this compiled C kernel from the disk into RAM, switch to 32-bit mode, and call kmain().
Final Deliverable: The computer boots up, runs our Assembly Stage 1 and Stage 2 loaders, switches to 32-bit mode, and starts executing our C kernel.
```

## Technologies used
- Assembly Language
- NASM
- QEmu
- C
- Make

## Resources

- [OSDev Wiki](https://wiki.osdev.org/)
- [How Computers Boot Up by Gustavo Duarte](https://manybutfinite.com/post/how-computers-boot-up/)
- [nanobyte_os](https://github.com/nanobyte-dev/nanobyte_os)
- [Writing OS PDF](https://angom.myweb.cs.uwindsor.ca/teaching/cs330/WritingOS.pdf)

## Acknowledgements

This project was developed for learning purposes using publicly
 available documentation and educational resources listed above.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
