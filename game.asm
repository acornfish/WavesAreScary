; Was this worth the effort? No way
; Will I do it again? Most likely

%define row          0    
%define col          4    
%define width        8    
%define height       12   
%define bytespp      16   
%define pFramebuffer 24   
%define waves        32   
%define seed         40   
%define speed        48   
%define lastCycle    56   
%define fd           64   
%define screeninfo   72   
%define fixinfo      232  
%define score        320  
%define screensize   328
%define px   336
%define lastChar   340
%define stimeT   344
%define termiosStored   360
%define termiosModify   420


%define screeninfo_xres 0
%define screeninfo_yres 4
%define screeninfo_bpp 24
%define fixinfo_line_length 48

fb:  db "/dev/fb0", 0

colors: dd 0xFF2E70F3, 0xFFFFFFFF, 0xFF8F563B, 0xFF451506
ship_sprite: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,1,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,1,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,3,2,2,2,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
wave_sprite: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,1,0,0,0,1,1,1,0,1,1,1,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
very_important_variable: db 'I like eating fried cats', 0

sh: 
    dq _exit
    dq 0x4000000             
    dq restorer
    dq 0, 0, 0, 0

restorer:
    mov rax, 15         ; syscall: rt_sigreturn
    syscall

_start:
    ;;handle sigterm, sighup, sigint, sigquit etc.
    mov rax, 13            
    mov rdi, 15            
    lea rsi, [rel sh]      
    xor rdx, rdx           
    mov r10, 8             
    syscall
    mov rax, 13            
    mov rdi, 2            
    syscall
    mov rax, 13            
    mov rdi, 3
    syscall
    mov rax, 13            
    mov rdi, 1            
    syscall
    mov rax, 13            
    mov rdi, 4
    syscall
    mov rax, 13            
    mov rdi, 6
    syscall
    mov rax, 13            
    mov rdi, 11
    syscall


    ;Allocate storage area
    mov rax, 9          ; sys_mmap
    xor rdi, rdi        ; addr=0
    mov rsi, 4096       
    mov rdx, 3          ; PROT_READ | PROT_WRITE
    mov r10, 0x22          
    mov r8, -1         ; fd
    xor r9, r9          ; offset=0
    syscall
    mov r15, rax

    ; enter graphics mode
    ; mov rdi, 0
    ; mov rax, 16
    ; mov rsi, 0x4B3A
    ; mov rdx, 1
    ; syscall

    
    ;open framebuffer
    mov rax, 2
    lea rdi, fb
    mov rsi, 2
    mov rdx, 0
    syscall
    mov [r15 + fd], rax
    cmp rax, 0
    jl _eexit

    ;check ioctl
    mov rax, 16
    xor rdi, rdi
    mov edi, [r15+fd]
    mov rsi, 0x4600
    lea rdx, [r15+screeninfo]
    syscall 
    mov rax, 16
    xor rdi, rdi
    mov edi, [r15+fd]
    mov rsi, 0x4602
    lea rdx, [r15+fixinfo]
    syscall 

    call _enableRawMode

    ;calculate bytespp
    xor rax, rax
    mov eax, [r15+screeninfo+screeninfo_bpp]
    cmp rax, 32
    jnz _exit
    mov rcx, 8
    xor rdx, rdx
    div rcx
    mov [r15+bytespp], eax

    ;assign width and height
    xor rax, rax
    xor rdx, rdx
    mov eax, [r15+screeninfo+screeninfo_xres]
    mov rcx, 100
    div rcx
    mov eax, [r15+screeninfo+screeninfo_xres]
    sub eax, edx
    mov [r15+width], eax
    xor rax, rax
    xor rdx, rdx
    mov eax, [r15+screeninfo+screeninfo_yres]
    mov rcx, 100
    div rcx
    mov eax, [r15+screeninfo+screeninfo_yres]
    sub eax, edx
    mov [r15+height], eax

    ;calculate screensize
    xor rax, rax
    xor rcx, rcx
    mov eax, [r15+fixinfo+fixinfo_line_length]
    mov ecx, [r15+height]
    mul rcx
    mov [r15+screensize], rax

    ;allocate framebuffer memory
    xor rsi, rsi
    mov rax, 9          ; sys_mmap
    mov rsi, [r15+screensize]      
    xor rdi, rdi        ; addr=0
    mov rdx, 3          ; PROT_READ | PROT_WRITE
    mov r10, 1          ; MAP_SHARED
    xor r8, r8
    mov r8d, [r15+fd]         ; fd
    xor r9, r9          ; offset=0
    syscall
    mov [r15+pFramebuffer], rax

    ;assign variables
    mov BYTE [r15+seed], 124
    mov DWORD [r15+speed], 450
    call _getTime
    mov [r15+lastCycle], rax
    mov DWORD [r15+px], 1
    xor rax, rax
    mov BYTE [r15+lastChar], al

    jmp gameLoop

    call _exit

