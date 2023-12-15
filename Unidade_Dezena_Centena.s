;testado em 22/09/2023
;Equates para deslocar o bit para o LED correto
des_0_esq EQU 11
des_1_esq EQU 4
des_2_esq EQU 4
des_3_esq EQU 5
des_4_esq EQU 11
des_5_dir EQU 3
des_6_dir EQU 5
des_7_dir EQU 7
;Máscaras para separar cada bit de um valor
bit0_mask EQU 0x01
bit1_mask EQU 0x02
bit2_mask EQU 0x04
bit3_mask EQU 0x08
bit4_mask EQU 0x10
bit5_mask EQU 0x20
bit6_mask EQU 0x40
bit7_mask EQU 0x80
;Registros de configuração da GPIOA
RCC_APB2ENR EQU 0x40021018  
GPIOA_CRL EQU 0x40010800 
GPIOA_CRH EQU 0x40010804 
GPIOA_IDR EQU 0x40010808 
GPIOA_ODR EQU 0x4001080C 
AFIO_MAPR EQU 0x40010004
GPIOA_HAB   EQU 0x04              ;outros
AFIO_HAB    EQU 0x01
JTAG_GPIO   EQU 0x02000000
GPIO_SAIDA  EQU 0x33333333
APAGA_LEDS  EQU 0x0000
ACENDE      EQU 0xFFFF	
centena EQU 0x00
dezena EQU 0x00
unidade EQU 0x00

;R9 armazena o valor a ser enviado para a GPIOA (LEDs)
	EXPORT __main
		

	AREA BCD, DATA, READONLY
bcd 
	dcb centena, dezena, unidade
	
	AREA programa, CODE, READONLY
__main

;Habilitando a GPIOA
	LDR	R1,=RCC_APB2ENR  ;R1 contém o endereço de APB2ENR.
	LDR R0,[R1]		     ;R0 armazena o conteúdo deAPB2ENR.
	ORR R0,R0,#GPIOA_HAB ;R0 contém o valor para habilitar GPIOA.
	STR R0,[R1]		     ;Salva o conteúdo de R0 em APB2ENR,
						 ;habilitando a GPIOA.
;Habilitando remapeamento da JTAG
	ORR R0,R0, #AFIO_HAB ;R0 contém valor de configuração.
	STR R0,[R1]	         ;Salva o conteúdo de R0 em APB2ENR,
						 ;habilitando o remapeamento.
;Remapeando JTAG para GPIO
	LDR	R1,=AFIO_MAPR    ;R1 recebe o endereço de AFIO_MAPR.
	LDR R0,=JTAG_GPIO    ;R0 recebe o valor de configuração.
	STR	R0,[R1]          ;Salva o conteúdo de R0 em AFIO_MAPR,
						 ;remapeando a JTAG para GPIO.
;Configurando a GPIOA	
	LDR R1,=GPIOA_CRL    ;R1 recebe o endereço de GPIOA_CRL.
	LDR R0,=GPIO_SAIDA	 ;R0 recebe o valor de configuração. 
	STR R0,[R1]		     ;Salva o conteúdo de R0 em GPIOA_CRL,
						 ;configurando GPIOA[7:0] como saída.
	LDR R1,=GPIOA_CRH    ;R1 recebe o endereço de GPIOA_CRL.
	LDR R0,=GPIO_SAIDA	 ;R0 recebe o valor de configuração. 
	STR R0,[R1]		     ;Salva o conteúdo de R0 em GPIOA_CRL,
						 ;configurando GPIOA[15:8] como saída.
						 
	LDR R2,= bcd
	LDR R4,= 0XFF
	
;Centenas:
	MOV R7, #100
	
	UDIV R5, R4, R7
	STRB R5, [R2]
	
	ADD R2, #1
	
;Dezenas:
	MOV R7, #10
	
	MUL R5, R7
	SUB R5, R4, R5
	MOV R6, R5
	UDIV R5, R5, R7
	STRB R5, [R2]
	
	ADD R2, R2, #1
	
;Unidades:
	
	MUL R5, R7
	SUB R5, R6, R5
	
	STRB R5, [R2]
	
	MOV R6, #3 

;carrega em R8 o valor a ser exibido nos LEDs
vorta
	MOV R1, #0
	MOV R9, #0
	LDR R2,=bcd
	LDRB R8, [R2], #1
	
;calculando bit 0 e enviando ao LED 8
	AND R1, R8, #bit0_mask
	ORR R9, R1, LSL #des_0_esq
	
;calculando bit 1 e enviando ao LED7
	AND R1, R8, #bit1_mask
	ORR R9, R1, LSL #des_1_esq 

;calculando bit 2 e enviando ao LED6
	AND R1, R8, #bit2_mask
	ORR R9, R1, LSL #des_2_esq

;calculando bit 3 e enviando ao LED5
	AND R1, R8, #bit3_mask
	ORR R9, R1, LSL #des_3_esq

;calculando bit 4 e enviando ao LED4
	AND R1, R8, #bit4_mask
	ORR R9, R1, LSL #des_4_esq

;calculando bit 5 e enviando ao LED3
	AND R1, R8, #bit5_mask
	ORR R9, R1, LSR #des_5_dir

;calculando bit 6 e enviando ao LED2
	AND R1, R8, #bit6_mask
	ORR R9, R1, LSR #des_6_dir

;calculando bit 7 e enviando ao LED1
	AND R1, R8, #bit7_mask
	ORR R9, R1, LSR #des_7_dir
	

;enviando o valor de R9 para os LEDs
	LDR  R0, =GPIOA_ODR
	;LDR  R3, =ACENDE
	;STRH R3, [R0] 
	STRH R9, [R0]
	SUBS R6, #1
	BL delay
	BNE vorta


delay
	LDR R0,= 48         ; R0 = 48, modify for different delays
d_L1	LDR R1,= 250000	; R1 = 250, 000 (inner loop count)
d_L2	SUBS R1,R1,#1		
	BNE	d_L2			
	SUBS R0,R0,#1
	BNE d_L1
	BX	LR	
	END

