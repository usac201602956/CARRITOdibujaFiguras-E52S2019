PB0			EQU 0x40005004
PB1			EQU 0x40005008
PB2			EQU 0x40005010
PB3			EQU 0x40005020
PB4			EQU 0x40005040
PB5      	EQU 0x40005080
PB6			EQU 0x40005100
PB7			EQU 0x40005200
Botones		EQU 0x4000502A
		
		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Ruta2
		IMPORT 	Ruta1
		;IMPORT  Ruta3
		;IMPORT  Ruta4
Ruta2
;Configuraciones para la ruta2
;Pueden volver a usar los Registros del R3 en adelante, siempre inicializando todo si fuera necesario. 
		
		ALIGN                           
		END 