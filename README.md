# NonParasiticASM
A Non-Parasitic virus for educational purpose only!

## Disclosure
I do not take any responsibility for misuse of this code, for educational purposes only!

Both code and data are in one section to make the final exe smaller, you can add individual data and bss sections if you like

## Build
To build use:

    Nasm virus.asm -f obj -o virus.obj
    ALINK -o PE virus.obj
