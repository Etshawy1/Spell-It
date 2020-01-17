;===============================================================
; AUTHOR: Muhammad Ahmad Hesham Mahmoud
; DATE: 17/1/2020
;===============================================================

EXTRN DATA : BYTE

EXTRN SOUND: FAR

INCLUDE RANDOM.INC

.368
.MODEL   LARGE
;------------------------------------------------------
.STACK 1024   ;1024 BYTES FOR STACK      
;------------------------------------------------------                    
.DATA             

.CODE                                        
MAIN  PROC FAR        
   MOV     AX,@DATA   
   MOV     DS,AX        
MAIN ENDP
;---------------------------------------

END MAIN 