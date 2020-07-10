GPIO_PORTB_AMSEL_R          EQU 0x40005528; 
GPIO_PORTB_PCTL_R           EQU 0x4000552C;
GPIO_PORTB_DIR_R            EQU 0x40005400;
GPIO_PORTB_AFSEL_R          EQU 0x40005420;
GPIO_PORTB_DEN_R            EQU 0x4000551C;

GPIO_PORTD_DIR_R   EQU 0x40007400
GPIO_PORTD_AFSEL_R EQU 0x40007420
GPIO_PORTD_DEN_R   EQU 0x4000751C
GPIO_PORTD_AMSEL_R EQU 0x40007528
GPIO_PORTD_PCTL_R  EQU 0x4000752C
	
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
SYSCTL_RCGC2_GPIOD EQU 0x00000008 
SYSCTL_RCGC2_GPIOB EQU 0x00000002 

PB0	EQU 0x40005004
PB1 EQU 0x40005008
PB2 EQU 0x40005010
PB3 EQU 0x40005020

SWITCH    EQU 0x400053FC	
SW1       EQU 0x01
SW2       EQU 0x02
SW3       EQU 0x04
SW4       EQU 0x08
	
PD0       EQU 0x40007004
PD1       EQU 0x40007008
PD2       EQU 0x40007010
PD3       EQU 0x40007020
LEDS      EQU 0x400073FC
CONSTANTE		   EQU 5000000
	
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start


Switch_Init
    LDR R1, =SYSCTL_RCGCGPIO_R         
    LDR R0, [R1]                 
    ORR R0, R0, #0x02               
    STR R0, [R1]                  
    NOP
    NOP                                        
    LDR R1, =GPIO_PORTB_AMSEL_R     
    LDR R0, [R1]                    
    BIC R0, #(SW1+SW2+SW3+SW4)                  
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      
    LDR R0, [R1]                    
    BIC R0, #0x00F00000             
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R      
    LDR R0, [R1]                    
    BIC R0, #(SW1+SW2+SW3+SW4)                  
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, #(SW1+SW2+SW3+SW4)                      
    STR R0, [R1]                                 
    LDR R1, =GPIO_PORTB_DEN_R       
    LDR R0, [R1]                    
    ORR R0, #(SW1+SW2+SW3+SW4)                 
    STR R0, [R1]                   
      
	LDR R1, =SYSCTL_RCGCGPIO_R         
    LDR R0, [R1]                 
    ORR R0, R0, #0x08               
    STR R0, [R1]                  
    NOP
    NOP  

	LDR R1, =GPIO_PORTD_DIR_R       
    LDR R0, [R1]                   
    ORR R0, R0, #(0x01+0x02+0x04+0x08)   
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTD_AFSEL_R     
    LDR R0, [R1]                    
    BIC R0, R0, #(0x01+0x02+0x04+0x08)   
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTD_DEN_R       
    LDR R0, [R1]                    
    ORR R0, R0, #(0x01+0x02+0x04+0x08)   
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTD_PCTL_R      
    LDR R0, [R1]                    
        
    BIC R0, R0, #0x0000F000         
    STR R0, [R1]                    
    
    LDR R1, =GPIO_PORTD_AMSEL_R     
    MOV R0, #0                     
    STR R0, [R1]                   
    LDR R4, =LEDS                  
    MOV R5, #0x01                    
    MOV R6, #0x02                   
    MOV R7, #0x03                 
    MOV R8, #0x04                      
    MOV R9, #0x00      
	
Lectura
    LDR R10, =CONSTANTE
    MOV R11, #0x00    
    MOV R2, #0x00      
    MOV R3, #0x00      
    MOV R12, #0x00      

    LDR R1, =SWITCH      
    LDR R0, [R1]      

loop
   ; BL 	Switch_Input
    CMP R0, #0x01                  
    BEQ.W Rutina1   
    CMP R0, #0x02                  
    BEQ.W Rutina2 
    CMP R0, #0x04                  
    BEQ.W Rutina3 
    CMP R0, #0x08                  
    BEQ.W Rutina4
	
    CMP R0, #0x00                   
    BEQ.W Apagado                              
    B   Lectura

SelectRutina
    CMP R0, #0x01 
    BEQ.W AdelanteR1
	
	CMP R0, #0x02 
    LDR R10, =2000000
    BEQ.W AdelanteR2
	
	CMP R0, #0x04
    LDR R10, =2000000
    BEQ.W AdelanteR3
	
	CMP R0, #0x08 
    BEQ.W AdelanteR4
	
	B Lectura
	
;_____________________________________RUTINA 1_______________________________________
Rutina1
    MOV R0, #0x01   	
	B DelayInicio
AdelanteR1
	ADD R2, #1
	CMP R2, #0x05                   
    BEQ.W Lectura
    MOV R1, #0x05
    MOV R11, #0x00        	
	STR R1, [R4] 
    LDR R10, =2000000		
	B DelayADR1
