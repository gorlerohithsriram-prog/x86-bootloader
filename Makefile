# Makefile — Phase 1
# Usage:
#   make        → assemble build/boot.bin
#   make run    → assemble and boot it in QEMU
#   make hex    → show the binary as hex (check code + 55 AA)
#   make clean  → delete build output

ASM    = nasm
QEMU   = qemu-system-i386
SRC    = src
BUILD  = build

all: $(BUILD)/boot.bin

$(BUILD)/boot.bin: $(SRC)/boot.asm
	@mkdir -p $(BUILD)
	$(ASM) -f bin $< -o $@

run: all
	$(QEMU) -drive format=raw,file=$(BUILD)/boot.bin

hex: all
	xxd $(BUILD)/boot.bin

clean:
	rm -rf $(BUILD)/*

.PHONY: all run hex clean
