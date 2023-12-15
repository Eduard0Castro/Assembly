	EXPORT __main
		
	AREA dados, data, READONLY
		
V1 dcb 0x10, 0x20, 0x30, 0x40, 0x50
CONT dcb 5

	AREA dados2, data, READWRITE
V2 dcb 0x0, 0x0, 0x0, 0x0, 0x0
V3 dcd 0xFF, 0xFF, 0xFF, 0xFF, 0xFF


	AREA codego, code, READONLY
		
__main

	LDR R0,= V1
	LDR R1,= V2
	LDR R2,= V3
	LDR R3,= CONT
	LDRB R8, [R3]
	
manu
	LDRB R4, [R0], #1
	STRB R4, [R1], #1
	ADD R5, R4, R4
	STR R5, [R2], #4
	SUBS R8, #1
	BNE manu
	
here B here

	END