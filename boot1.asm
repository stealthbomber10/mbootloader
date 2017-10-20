bits 16 ; message to nasm
org 0x7c00 ; start outputting stuff at offset 0x7c00
boot:
	mov si, hello ; point to hello label memory location
	mov ah, 0x0e ; write character in tty mode
.loop:
	lodsb
	or al, al ; is al == 0?
	jz halt ; jump if al == 0
	int 0x10 ; BIOS interrupt 0x10 - video services
	jmp .loop
halt:
	cli ; clear interrupt flag
	hlt ; halt execution
hello: db "Hello world!", 0

times 510 - ($-$$) db 0 ; pad bytes with zeroes
dw 0xaa55 ; magic trigger to bootloader
