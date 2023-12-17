
	EXPORT __main
		
	AREA fonte, data, readonly
		
source dcb "Esta é a string de origem",0

	AREA destino, data, readwrite
	
destiny space 80
	
	AREA CODEGO, CODE, READONLY
		
__main



	LDR R0,= source
	LDR R1,= destiny
	
	MOV R2, #0

MANUEL

	LDRB R4, [R0, R2]
	
	CMP R4, #0
	BEQ FOIPROCEU
	
	ADD R2, #1
	
	B MANUEL
	
FOIPROCEU

	MOV R3, R2
	
	
AMERICANA

	SUB R2, #1
	LDRB R4, [R0, R2]
	STRB R4, [R1], #1
	SUBS R3, #1
	BNE AMERICANA
	
	
HERE B HERE
	
