AREA Lab3, CODE, READONLY
EXPORT __main

__main PROC
    ; 1. Enable GPIOA Clock (RCC_AHB1ENR)
    LDR R0, =0x40023830     ; Address of RCC_AHB1ENR
    LDR R1, [R0]
    ORR R1, R1, #1          ; Set bit 0 to enable GPIOA
    STR R1, [R0]

    ; 2. Configure PA5, PA6, PA7 as Output (MODER)
    LDR R0, =0x40020000     ; GPIOA Base Address
    LDR R1, [R0]
    BIC R1, R1, #0x0000FC00 ; Clear bits for PA5-7
    ORR R1, R1, #0x00005400 ; Set bits to 01 (Output)
    STR R1, [R0]

loop
    ; Turn on PA5, PA6, PA7
    MOV R1, #0xE0           ; Binary 11100000
    STR R1, [R0, #0x14]     ; Write to ODR
    BL delay

    ; Turn off
    MOV R1, #0x00
    STR R1, [R0, #0x14]
    BL delay
    B loop

delay
    LDR R2, =0x100000       ; Delay constant
d_loop
    SUBS R2, R2, #1
    BNE d_loop
    BX LR
    ENDP
    