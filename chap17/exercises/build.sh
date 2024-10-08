#!/bin/bash
yasm -g dwarf2 -f elf64 -l myGetLine.lst myGetLine.asm
yasm -g dwarf2 -f elf64 -l addLine.lst addLine.asm
gcc -g -no-pie -o myGetLine myGetLine.o
gcc -g -no-pie -o addLine addLine.o
./addLine test1.txt out1.txt
./addLine test2.txt out2.txt
./addLine test3.txt out3.txt
./addLine test4.txt out4.txt