gameLoop:
    call _readInp

    cmp BYTE [r15+lastChar], 'a'
    jz move_left
    cmp BYTE [r15+lastChar], 'd'
    jz move_right    
    cmp BYTE [r15+lastChar], 27
    jz _exit
    jmp updateEn

    move_left:
        xor rax, rax
        mov eax, [r15+px]
        cmp rax, 0
        jle updateEn
        dec rax
        mov [r15+px], eax
        jmp updateEn

    move_right:
        xor rax, rax
        mov eax, [r15+px]
        cmp rax, 7
        jge updateEn
        inc rax
        mov [r15+px], eax
        jmp updateEn

    updateEn:
        mov BYTE [r15+lastChar], 0 ;dirty fix but *Don't touch if it works*
        call _getTime
        mov rdx, [r15+lastCycle]
        add rdx, [r15+speed]
        cmp rax, rdx
        jl draw
        mov [r15+lastCycle], rax

        mov rax, [r15+speed]
        mov rbx, 40
        imul rbx
        mov rbx, 43 ; diffrence between this two values determine how hard the game gets
        div rbx
        mov [r15+speed], rax

        call updateWaves
    draw: 
        call drawCanvas
        
    jmp gameLoop

updateWaves:
    call rando
    mov rcx, 8
    .updateLoop:
        mov r10, 8
        sub r10, rcx
        mov rcx, r10
        mov rax, 1
        shl rax, cl
        mov bl, [r15+seed]
        and bl, al
        cmp bl, 0
        jz .bypass
        add BYTE [r15+r10+waves], 1
        mov ebx, [r15+height]
        movsx rax, BYTE [r15+r10+waves]
        mov rdx, 100
        imul rdx
        cmp rax, rbx
        jle .bypass
        xor rax,rax
        mov al, -2
        mov BYTE [r15+r10+waves], al
        mov eax, [r15+score]
        inc eax
        mov [r15+score], eax
        .bypass:
        mov rcx, 8
        sub rcx, r10
        loop .updateLoop
    ret

rando:
    mov rax, 96
    lea rdi, [r15+stimeT]
    xor rsi, rsi
    syscall
    mov rax, [r15+stimeT+8]
    xor al, 7
    mov [r15+seed], al
    ret

drawCanvas:
    mov DWORD [r15+row], 0          
    mov DWORD [r15+col], 0          
    .outer_loop:
        mov eax, [r15+row]
        cmp eax, [r15+height]           
        jge .end_outer                  

        mov DWORD [r15+col], 0          
    .inner_loop:
        mov eax, [r15+col]
        cmp eax, [r15+width]            
        jge .end_inner                  

        ;loop body
        ; calculate pixel pointer to r9
        xor rax, rax
        xor rsi, rsi
        xor rdx, rdx
        xor r9, r9
        mov eax, [r15+row]                          
        mov edx, [r15+fixinfo+fixinfo_line_length]  
        mul rdx                                   
        mov r9, rax                               

        xor rax, rax
        mov eax, [r15+col]
        mov edx, [r15+bytespp]
        mul rdx                                   
        add r9, rax                               
        add r9, [r15+pFramebuffer]                

        ; determine what to draw
        ; default state 
        mov ebx, [colors]
          
        call is_ship
        call is_wave

        ; actually put the pixel in
        mov [r9], ebx

        inc DWORD [r15+col]
        jmp .inner_loop

    .end_inner:
        ; row++
        inc DWORD [r15+row]
        jmp .outer_loop

    .end_outer:
        ret

is_ship:
    push rcx
    mov eax, [r15+row]
    mov edx, [r15+height]
    sub edx, 100
    cmp eax, edx
    jl .out

    mov edx, [r15+height]
    cmp eax, edx
    jge .out

    mov eax, [r15+px]
    mov ecx, 100
    mul ecx
    xor r10, r10
    mov r10d, [r15+col]
    cmp r10d, eax
    jle .out
    
    add eax, 100
    cmp r10d, eax
    jg .out

    ;map row to sprite
    mov eax, [r15+row]
    mov r10d, 100
    xor edx, edx
    div r10d
    mov eax, edx
    mov r10d, 5
    xor edx, edx
    div r10d
    mov r11d, eax

    ;map collumn to sprite
    mov r10d, 100
    mov eax, [r15+col]
    xor edx, edx
    div r10d
    mov eax, edx
    mov r10d, 5
    xor edx, edx
    div r10d
    mov r10d, eax

    imul r11, 20

    mov rax, r11
    add rax, r10
    mov r10b, [ship_sprite+rax]
    mov ebx, [colors+r10*4]

    .out:
        pop rcx
        ret

