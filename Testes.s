centena EQU 0x0000
dezena EQU 0x0000
unidade EQU 0x0000

	AREA BCD, DATA, READONLY
bcd 
	dcb centena, dezena, unidade


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