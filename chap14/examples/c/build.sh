#!/bin/bash
# Simple assemble/link script

gcc -g -Wall -c main.c
yasm -g dwarf2 -f elf64 stats.asm
gcc -g -o main main.o stats.o