is_wave:
    push rcx
    mov rcx, 8
    .inner_loop:
        mov r11, 8
        sub r11, rcx
        ;check if player collided with wave
        movsx rax, BYTE [r15+r11+waves]
        mov rdx, 100
        mul edx
        add eax, 100
        cmp eax, [r15+height]
        jnz .showMustContinue
        cmp r11, [r15+px]
        jnz .showMustContinue

        call _exit

        .showMustContinue:

        ;check if wave should be drawn
        mov r10, r15
        add r10, r11
        xor rax, rax
        mov al, [r10+waves] 
        mov edx, [r15+row]
        mov r12b, 100
        mul r12b
        cmp edx, eax
        jle .njet

        add eax, 100
        cmp edx, eax
        jge .njet

        mov eax, r11d
        mov r11d, [r15+col]
        mov r10d, 100
        mul r10d
        cmp r11d, eax
        jle .njet

        add eax, r10d
        cmp r11d, eax
        jg .njet

        call _map_wave_sprite
        .njet:
            loop .inner_loop
    pop rcx
    ret

_map_wave_sprite:
    ;map row to sprite
    mov eax, [r15+row]
    mov r10d, 100
    xor edx, edx
    div r10d
    mov eax, edx
    mov r10d, 5
    xor edx, edx
    div r10d
    mov r11d, eax

    ;map collumn to sprite
    mov r10d, 100
    mov eax, [r15+col]
    xor edx, edx
    div r10d
    mov eax, edx
    mov r10d, 5
    xor edx, edx
    div r10d
    mov r10d, eax

    imul r11, 20

    mov rax, r11
    add rax, r10
    mov r10b, [wave_sprite+rax]
    mov ebx, [colors+r10*4]
    ret

_getTime:
    mov rax, 96
    lea rdi, [r15+stimeT]
    xor rsi, rsi
    syscall
    mov rax, [r15+stimeT+8]
    mov rbx, 1000
    div rbx
    mov r10, rax
    mov rax, [r15+stimeT]
    mov rbx, 1000
    mul rbx
    add r10, rax
    ret

_readInp:
    xor rax, rax
    mov rdi, 0
    lea rsi, [r15+lastChar]
    mov rdx, 1
    syscall
    ret

_enableRawMode:
    ;non blocking mode
    mov rax, 72
    mov rsi, 3
    mov rdi, 0
    syscall
    mov r10, rax
    mov rdx, 2048
    or rdx, r10
    mov rsi, 4
    mov rax, 72
    syscall

    ;tcgetattr to store the current state
    mov rax, 16
    mov rdi, 0
    mov rsi, 0x5401
    lea rdx, [r15+termiosStored]
    syscall

    ;trust me this is the efficent method. Well, maybe not for cpu but definitely for file size
    mov rax, 16
    mov rdi, 0
    mov rsi, 0x5401
    lea rdx, [r15+termiosModify]
    syscall

    ; No echo, no canonical mode
    mov eax, [r15+termiosModify+12]
    mov ebx, 0xfffffff5
    and eax, ebx
    mov [r15+termiosModify+12], eax

    ;No minimum bytes, no timeout
    lea rax, [r15+termiosModify+17]
    mov ebx, 0
    mov BYTE [rax+4], bl
    mov BYTE [rax+5], bl

    ; Actually set the external struct
    mov rax, 16
    mov rdi, 0
    mov rsi, 0x5402
    lea rdx, [r15+termiosModify]
    syscall
    ret

_eexit: 
    xor rdi, rdi
    mov rdi, 0
    mov rax, 60
    syscall

_exit: 
    ;close framebuffer
    xor edi, edi
    mov edi, [r15 + fd]
    mov rax, 3
    syscall

    ; return to text mode
    mov rdi, 0
    mov rax, 16
    mov rsi, 0x4B3A
    xor rdx, rdx       
    syscall

    ;get out of nonblocking mode 
    mov rax, 72
    mov rsi, 3
    mov rdi, 0
    syscall
    mov r10, rax
    mov rdx, 2048
    not r10
    and rdx, r10
    mov rsi, 4
    mov rax, 72
    syscall

    ;reverse termios state
    mov rax, 16
    mov rdi, 0
    mov rsi, 0x5402
    lea rdx, [r15+termiosStored]
    syscall

    ;munmap framebuffer
    xor rsi, rsi
    mov rsi, [r15+screensize]
    mov rax, 11
    mov rdi, [r15+pFramebuffer]
    syscall

    mov r14, [r15+score]
    ;munmap storage
    mov rax, 11
    lea rdi, [r15]
    mov rsi, 4096
    syscall
    
    ;exit
    xor rdi, rdi
    mov rax, 60
    mov rdi, r14
    syscall

_end:
