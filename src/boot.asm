org 0x7c00
bits 16

    jmp short start    ; Salta al inicio

alienx  dw  0ah        ; Pos x del alien
alieny  dw  0ah        ; Pos y del alien

start:
    call    initializeBootloader
    call    initializeDisplay
    call    drawPixel
    jmp     $

initializeBootloader:  ; Requerido para inicializar el bootloader
    xor     ax, ax
    mov     ds, ax
    mov     es, ax

    ret

initializeDisplay:
    mov     ah, 00h    ; Activar el modo video
    mov     al, 13h    ; 320x200 256 colores
    int     10h        ; Ejecutar interrupcion
    ret                ; Retornar

drawPixel:
    mov     ah, 0ch    ; Dibuja pixel
    mov     al, 02h    ; Color blanco
    mov     bh, 00h    ; Pagina
    mov     cx, [alienx] ; Pos x
    mov     dx, [alieny] ; Pos y
    int     10h        ; Ejecutar interrupcion
    ret                ; Retornar

times   510-($-$$) db 0
dw      0xaa55