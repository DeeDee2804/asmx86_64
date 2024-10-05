#!/bin/bash
yasm -g dwarf2 -f elf64 -l ex4.lst ex4.asm
yasm -g dwarf2 -f elf64 -l ex2.lst ex2.asm 
yasm -g dwarf2 -f elf64 -l ex3.lst ex3.asm 
g++ -g -no-pie -o  ex3 ex3.o
g++ -g -no-pie -o  ex2 ex2.o
g++ -g -no-pie -o  ex4 ex4.o