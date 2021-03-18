org 0x8000                          ; Posicion de memoria inicial del kernel
bits 16                             ; Cantidad de bits a utilizar

    jmp short startGame             ; Salta al inicio del programa
    nop                             ; Sin operacion

; Seccion de Variables

width dw  140h                      ; Ancho de la pantalla 320 p
height dw  0c8h                     ; Alto de la pantalla 200 p
gameWidht  dw  8ch                  ; Ancho de la pantall de juego 100 p
gameHeight dw  8ch                  ; Alto de la pantalla de juego 100 p

time db  00h                        ; Tiempo utilizado para el framerate del juego

level dw 01h                        ; Nivel del juego

alienx dw  05h                      ; Posicion x del alien 
alieny dw  05h                      ; Posicion y del alien
talienx dw 05h
talieny dw 05h
alienv dw  0ah                      ; Velocidad del alien
alienc dw  02h                      ; Color del alien
aliens dw  05h                      ; Altura y ancho del alien
alienm dw  00h                      ; Ultima direccion del alien (0 der, 1 aba, 2 izq, 3 arr)

bulletx dw  05h                     ; Posicion x de la bala
bullety dw  05h                     ; Posicion y de la bala
bulletv dw  0ah                     ; Velocidad de la bala
bulletc dw  0ch                     ; Color de la bala
bullets dw  03h                     ; Altura y ancho de la bala
bulletb dw  00h                     ; Bala en pantalla (0 no, 1 si)
bulletd dw  00h                     ; Direccion de la bala (0 der, 1 aba, 2 izq, 3 arr)
bulletq dw  00h                     ; Cantidad de balas del alien

flowersc dw 0eh                     ; Color de las flores
flowerss dw 05h                     ; Altura y ancho de las flores
flowersi dw 00h                     ; Indice para contar flores
flowerx dw 00h                      ; Posicion x de la flor actual
flowery dw 00h                      ; Posicion y de la flor actual

flowersx1 dw 0fh, 19h, 41h, 41h, 73h, 7dh, 87h         ; Posicion x de las flores nivel 1
flowersy1 dw 37h, 73h, 19h, 87h, 7dh, 19h, 41h         ; Posicion y de las flores nivel 1
flowersb1 dw 01h, 01h, 01h, 01h, 01h, 01h, 01h         ; Flores en pantalla (0 no, 1 si) nivel 1
flowersa1 dw 0eh                    ; Cantidad de flores nivel 1

; Seccion de logica del juego

startGame:                          ; Funcion de inicio del programa
    call    initializeDisplay       ; Llama a la funcion para inicializar el display
    jmp     mainLoop                ; Salta a la funcion principal del programa

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

    call    checkKey                ; Llama a la funcion para mover el alien
    call    moveBullet              ; Llama a la funcion para mover la bala

    call    drawAlien               ; Llama a la funcion para dibujar al alien
    call    drawBullet              ; Llama a la funcion para dibujar la bala
    call    drawFlowers             ; Llama a la funcion para dibujar las flores
    
    jmp     mainLoop                ; Salta al incio de la funcion

;  Seccion de dibujo en pantalla

clearScreen:                        ; Funcion encargada de limpiar la pantalla
    mov     ah, 0bh                 ; Configuracion 
    mov     bh, 00h                 ; Elije el fondo
    mov     bl, 00h                 ; Color negro
    int     10h                     ; Ejecutar interrupcion
    ret                             ; Retornar

deleteAlien:                        ; Funcion encargadad de eliminar el alien en pantalla
    mov     al, 00h                 ; Mueve el color negro a al
    mov     [alienc], al            ; Guarda el color negro a alienc
    call    drawAlien               ; Llama a la funcion para dibujar el alien
    mov     al, 02h                 ; Mueve el color verde a al
    mov     [alienc], al            ; Guarda el color verde a alienc
    ret                             ; Retornar

drawAlien:                          ; Funcion encargada de dibujar el alien
    mov     cx, [alienx]            ; Posicion inicial x del alien
    mov     dx, [alieny]            ; Posicion inicial y del alien
    jmp     drawAlienAux            ; Salta a la funcion auxliar

