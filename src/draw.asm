clearScreen:                    ; Funcion encargada de limpiar la pantalla
    call    initializeDisplay   ; Llama a la funcion para inicializar el display
    mov     ah, 0bh             ; Configuracion 
    mov     bh, 00h             ; Elije el fondo
    mov     bl, 00h             ; Color negro
    int     10h                 ; Ejecutar interrupcion
    ret                         ; Retornar

drawAlien:                      ; Funcion encargada de dibujar el alien
    mov     cx, [alienx]        ; Posicion inicial x del alien
    mov     dx, [alieny]        ; Posicion inicial y del alien
    jmp     drawAlienAux        ; Salta a la funcion auxliar

drawAlienAux:
    mov     ah, 0ch             ; Dibuja pixel
    mov     al, 02h             ; Color verde
    mov     bh, 00h             ; Pagina
    int     10h                 ; Ejecutar interrupcion
    inc     cx                  ; Suma uno a cx
    mov     ax, cx              ; Mueve cx a ax
    sub     ax, [alienx]        ; Resta el ancho del alien a la columna actual
    cmp     ax, [aliensize]     ; Compara resultado de la resta con el ancho
    jng     drawAlienAux        ; Si ax no es mayor que el ancho del alien, salta a dibujar en la siguiente columna
    jmp     drawAlienAux2       ; Sino, salta a la funcion auxiliar 2

drawAlienAux2:                  
    mov     cx, [alienx]        ; Reinicia las columnas
    inc     dx                  ; Suma uno a dx
    mov     ax, dx              ; Mueve dx a ax
    sub     ax, [alieny]        ; Resta el alto del alien a la fila actual
    cmp     ax, [aliensize]     ; Compara resultado de la resta con la altura
    jng     drawAlienAux        ; Si ax no es mayor que el ancho del alien, salta a dibujar la siguiente fila
    ret                         ; Sino, Retornar