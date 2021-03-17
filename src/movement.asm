moveAlien:                      ; Funcion encargada de mover el alien
    mov     ax, [alienvx]       ; Mueve la velocidad x del alien a ax
    add     [alienx], ax        ; Suma la velocidad a la posicion x
    mov     ax, [alienvy]       ; Mueve la velocidad y del alien a ax
    add     [alieny], ax        ; Suma la velocidad a la posicion y
    ret                         ; Retornar