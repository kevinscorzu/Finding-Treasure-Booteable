org 0x7C00                           ; Posicion de memoria inicial del bootloader
%define SECTOR_AMOUNT 02h            ; Cantidad de sectores a leer

        jmp short startBootloader    ; Salta al inicio del bootloader
        nop                          ; Sin operacion

errorMsg db "Error de carga...", 0h  ; Mensaje de error

startBootloader:                     ; Funcion encargada de iniciar el bootloader
        cli                          ; Desactiva interrupciones
        xor ax, ax                   ; Vacia ax
        mov ds, ax                   ; Vacia ds
        mov ss, ax                   ; Vacia ss
        mov es, ax                   ; Vacia es
        mov fs, ax                   ; Vacia fs
        mov gs, ax                   ; Vacia gs
        mov sp, 6ef0h                ; Configura el stack
        sti                          ; Activa interrupciones

        mov ah, 00h                  ; Reinicia disco
        int 13h                      ; Ejecutar interrupcion
        jc error                     ; En caso de error, salta a la funcion encargada de escribir el mensaje
                       
        mov bx, 0x8000               ; Posicion de memoria de ram donde se escribira el juego
        mov al, SECTOR_AMOUNT        ; Sectores a leer
        mov ch, 00h                  ; Pista
        mov dh, 00h                  ; Cabeza
        mov cl, 02h                  ; Sector
        mov ah, 02h                  ; Leer del dispositivo
        int 13h   		     ; Ejecutar interrupcion
        jc error                     ; En caso de error, salta a la funcion encargada de escribir el mensaje
        jmp 8000h                    ; Salta al inicio del juego


error:                               ; Funcion encargada de escrbir el error
        mov si, errorMsg             ; Mueve a si el puntero del mensaje de error
        mov bh, 00h                  ; Pagina
        mov bl, 07h                  ; Texto
        mov ah, 0eh                  ; Imprimir char
        jmp errorAux

errorAux:
        lodsb                        ; Carga char
        sub al, 00h                  ; Verificar si es cero
        jz end                       ; En caso de que si, salta a fin
        int 10h                      ; Ejecutar interrupcion
        jmp errorAux                 ; Salta a errorAux
        
end:                                 ; Funcion encargada de salir
        jmp $                        ; Encicla el programa

times 510-($-$$) db 0                ; Escribe los bytes restantes de ceros
db 0x55                              ; Parte 1 del numero magico
db 0xaa                              ; Parte 2 del numero magico