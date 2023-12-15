RCC_APB2ENR EQU 0x40021018 ;Registros
GPIOA_CRL EQU 0x40010800
GPIOA_CRH EQU 0x40010804
GPIOA_IDR EQU 0x40010808
GPIOA_ODR EQU 0x4001080C
AFIO_MAPR EQU 0x40010004
LED1 EQU 0x0001 ;leds
LED2 EQU 0x0002
LED3 EQU 0x0004
LED4 EQU 0x8000
LED5 EQU 0x0100
LED6 EQU 0x0040
LED7 EQU 0x0020
LED8 EQU 0x0800
GPIOA_HAB EQU 0x04 ;outros
AFIO_HAB EQU 0x01
JTAG_GPIO EQU 0x02000000
GPIO_SAIDA EQU 0x33333333
APAGA_LEDS EQU 0x0000

 ;Exporta o trecho de código nomeado __main.
 ;__main é usado nos outros arquivos de config.
 ;__main é o nosso programa.
	EXPORT __main

 ;Criando uma região de memória de dados na ROM.
 ;Essa região é chamada leds e define vários valores
 ;de 16-bits (DCW) para acender cada LED da placa.
 ;O endereço do primeiro valor é nomeado data.
	AREA leds, DATA, READONLY
data
	DCW LED1, LED2, LED3, LED4, LED5, LED6, LED7, LED8

 ;Criando uma região de memória de programa na ROM.
 ;Essa região é chamada exemplo e define o programa.
 ;Seu primeiro endereço é nomeado __main
	AREA exemplo, CODE, READONLY
__main
 ;Habilitando a GPIOA
	LDR R1,=RCC_APB2ENR ;R1 contém o endereço de APB2ENR.
	LDR R0,[R1] ;R0 armazena o conteúdo deAPB2ENR.
	ORR R0,R0,#GPIOA_HAB ;R0 contém o valor para habilitar GPIOA.
	STR R0,[R1] ;Salva o conteúdo de R0 em APB2ENR,
				;habilitando a GPIOA.
				;Habilitando remapeamento da JTAG
	ORR R0,R0, #AFIO_HAB ;R0 contém valor de configuração.
	STR R0,[R1] ;Salva o conteúdo de R0 em APB2ENR,
				;habilitando o remapeamento.
				;Remapeando JTAG para GPIO
	LDR R1,=AFIO_MAPR ;R1 recebe o endereço de AFIO_MAPR.
	LDR R0,=JTAG_GPIO ;R0 recebe o valor de configuração.
	STR R0,[R1] ;Salva o conteúdo de R0 em AFIO_MAPR,
				;remapeando a JTAG para GPIO.
				;Configurando a GPIOA
	LDR R1,=GPIOA_CRL ;R1 recebe o endereço de GPIOA_CRL.
	LDR R0,=GPIO_SAIDA ;R0 recebe o valor de configuração.
	STR R0,[R1] ;Salva o conteúdo de R0 em GPIOA_CRL,
				;configurando GPIOA[7:0] como saída.
	LDR R1,=GPIOA_CRH
	STR R0, [R1]

LOOP
	MOV R3, #8 ;Contador de LEDs.
	LDR R5,=GPIOA_ODR ;R5 recebe o endereço de GPIOA_ODR.
	LDR R4,=APAGA_LEDS ;R4 recebe o valor de configuração.
	STR R4,[R5] ;Salva conteúdo de R4 em GPIOA_ODR,
	;apagando os LEDs.
	BL delay ;Desvia para a sub-rotina de atraso.
	LDR R2,=data ;R2 recebe o endereço do primeiro dado.
	LDR R6,= 0x0000
lp
	LDRH R4, [R2] ;R4 recebe o valor do primeiro dado.
	ORR R4, R6, R4
	STRH R4, [R5] ;Salva o conteúdo de R4 em GPIOA_ODR,
	ORR R6, R4           
	BL delay ;Desvia para a sub-rotina de atraso.
	ADD R2, R2, #2 ;Calcula o endereço do próximo dado.

	SUBS R3, R3, #1 ;Decrementa o contador de LEDs
	BNE lp ;Desvia para o ponto lp enquanto a
	;a subtração anterior não reulta em 0.
	
	LDR R4,=APAGA_LEDS
	STRH R4, [R5]
	BL delay
	
	MOV R3, #5
	
vorta
	LDR R0,= 0xFFFF
	STR R0, [R5]
	
	BL delay
	
	LDR R0,= APAGA_LEDS
	STR R0, [R5]
	
	BL delay
	
	SUBS R3, #1
	BNE vorta
	
	MOV R3, #8
	LDR R4,= APAGA_LEDS
	STR R4,[R5] ;Salva conteúdo de R4 em GPIOA_ODR,
	;apagando os LEDs.
	BL delay ;Desvia para a sub-rotina de atraso.
	
	LDR R2,=data ;R2 recebe o endereço do primeiro dado.
	ADD R2, #14
	LDR R6,=0x0000
lp_2
	LDRH R4, [R2] ;R4 recebe o valor do primeiro dado.
	ORR R4, R6
	STRH R4, [R5] ;Salva o conteúdo de R4 em GPIOA_ODR,
	ORR R6, R4
	BL delay ;Desvia para a sub-rotina de atraso.
	SUB R2, R2, #2 ;Calcula o endereço do próximo dado.
	SUBS R3, R3, #1 ;Decrementa o contador de LEDs
	BNE lp_2 ;Desvia para o ponto lp enquanto a
	;a subtração anterior não reulta em 0.
	
	LDR R4,= APAGA_LEDS
	STRH R4, [R5]
	BL delay
	MOV R3, #5
	
vorta_2
	LDR R0,= 0xFFFF
	STR R0, [R5]
	
	BL delay
	
	LDR R0,= APAGA_LEDS
	STR R0, [R5]
	
	BL delay
	
	SUBS R3, #1
	BNE vorta_2
	

	B LOOP ;Desvia para o ponto LOOP.
	
delay
	LDR R0,= 48 ; R0 = 48, modify for different delays
d_L1 LDR R1,= 250000 ; R1 = 250, 000 (inner loop count)
d_L2 SUBS R1,R1,#1
	BNE d_L2
	SUBS R0,R0,#1
	BNE d_L1
	BX LR
	END