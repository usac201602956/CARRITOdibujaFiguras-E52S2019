;Puertos B0, B1, B2 y B3 como botones externos.
;Puertos B4, B5, B6 y B7 como puertos de salida.

GPIO_PORTB_DIR_R   EQU 0x40005400
GPIO_PORTB_AFSEL_R EQU 0x40005420
GPIO_PORTB_PUR_R   EQU 0x40005510
GPIO_PORTB_DEN_R   EQU 0x4000551C
GPIO_PORTB_LOCK_R  EQU 0x40005520
GPIO_PORTB_CR_R    EQU 0x40005524
GPIO_PORTB_AMSEL_R EQU 0x40005528
GPIO_PORTB_PCTL_R  EQU 0x4000552C



	
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
SYSCTL_RCGC2_GPIOF EQU 0x00000020 

PB0			EQU 0x40005004
PB1			EQU 0x40005008
PB2			EQU 0x40005010
PB3			EQU 0x40005020
PB4			EQU 0x40005040
PB5      	EQU 0x40005080
PB6			EQU 0x40005100
PB7			EQU 0x40005200
Botones		EQU 0x4000503C
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
		IMPORT Ruta1
		IMPORT Ruta2
		EXPORT Lectura
Start


Switch_Init
    LDR R1, =SYSCTL_RCGCGPIO_R         
    LDR R0, [R1]                 
    ORR R0, R0, #0x02               
    STR R0, [R1]                  
    NOP
    NOP   
;Configuración de los Botones	
    LDR R1, =GPIO_PORTB_AMSEL_R     
    LDR R0, [R1]                    
    BIC R0, #0x0F                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, #0x00F00000             
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                    
    BIC R0, #0x0F                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, #0x0F                    
    STR R0, [R1]                                 
    LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR R0, #0x0F                   
    STR R0, [R1]                   
      
;Configuración de las Salidas	  
	 LDR R1, =GPIO_PORTB_AMSEL_R     
    LDR R0, [R1]                    
    BIC R0, #0xF0                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, #0x00F00000             
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                    
    ORR R0, #0xF0                   
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, #0xF0                    
    STR R0, [R1]                                 
    LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR R0, #0xF0                   
    STR R0, [R1]     
	
	
Lectura
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
	B Lectura
	



    ALIGN                           
    END 