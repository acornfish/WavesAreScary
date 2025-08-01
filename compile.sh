nasm -f bin -o main.out main.asm -w-zeroing
chmod +x main.out
strace ./main.out