DelayADR1
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W IzquierdaR1
	B	DelayADR1
IzquierdaR1
    MOV R1, #0x09
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =891000	
	B DelayIZR1
DelayIZR1
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR1
	B	DelayIZR1
;_____________________________________RUTINA 2______________________________________
Rutina2
    MOV R0, #0x02   	
	B DelayInicio
AdelanteR2
    MOV R1, #0x05
    MOV R11, #0x00        	
	STR R1, [R4]  
	LDR R10, =1800000			
	B DelayADR2
DelayADR2
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W DerechaR2
	B	DelayADR2
DerechaR2
	CMP  R3, #0x01
    BEQ.W IzquierdaR2


	CMP R2, #0x02                   
    BEQ.W IzquierdaR2
	ADD R2, #1
	
    MOV R1, #0x06
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =1070000	
	B DelayDERR2	
DelayDERR2
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR2
	B	DelayDERR2
IzquierdaR2
	CMP R2, #0x04                   
    BEQ.W Lectura
	ADD R2, #1
	
    MOV R1, #0x09
    MOV R3, #0x01
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =910000	
	B DelayIZR2
DelayIZR2
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR2
	B	DelayIZR2	
;_____________________________________RUTINA 3______________________________________

Rutina3
    MOV R0, #0x04  	
	B DelayInicio

AdelanteR3

    ADD R3, #1

    MOV R1, #0x05
    MOV R11, #0x00        	
	STR R1, [R4]  
	LDR R10, =1900000			
	B DelayADR3
	
DelayADR3
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W IzquierdaR3
	B	DelayADR3	
	
IzquierdaR3


	
	CMP R2, #0x04                
    BEQ.W VueltaR3
	
	CMP R2, #0x01                   
    BEQ.W DerechaR3
	ADD R2, #1
	
    MOV R1, #0x09
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =1032000	
	B DelayIZR3

DelayIZR3
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR3
	B	DelayIZR3		
	
	
DerechaR3


	CMP R3, #0x05 
	MOV R2, #0x00
    BEQ.W IzquierdaR3

	MOV R2, #0x04
    MOV R1, #0x06
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =1028000	
	B DelayDERR3	
	
DelayDERR3
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR3
	B	DelayDERR3	
	
VueltaR3
	CMP R12, #0x02
    BEQ.W Lectura
	

	
	
	
	ADD R12, #1

    CMP R12, #0x02
    MOV R1, #0x06
	MOV R2, #0x00
    MOV R11, #0x00        	
	STR R1, [R4]  
	LDR R10, =1780000		
    BEQ.W DelayVR3


    MOV R1, #0x06
	MOV R2, #0x00
    MOV R11, #0x00        	
	STR R1, [R4]  
	LDR R10, =1795000			
	B DelayVR3
	
DelayVR3
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR3
	B	DelayVR3		
;_____________________________________RUTINA 4______________________________________
Rutina4
    MOV R0, #0x08  	
	B DelayInicio

AdelanteR4
    MOV R1, #0x05
    MOV R11, #0x00        	
	STR R1, [R4] 
    LDR R10, =2700000		
	B DelayADR4
	
DelayADR4
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W IzquierdaR4
	B	DelayADR4
	
IzquierdaR4
	CMP R3, #0x02               
    BEQ.W CirculoIZ
	ADD R2, #1
	CMP R2, #0x03               
    BEQ.W VueltaR4
    MOV R1, #0x09
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =1080000	
	B DelayIZR4
	
DelayIZR4
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR4
	B	DelayIZR4
	
VueltaR4
    MOV R3, #0x02
    MOV R1, #0x09
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =1250000	
	B DelayVueltaR4
	
DelayVueltaR4
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W AdelanteR4
	B	DelayVueltaR4	
	
CirculoIZ
	ADD R12, #1
	CMP R12, #0x0E              
    BEQ.W Lectura

    MOV R1, #0x04
    MOV R11, #0x00        	
	STR R1, [R4]  
    LDR R10, =700000	
	B DelayCirculoIZ
	
DelayCirculoIZ
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W CirculoR
	B	DelayCirculoIZ	
	
CirculoR
    MOV R1, #0x05
    MOV R11, #0x00        	
	STR R1, [R4] 
    LDR R10, =300000		
	B DelayCirculoR
	
DelayCirculoR
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W CirculoIZ
	B	DelayCirculoR	
	
;________________________________________________________________________________________
Apagado
    STR R9, [R4]                    
    B   Lectura
	
DelayInicio	
	ADD R11, #1
	NOP
	NOP
	NOP
	NOP
	CMP R10, R11
    BEQ.W SelectRutina
	B   DelayInicio

	
    ALIGN                           
    END 