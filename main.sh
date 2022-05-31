clear
nasm -f elf64 main.s
ld -o compiled main.o
./compiled
rm main.o compiled