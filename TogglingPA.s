RCC_APB2ENR EQU 0x40021018 
GPIOA_CRL	EQU 0x40010800 
GPIOA_CRH	EQU 0x40010804 
GPIOA_IDR	EQU 0x40010808 
GPIOA_ODR	EQU 0x4001080C 
SAIDA 		EQU 0x33333333
ACENDE 		EQU 0x8000
APAGA 		EQU 0x0000
	
	EXPORT __main
	
	AREA CODEGO, CODE, READONLY

__main
;CLOCK:
	LDR R0,=RCC_APB2ENR
	LDR R1,[R0]
	ORR R1,#0XFC
	STR R1, [R0]
;SAIDA:	
	LDR R0,= GPIOA_CRL
	LDR R1,= SAIDA
	STR R1, [R0]
	LDR R0,=GPIOA_CRH
	STR R1, [R0]
	
;PISCA:
pisca
	LDR R2,=GPIOA_ODR
	LDR R3,=ACENDE 
	STR R3, [R2]
	BL delay
	LDR R3,=APAGA
	STR R3, [R2]
	BL delay
	B pisca
	
	
delay 	
	LDR 	R0, = 48; R0 = 48, modify this value for different delays 
d_L1	LDR 	R1, = 250000; R1 = 250, 000 (inner loop count) 
d_L2	SUBS 	R1, R1,# 1 
	BNE	d_L2 
	SUBS 	R0, R0,# 1 
	BNE 	d_L1 
	BX	LR