drawAlienAux:
    mov     ah, 0ch                 ; Dibuja pixel
    mov     al, [alienc]            ; Color verde
    mov     bh, 00h                 ; Pagina
    int     10h                     ; Ejecutar interrupcion
    inc     cx                      ; Suma uno a cx
    mov     ax, cx                  ; Mueve cx a ax
    sub     ax, [alienx]            ; Resta el ancho del alien a la columna actual
    cmp     ax, [aliens]            ; Compara resultado de la resta con el ancho
    jng     drawAlienAux            ; Si ax no es mayor que el ancho del alien, salta a dibujar en la siguiente columna
    jmp     drawAlienAux2           ; Sino, salta a la funcion auxiliar 2

drawAlienAux2:                  
    mov     cx, [alienx]            ; Reinicia las columnas
    inc     dx                      ; Suma uno a dx
    mov     ax, dx                  ; Mueve dx a ax
    sub     ax, [alieny]            ; Resta el alto del alien a la fila actual
    cmp     ax, [aliens]            ; Compara resultado de la resta con la altura
    jng     drawAlienAux            ; Si ax no es mayor que el ancho del alien, salta a dibujar la siguiente fila
    ret                             ; Sino, Retornar

deleteBullet:                       ; Funcion encargadad de eliminar la bala en pantalla
    mov     al, 00h                 ; Mueve el color negro a al
    mov     [bulletc], al           ; Guarda el color negro a bulletc
    call    drawBullet              ; Llama a la funcion para dibujar la bala
    mov     al, 0ch                 ; Mueve el color rojo claro a al
    mov     [bulletc], al           ; Guarda el color rojo claro a bulletc
    ret                             ; Retornar

drawBullet:                         ; Funcion encargada de dibujar la bala
    mov     ax, 00h                 ; Mueve 0 a ax
    cmp     [bulletb], ax           ; Verifica si deberia haber una bala en pantalla
    je      exitRoutine             ; En caso de que no, sale de la funcion

    mov     cx, [bulletx]           ; Posicion inicial x de la bala
    mov     dx, [bullety]           ; Posicion inicial y de la bala
    jmp     drawBulletAux           ; Salta a la funcion auxliar

drawBulletAux:
    mov     ah, 0ch                 ; Dibuja pixel
    mov     al, [bulletc]           ; Color rojo claro
    mov     bh, 00h                 ; Pagina
    int     10h                     ; Ejecutar interrupcion
    inc     cx                      ; Suma uno a cx
    mov     ax, cx                  ; Mueve cx a ax
    sub     ax, [bulletx]           ; Resta el ancho de la bala a la columna actual
    cmp     ax, [bullets]           ; Compara resultado de la resta con el ancho
    jng     drawBulletAux           ; Si ax no es mayor que el ancho de la bala, salta a dibujar en la siguiente columna
    jmp     drawBulletAux2          ; Sino, salta a la funcion auxiliar 2

drawBulletAux2:                  
    mov     cx, [bulletx]           ; Reinicia las columnas
    inc     dx                      ; Suma uno a dx
    mov     ax, dx                  ; Mueve dx a ax
    sub     ax, [bullety]           ; Resta el alto de la bala a la fila actual
    cmp     ax, [bullets]           ; Compara resultado de la resta con la altura
    jng     drawBulletAux           ; Si ax no es mayor que el ancho de la bala, salta a dibujar la siguiente fila
    ret                             ; Sino, Retornar

drawFlowers:                        ; Funcion encargada de dibujar la flor
    mov     ax, 01h                 ; Mueve 1 a ax
    cmp     [level], ax             ; Compara el nivel actual con ax
    je      drawFlowersLevel1       ; Salta a configurar el nivel 1
    ;jmp     drawFlowerAux?          ; Salta a configurar el nivel 2

drawFlowersAux:
    mov     ah, 0ch                 ; Dibuja pixel
    mov     al, [flowersc]          ; Color verde
    mov     bh, 00h                 ; Pagina
    int     10h                     ; Ejecutar interrupcion
    inc     cx                      ; Suma uno a cx
    mov     ax, cx                  ; Mueve cx a ax
    sub     ax, [flowerx]           ; Resta el ancho de la flor a la columna actual
    cmp     ax, [flowerss]          ; Compara resultado de la resta con el ancho
    jng     drawFlowersAux          ; Si ax no es mayor que el ancho de la flor, salta a dibujar en la siguiente columna
    jmp     drawFlowersAux2         ; Sino, salta a la funcion auxiliar 2

