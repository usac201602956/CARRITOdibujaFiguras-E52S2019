;Botones
PB0			EQU 0x40005004
PB1			EQU 0x40005008
PB2			EQU 0x40005010
PB3			EQU 0x40005020
	
;Salidas	
PB4			EQU 0x40005040
PB5      	EQU 0x40005080
PB6			EQU 0x40005100
PB7			EQU 0x40005200
Adelante	EQU 0x40005140; SUPONIENDO QUE PARA QUE SE MUEVA HACIA ADELANTE DEBEN ACTIVARSE LOS PUERTOS PB4 y PB6
Giro		EQU 0x40005240; SUPONIENDO QUE PARA DAR LA VUELTA DEBE GIRAR UNA LLANTA HACIA ADELANTE Y OTRA HACIA ATRAS. PB4 y PB7

Botones		EQU 0x4000503C
DelayLinea		EQU 1000000 ; Tiempo transcurrido en cualquier linea
Delay45grados	EQU 50000; Tiempo que le toma girar a 45°
	;LOS VALORES DE TIEMPO DEBEN ESCOGERLOS USTEDES SOLO ES DEMOSTRACIÓN
	
		
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Ruta1
		IMPORT 	Ruta2
		;IMPORT  Ruta3
		;IMPORT  Ruta4
		IMPORT Lectura
Ruta1	
	LDR R5, =0
	
	
Asignaciones
	LDR R3, =DelayLinea
	LDR R4, =Delay45grados
	LDR R6, =0
	LDR R7, =0

	B Linea
	
Linea
	SUB R3, #1; Contador
	;LDR R7, =0
	;ACTIVA LOS PINES PB4 y PB6
	LDR R6, =Adelante
	MOV R7, #0x50
	STR	R7, [R6]
	
	;Si en algun momento se presionara otro botón durante la ruta.
	
	LDR R1, =Botones      
    LDR R0, [R1]    
	CMP R0, #0x10
	BEQ Ruta1
	CMP R0, #0x20
	BEQ Ruta2
	CMP R0, #0x40
	;BEQ Ruta3
	CMP R0, #0x80
	;BEQ Ruta 4
	
	CMP R3, #0
	BEQ Cruce
	B Linea
	
Cruce
	SUB R4, #1
	LDR R7, =0
	; Activa los pines PB4 y PB7
	LDR R6, =Giro
	MOV R7, #0x90
	STR	R7, [R6]
	
	
	LDR R1, =Botones      
    LDR R0, [R1]    
	CMP R0, #0x10
	BEQ Ruta1
	CMP R0, #0x20
	BEQ Ruta2
	CMP R0, #0x40
	;BEQ Ruta3
	CMP R0, #0x80
	;BEQ Ruta 4
	
	CMP R3, #0
	BEQ SumaSegmento
	B Cruce
	
SumaSegmento
	ADD R5, #1
	CMP R5, #4
	BEQ Lectura
	B Asignaciones
	
	
		
		
		ALIGN                           
		END 