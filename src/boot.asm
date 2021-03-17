org 0x7c00
bits 16

    jmp short start                 ; Salta al inicio del programa

%include "src/draw.asm"
%include "src/movement.asm"

width   dw  140h                    ; Ancho de la pantalla 320
height  dw  0c8h                    ; Alto de la pantalla 200

time    db  0

alienx  dw  0ah                     ; Posicion x del alien 
alieny  dw  0ah                     ; Posicion y del alien

alienvx dw  02h                     ; Velocidad x del alien
alienvy dw  02h                     ; Velocidad y del alien

aliensize   dw  0ah                 ; Altura y ancho del alien

start:                              ; Funcion de inicio del programa
    call    initializeBootloader    ; Llama a la funcion para inicializar el bootloader
    call    initializeDisplay       ; Llama a la funcion para inicializar el display
    jmp     mainLoop                ; Salta a la funcion principal del programa

initializeBootloader:               ; Funcion requerida para inicializar el bootloader
    xor     ax, ax                  ; Limpia el registro ax
    mov     ds, ax                  ; Limpia el registro ds
    mov     es, ax                  ; Limpia el registro es
    ret                             ; Retornar

initializeDisplay:                  ; Funcion requerida para inicializar el display
    mov     ah, 00h                 ; Activar el modo video
    mov     al, 13h                 ; 320x200 256 colores
    int     10h                     ; Ejecutar interrupcion
    ret                             ; Retornar

mainLoop:                           ; Funcion principal del programa
    mov     ah, 00h                 ; Activa obtener el tiempo de la computadora
    int     1ah                     ; Ejecutar interrupcion

    cmp     dl, [time]              ; Compara el tiempo actual con el tiempo anterior
    je      mainLoop                ; Si son iguales vuelve a calcular el ciclo
    mov     [time], dl              ; Sino, almacena el nuevo tiempo

    call    moveAlien               ; Llama a la funcion para mover el alien
    call    clearScreen             ; Llama a la funcion para limpiar la pantalla
    call    drawAlien               ; Llama a la funcion para dibujar al alien
    jmp     mainLoop                ; Salta al incio de la funcion

times   510-($-$$) db 0
dw      0xaa55