drawFlowersAux2:                  
    mov     cx, [flowerx]           ; Reinicia las columnas
    inc     dx                      ; Suma uno a dx
    mov     ax, dx                  ; Mueve dx a ax
    sub     ax, [flowery]           ; Resta el alto de la flor a la fila actual
    cmp     ax, [flowerss]          ; Compara resultado de la resta con la altura
    jng     drawFlowersAux          ; Si ax no es mayor que el ancho de la flor, salta a dibujar la siguiente fila
    jmp     drawFlowersAux3         ; Sino, salta a la funcion auxliar 3

drawFlowersAux3:
    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    add     cx, 02h                 ; Suma 2 a cx
    mov     [flowersi], cx          ; Guarda el nuevo contador

    jmp     drawFlowers             ; Salta a la funcion de dibujo principal

drawFlowersLevel1:                  ; Funcion encargada de dibujar las flores del primer nivel
    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    cmp     cx, [flowersa1]         ; Compara el contador con la cantidad de flores del primer nivel
    je      exitFlowers             ; Si son iguales salta a la funcion de salida

    mov     bx, flowersb1           ; Mueve el puntero del primer elemento de la lista que indica si una flor esta activa o no
    add     bx, cx                  ; Suma el contador al puntero

    mov     ax, [bx]                ; Obtiene la flor actual
    cmp     ax, 00h                 ; Compara la flor con 0 para ver si tiene que ser dibujada
    je      drawFlowersAux3         ; En caso de que no salta a la funcion auxiliar 3
    jmp     drawFlowersLevel1Aux    ; Sino, salta a la funcion auxiliar 1

drawFlowersLevel1Aux:
    mov     ax, [flowersi]          ; Mueve el contador de las flores a ax

    mov     bx, flowersx1           ; Mueve el puntero del primer elemento de la lista de las posiciones x de las flores
    add     bx, ax                  ; Suma el contador al puntero
    mov     ax, [bx]                ; Obtiene la posicion x de la flor actual
    mov     [flowerx], ax           ; La almacena en la variable que contiene la posicion x de la flor actual
    mov     cx, [flowerx]           ; Mueve la posicion inicial x a cx

    mov     ax, [flowersi]          ; Mueve el contador de las flores a ax

    mov     bx, flowersy1           ; Mueve el puntero del primer elemento de la lista de las posiciones y de las flores
    add     bx, ax                  ; Suma el contador al puntero
    mov     ax, [bx]                ; Obtiene la posicion y de la flor actual
    mov     [flowery], ax           ; La almacena en la variable que contiene la posicion y de la flor actual
    mov     dx, [flowery]           ; Mueve la posicion inicial y a dx

    jmp     drawFlowersAux          ; Salta a la funcion auxliar

exitFlowers:
    mov     ax, 00h                 ; Mueve un 0 a ax
    mov     [flowersi], ax          ; Lo almacena en el contador de las flores

    ret                             ; Retornar

; Seccion de lectura del teclado

checkKey:                           ; Funcion encargada de mover el alien
    mov     ah, 01h                 ; Consigue el estado del teclado
    int     16h                     ; Ejecutar interrupcion
    jz      exitRoutine             ; Si no se esta presionando nada, salta a salir
    
    mov     ah, 00h                 ; Lectura de tecla
    int     16h                     ; Ejecutar interrupcion

    cmp     ah, 48h                 ; Si la tecla presionada es la Flecha Arriba
    je      moveAlienUp             ; Salta a mover el alien hacia arriba
    
    cmp     ah, 50h                 ; Si la tecla presionada es la Flecha Abajo
    je      moveAlienDown           ; Salta a mover el alien hacia abajo

    cmp     ah, 4dh                 ; Si la tecla presionada es la Flecha Derecha
    je      moveAlienRight          ; Salta a mover el alien hacia la derecha

    cmp     ah, 4bh                 ; Si la tecla presionada es la Flecha Izquierda
    je      moveAlienLeft           ; Salta a mover el alien hacia la izquierda

    cmp     ah, 39h                 ; Si la techa presionada es Espacio
    je      shootBullet             ; Dispara una bala

    ret                             ; Sino, Retornar

exitRoutine:                        ; Funcion encargada de retornar
    ret                             ; Retornar

; Seccion de movimiento, logica y colisiones

