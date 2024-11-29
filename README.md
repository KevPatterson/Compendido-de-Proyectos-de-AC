# Proyectos de Arquitectura de Computadoras
Este repositorio contiene una colección de proyectos desarrollados en lenguaje ensamblador utilizando **FASMW** y simulados en **QEMU**. Cada proyecto explora conceptos clave de arquitectura de computadoras, como controladores, gráficos y simulaciones interactivas.

## Contenido
- [Piano Digital]
- [Barra de Progreso Multicolor]
- [Simulación de Tanque de Agua]
- [Movimiento de Reina de Ajedrez]
- Entre otros proyectos de AC que hice como estudiante en Ciberseguridad

## Herramientas Utilizadas
- **FASMW**: Ensamblador ligero para escribir y compilar código.
- **QEMU**: Emulador y virtualizador para probar los binarios generados.

## Requisitos
1. Descargar e instalar FASMW:
   - [Sitio oficial de Flat Assembler](https://flatassembler.net/)
2. Descargar e instalar QEMU:
   - [Sitio oficial de QEMU](https://www.qemu.org/)

## Instrucciones
1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/KevPatterson/Compendido-de-Proyectos-de-AC.git
   cd Compendido-de-Proyectos-de-AC

   
## Instrucciones de Uso
1. Abre dentro de cualquier carpeta de proyecto el archivo .asm (Ejemplo: `piano.asm`) en FASMW.
2. Compila el archivo para generar el binario:
   - Opción: `Save as binary` (Guardar como binario).
   - Guardar el archivo como `piano.img`. (Nota: Algunas carpetas ya han sido compiladas por lo que ya contienen este archivo)
3. Ejecuta el binario en QEMU:
   ```bash
   qemu-system-i386 -fda piano.img
