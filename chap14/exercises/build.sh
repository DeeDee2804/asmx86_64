#!/bin/bash
# Simple assemble/link script

yasm -g dwarf2 -f elf64 main.asm -l main.lst
yasm -g dwarf2 -f elf64 stats.asm -l stats.lst
yasm -g dwarf2 -f elf64 utils.asm -l utils.lst
ld -g -o main main.o stats.o utils.o