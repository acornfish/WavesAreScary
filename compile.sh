nasm -f bin -o wavesAreScary.elf main.asm -w-zeroing
chmod +x wavesAreScary.elf
qrencode -r wavesAreScary.elf -o wavesAreScary.png -v 4 -8  