;Conditional LED Selection
AREA Lab4, CODE, READONLY
EXPORT __main

__main PROC
    ; 1. Enable GPIOC Clock (Bit 2 of RCC_AHB1ENR)
    LDR R0, =0x40023830
    LDR R1, [R0]
    ORR R1, R1, #0x04       ; Set bit 2
    STR R1, [R0]

    ; 2. Configure PC1, PC2 as Output and PC0 as Input (GPIOC_MODER)
    LDR R0, =0x40020800     ; GPIOC Base Address
    LDR R1, [R0]
    BIC R1, R1, #0x0000003F ; Clear bits 0-5
    ORR R1, R1, #0x00000014 ; PC1=01, PC2=01 (Output), PC0=00 (Input)
    STR R1, [R0]

main_loop
    ; 3. Read Input Data Register (IDR)
    LDR R1, [R0, #0x10]     ; Offset 0x10 for IDR
    ANDS R1, R1, #0x01      ; Check Bit 0 (PC0)
    
    BEQ led1_on             ; If PC0 is 0 (Low), jump to led1_on

led2_on                     ; Default case: PC0 is 1 (High)
    MOV R1, #0x04           ; Binary 100 (PC2 High, PC1 Low)
    STR R1, [R0, #0x14]     ; Write to ODR
    B main_loop

led1_on
    MOV R1, #0x02           ; Binary 010 (PC2 Low, PC1 High)
    STR R1, [R0, #0x14]
    B main_loop
    ENDP
