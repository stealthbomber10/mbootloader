bits 16
org 0x7c00

boot:
	mov ax, 0x2401
	int 0x15 ; enable a20 bit (allows us to access more than 1 mb of memory)
	mov ax, 0x3
	int 0x10 ; set vga text mode 3 (just a safe value)
	lgdt [gdt_pointer] ; load gdt (global descriptor table), defines a 32 bit code segment
	mov eax, cr0 ; basically we're enabling 32 bit instructions and access to 32 bit registers
	or eax, 0x1 ; set protected mode bit on special cpu reg cr0
	mov cr0, eax
	jmp CODE_SEG:boot2 ; long jump to code segment
gdt_start:
	dq 0x0 ; this is basically a bunch of definitions for the gdt
gdt_code:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esi, hello
	mov ebx, 0xb8000
.loop:
	lodsb
	or al, al
	jz halt
	or eax, 0x0100
	mov word [ebx], ax
	add ebx, 2 ; change this to change the spacing between characters!
	jmp .loop
halt:
	cli
	hlt
hello: db "Hello world!",0

times 510 - ($-$$) db 0
dw 0xaa55
