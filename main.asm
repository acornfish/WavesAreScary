BITS 64
    org 0x400000

ehdr:
    db 0x7F, "ELF", 2, 1, 1, 3          ; e_ident (magic + class=64 + data=LE + version)
    times 8 db 0                      ; padding to 16 bytes total
    dw 2                               ; e_type (ET_EXEC)
    dw 62                              ; e_machine (EM_X86_64)
    dd 1                               ; e_version
    dq _start                          ; e_entry (64-bit entry)
    dq phdr - $$                       ; e_phoff (program header offset)
    dq 0                               ; e_shoff (no section header)
    dd 0                               ; e_flags
    dw ehdrsize                        ; e_ehsize (header size)
    dw phdrsize                       ; e_phentsize (program header entry size)
    dw 1                               ; e_phnum (number of program headers)
    dw 0                               ; e_shentsize
    dw 0                               ; e_shnum
    dw 0                               ; e_shstrndx

ehdrsize equ $ - ehdr

phdr:
    dd 1                               ; p_type (PT_LOAD)
    dd 5                               ; p_flags (PF_X | PF_R)
    dq 0                               ; p_offset (file offset)
    dq $$                              ; p_vaddr (virtual address)
    dq $$                              ; p_paddr (physical address)
    dq filesize                       ; p_filesz
    dq memsize                        ; p_memsz
    dq 0x1000                         ; p_align (page alignment)

phdrsize equ $ - phdr

%include "game.asm"

filesize equ _end - $$
memsize  equ _end - $$