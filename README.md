# Finding-Treasure-Booteable
Tarea 2 - Introducción a los Sistemas Operativos

- Requisitos para compilar:

1. Instalar NASM: sudo apt-get install nasm

2. Instalar QEMU: sudo apt-get install qemu-system

- Dentro de la carpeta del Proyecto, puede ejecutar los siguientes comandos:

* Para compilar y ejecutar en el emulador: make qemu

* Para compilar y ejecutar en el emulador y poder debuggear: make debugServer. Además es necesario abrir otra terminal y ejecutar: make debugClient

* Para compilar y escribir a un usb conectado en sdb1 (importante verificar esto): make hardware. En caso de no funcionar utilizar el siguiente comando: make hardwareU

* Para limpiar archivos innecesarios: make clean