shootBullet:                        ; Funcion encargada de activar la bala
    mov     ax, 00h                 ; Mueve 0 a ax
    cmp     [bulletq], ax           ; Verifica si el jugador tiene suficientes balas
    je      exitRoutine             ; En caso de no tener balas sale de la rutina

    mov     ax, 01h                 ; Mueve 1 a ax
    cmp     [bulletb], ax           ; Verifica si ya hay una bala en pantalla
    je      exitRoutine             ; En caso de que si, salta a salir

    mov     [bulletb], ax           ; Guarda el 1 al indicador de bala en pantalla

    sub     [bulletq], ax           ; Resta una bala de la cantidad total de balas del alien

    mov     ax, [alienm]            ; Mueve la ultima direccion del alien a ax
    mov     [bulletd], ax           ; Guarda la ultima direccion del alien a la bala (para que sean iguales)

    mov     ax, [alienx]            ; Mueve la posicion x del alien a ax
    add     ax, 01h                 ; Suma 1 a ax
    mov     [bulletx], ax           ; Guarda la posicion x del alien a la bala

    mov     ax, [alieny]            ; Mueve la posicion y del alien a ax
    add     ax, 01h                 ; Suma 1 a ax
    mov     [bullety], ax           ; Guarda la posicion y del alien a la bala

    ret                             ; Retornar

clearBullet:                        ; Funcion encargada de desactivar la bala
    call    deleteBullet            ; Llama a la funcion para eliminar la bala

    mov     ax, 00h                 ; Mueve un 0 a ax
    mov     [bulletb], ax           ; Guarda el 0 al indicador de bala en pantalla

    ret                             ; Retornar


moveBullet:                         ; Funcion encargada de mover la bala
    mov     ax, 00h                 ; Mueve 0 a ax
    cmp     [bulletb], ax           ; Verifica si deberia haber una bala en pantalla
    je      exitRoutine             ; En caso de que no, sale de la funcion

    cmp     [bulletd], ax           ; Verifica si la bala se mueve a la derecha
    je      moveBulletRight         ; En caso de que si, mueve la bala a la derecha

    mov     ax, 01h                 ; Mueve 1 a ax
    cmp     [bulletd], ax           ; Verifica si la bala se mueve hacia abajo
    je      moveBulletDown          ; En caso de que si, mueve la bala hacia abajo

    mov     ax, 02h                 ; Mueve 2 a ax
    cmp     [bulletd], ax           ; Verifica si la bala se mueve a la izquierda
    je      moveBulletLeft          ; En caso de que si, mueve la bala a la izquierda

    mov     ax, 03h                 ; Mueve 3 a ax
    cmp     [bulletd], ax           ; Verifica si la bala se mueve hacia arriba
    je      moveBulletUp            ; En caso de que si, mueve la bala hacia arriba

    ret                             ; Retornar

moveBulletUp:                       ; Funcion encargada de mover la bala hacia arriba
    mov     ax, 06h                 ; Mueve 6 a ax
    cmp     [bullety], ax           ; Compara la posicion y de la bala con ax
    je      clearBullet             ; Si son iguales, salta a la funcion de salida

    call    deleteBullet            ; Llama a la funcion encargada de eliminar la bala
    mov     ax, [bulletv]           ; Mueve la velocidad de la bala a ax
    sub     [bullety], ax           ; Resta la velocidad a la posicion y

    ret                             ; Retornar

moveBulletDown:                     ; Funcion encargada de mover la bala hacia abajo
    mov     ax, [gameHeight]        ; Mueve el alto del juego a ax
    add     ax, 06h                 ; Suma 6 a ax
    cmp     [bullety], ax           ; Compara la posicion y de la bala con el alto del juego
    je      clearBullet             ; Si son iguales, salta a la funcion de salida

    call    deleteBullet            ; Llama a la funcion encargada de eliminar la bala
    mov     ax, [bulletv]           ; Mueve la velocidad de la bala a ax
    add     [bullety], ax           ; Suma la velocidad a la posicion y

    ret                             ; Retornar

moveBulletRight:                    ; Funcion encargada de mover la bala hacia la derecha
    mov     ax, [gameWidht]         ; Mueve el ancho del juego a ax
    add     ax, 06h                 ; Suma 6 a ax
    cmp     [bulletx], ax           ; Compara la posicion x de la bala con el ancho del juego
    je      clearBullet             ; Si son iguales, salta a la funcion de salida

    call    deleteBullet            ; Llama a la funcion encargada de eliminar la bala
    mov     ax, [bulletv]           ; Mueve la velocidad de la bala a ax
    add     [bulletx], ax           ; Suma la velocidad a la posicion x

    ret                             ; Retornar

