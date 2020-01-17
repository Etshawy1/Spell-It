
;-----------------------------------------------------------------------------
;  macro to print any number providing the hexadecimal representation 
;-----------------------------------------------------------------------------
;TO REMEBER  TIME 35 ,1
PRINTNUM MACRO BINARY, DECIMAL,POSITION_X,POSITION_Y
   LOCAL BACK 
   mov DECIMAL, '0'
   mov DECIMAL + 1, '0'
   MOV BX, 10            
   MOV SI, OFFSET DECIMAL
   ADD SI, 3
   DEC SI
   MOV AX, BINARY
   BACK:
      SUB DX, DX
      DIV BX
      OR DL, 30H
      MOV [SI], DL
      DEC SI
      CMP AX, 0
      JA BACK 
    
   MOV AH, 2
   MOV DH, POSITION_Y    ;Y POSITION FOR PRINTING
   MOV DL, POSITION_X    ;X POSITION FOR PRINTING
   INT 10H
    
   MOV AH, 9H      ;PRINT THE NUMBER
   MOV DX, OFFSET DECIMAL   
   INT 21H
    
ENDM PRINTNUM 
