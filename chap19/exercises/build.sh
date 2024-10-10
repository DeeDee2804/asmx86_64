#!/bin/bash
yasm -g dwarf2 -f elf64 maxthread1.asm
yasm -g dwarf2 -f elf64 maxthread2.asm
yasm -g dwarf2 -f elf64 maxthread3.asm
gcc -g -no-pie -o maxthread1 maxthread1.o -lpthread
gcc -g -no-pie -o maxthread2 maxthread2.o -lpthread
gcc -g -no-pie -o maxthread3 maxthread3.o -lpthread