moveBulletLeft:                     ; Funcion encargada de mover la bala hacia la izquierda
    mov     ax, 06h                 ; Mueve 6 a ax
    cmp     [bulletx], ax           ; Compara la posicion x de la bala con 0
    je      clearBullet             ; Si son iguales, salta a la funcion de salida

    call    deleteBullet            ; Llama a la funcion encargada de eliminar la bala
    mov     ax, [bulletv]           ; Mueve la velocidad de la bala a ax
    sub     [bulletx], ax           ; Resta la velocidad a la posicion x

    ret                             ; Retornar

moveAlienUp:                        ; Funcion encargada de mover el alien hacia arriba
    mov     ax, 05h                 ; Mueve 5 a ax
    cmp     [alieny], ax            ; Compara la posicion y del alien con ax
    je      exitRoutine             ; Si son iguales, salta a la funcion de salida

    call    deleteAlien             ; Llama a la funcion encargada de eliminar el alien

    mov     ax, [alieny]            ; Mueve la posicion y del alien a ax
    sub     ax, [alienv]            ; Resta la velocidad del alien a ax
    mov     [talieny], ax           ; Almacena la nueva posicion en una variable temporal
    call    checkAlienColision      ; Llama a la funcion para detectar colisiones del alien

    cmp     ax, 00h                 ; Verifica si ax es 0
    je      exitRoutine             ; En caso de serlo, significa que la nueva posicion es invalida, y salta al salto de funcion

    mov     [alieny], ax            ; Sino, almacena ax en la posicion y del alien
    
    mov     ax, 03h                 ; Mueve 3 a ax
    mov     [alienm], ax            ; Almacena ax a la ultima direccion del alien

    ret                             ; Retornar

moveAlienDown:                      ; Funcion encargada de mover el alien hacia abajo
    mov     ax, [gameHeight]        ; Mueve el alto del juego a ax
    add     ax, 05h                 ; Suma 5 a ax
    cmp     [alieny], ax            ; Compara la posicion y del alien con el alto del juego
    je      exitRoutine             ; Si son iguales, salta a la funcion de salida

    call    deleteAlien             ; Llama a la funcion encargada de eliminar el alien

    mov     ax, [alieny]            ; Mueve la posicion y del alien a ax
    add     ax, [alienv]            ; Suma la velocidad del alien a ax
    mov     [talieny], ax           ; Almacena la nueva posicion en una variable temporal
    call    checkAlienColision      ; Llama a la funcion para detectar colisiones del alien

    cmp     ax, 00h                 ; Verifica si ax es 0
    je      exitRoutine             ; En caso de serlo, significa que la nueva posicion es invalida, y salta al salto de funcion

    mov     [alieny], ax            ; Sino, almacena ax en la posicion y del alien

    mov     ax, 01h                 ; Mueve 1 a ax
    mov     [alienm], ax            ; Almacena ax a la ultima direccion del alien

    ret                             ; Retornar

moveAlienRight:                     ; Funcion encargada de mover el alien hacia la derecha
    mov     ax, [gameWidht]         ; Mueve el ancho del juego a ax
    add     ax, 05h                 ; Suma 5 a ax
    cmp     [alienx], ax            ; Compara la posicion x del alien con el ancho del juego
    je      exitRoutine             ; Si son iguales, salta a la funcion de salida

    call    deleteAlien             ; Llama a la funcion encargada de eliminar el alien

    mov     ax, [alienx]            ; Mueve la posicion x del alien a ax
    add     ax, [alienv]            ; Suma la velocidad del alien a ax
    mov     [talienx], ax           ; Almacena la nueva posicion en una variable temporal
    call    checkAlienColision      ; Llama a la funcion para detectar colisiones del alien

    cmp     ax, 00h                 ; Verifica si ax es 0
    je      exitRoutine             ; En caso de serlo, significa que la nueva posicion es invalida, y salta al salto de funcion

    mov     [alienx], ax            ; Sino, almacena ax en la posicion x del alien

    mov     ax, 00h                 ; Mueve 0 a ax
    mov     [alienm], ax            ; Almacena ax a la ultima direccion del alien

    ret                             ; Retornar

