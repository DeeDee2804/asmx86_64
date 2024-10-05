#!/bin/bash
yasm -g dwarf2 -f elf64 -l cmdLine.lst cmdLine.asm 
g++ -g -o argsExp argsExp.cpp
g++ -g -no-pie -o  cmdLine cmdLine.o