moveAlienLeft:                      ; Funcion encargada de mover el alien hacia la izquierda
    mov     ax, 05h                 ; Mueve 5 a ax
    cmp     [alienx], ax            ; Compara la posicion x del alien con ax
    je      exitRoutine             ; Si son iguales, salta a la funcion de salida

    call    deleteAlien             ; Llama a la funcion encargada de eliminar el alien

    mov     ax, [alienx]            ; Mueve la posicion x del alien a ax
    sub     ax, [alienv]            ; Resta la velocidad del alien a ax
    mov     [talienx], ax           ; Almacena la nueva posicion en una variable temporal
    call    checkAlienColision      ; Llama a la funcion para detectar colisiones del alien

    cmp     ax, 00h                 ; Verifica si ax es 0
    je      exitRoutine             ; En caso de serlo, significa que la nueva posicion es invalida, y salta al salto de funcion

    mov     [alienx], ax            ; Sino, almacena ax en la posicion x del alien

    mov     ax, 02h                 ; Mueve 2 a ax
    mov     [alienm], ax            ; Almacena ax a la ultima direccion del alien

    ret                             ; Retornar
    
checkAlienColision:                 ; Funcion encargada de verificar las colisiones del alien
    push    ax                      ; Almacena ax en el stack
    mov     cx, [talienx]           ; Mueve la posicion temporal del alien x
    mov     dx, [talieny]           ; Mueve la posicion temporal del alien y
    mov     ah, 0dh                 ; Lee pixel
    mov     bh, 00h                 ; Pagina
    int     10h                     ; Ejecutar interrupcion

    cmp     al, [flowersc]          ; Compara el pixel leido con el color de la flor
    je      checkAlienFlowerColision ; En caso de que se cumpla, salta a la funcion de colision de flores

    pop     ax                      ; Restaura ax del stack
    ret                             ; Retornar

checkAlienFlowerColision:           ; Funcion encargada de verificar colisiones del alien con la flor
    pop     ax                      ; Restaura ax del stack
    jmp     checkAlienFlowerColisionAux ; Salta a la funcion auxiliar

checkAlienFlowerColisionAux:
    mov     cx, [level]             ; Mueve a cx el nivel actual
    cmp     cx, 01h                 ; Compara cx con 1
    je      checkAlienFlowerColisionLevel1 ; Si el nivel es 1, salta a la funcion encargada de colisiones del alien con la flor del primer nivel
    ;jmp     checkVerticalAlienFlowerColisionLevel2

checkAlienFlowerColisionLevel1:     ; Funcion encargada de verificar colisiones del alien con la flor del primer nivel
    mov     bx, flowersx1           ; Mueve a bx el puntero de las posiciones x de las flores
   
    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    add     bx, cx                  ; Suma el contador al puntero de posiciones x
    mov     dx, [bx]                ; Mueve a dx la posicion x de la flor

    cmp     dx, [talienx]           ; Compara la posicion x de la flor con la del alien
    je      checkAlienFlowerColisionLevel1Aux1 ; Salta a la funcion auxiliar 1
    jmp     checkAlienFlowerColisionLevel1Aux3 ; Salta a la funcion auxiliar 3

checkAlienFlowerColisionLevel1Aux1:
    mov     bx, flowersy1           ; Mueve a bx el puntero de las posiciones y de las flores

    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    add     bx, cx                  ; Suma el contador al puntero de posiciones y
    mov     dx, [bx]                ; Mueve a dx la posicion x de la flor

    cmp     dx, [talieny]           ; Compara la posicion y de la flor con la del alien
    je      checkAlienFlowerColisionLevel1Aux2 ; Salta a la funcion auxiliar 2
    jmp     checkAlienFlowerColisionLevel1Aux3 ; Salta a la funcion auxiliar 3

checkAlienFlowerColisionLevel1Aux2:
    mov     bx, flowersb1           ; Mueve a bx el puntero de las indicadores de activacion de las flores

    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    add     bx, cx                  ; Suma el contador al puntero de indicadores
    mov     dx, 00h                 ; Mueve a dx un 0
    mov     [bx], dx                ; Almacena dx en la posicion actual del puntero de indicadores
    mov     [flowersi], dx          ; Almacena dx en la posicion actual del contador de flores

    mov     bx, 02h                 ; Mueve a dx un 2
    add     [bulletq], bx           ; Suma dx a la cantidad de balas

    ret                             ; Retornar

checkAlienFlowerColisionLevel1Aux3:
    mov     cx, [flowersi]          ; Mueve el contador de las flores a cx
    add     cx, 02h                 ; Suma 2 a cx
    mov     [flowersi], cx          ; Mueve cx al contador de flores

    jmp     checkAlienFlowerColisionLevel1 ; Salta a la primer funcion


times   (512*2)-($-$$) db 0         ; Tamaño del codigo