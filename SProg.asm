PUBLIC SOUNDPLAY

.Model LARGE 
.386
DATA5 SEGMENT PARA 'DATA'

Filename DB 'cheering.wav', 0  
Filehandle DW ?
filesize equ 29456
sounddata DB filesize dup(0)   
last_time dd 0
voc_index dw 0   ;TO KEEP TRACK OF THE PLAYED SAMPLES TO KNOW THE NEXT AUDIO SAMPLE TO PLAY 
LOADED DB 0		;FLAG TO NOT LOAD THE SOUND FILE MULTIPLE TIMES WHEN THE SOUND FUNCTION CALLED MULTIPLE TIMES

DATA5 ENDS


.Code

;-------------------------------------------------------------------------------------------------------------------------
; THE CONCEPT OF THIS CODE IS ADAPTED FROM: https://github.com/leonardo-ono/Assembly8086SBHardwareLevelDspProgrammingTest
; HE USED NASM NOT MASM SO PUTTING THE CODE TOGETHER TO MAKE IT WORK WAS NOT AN EASY TASK
;--------------------------------------------------------------------------------------------------------------------------
SOUNDPLAY PROC FAR
    
	ASSUME DS:DATA5
    MOV AX , DATA5
    MOV DS , AX
	MOV WORD PTR DS:VOC_INDEX, 0
    CALL FAR PTR SOUNDS
	MOV DS:LOADED, 1
    ; return control to operating system
    RETF
    
SOUNDPLAY ENDP
   

SOUNDS PROC FAR

	PUSHA 

	CMP LOADED, 1
	JE DONT_LOAD_SOUND
    CALL FAR PTR OPENFILE  
    CALL FAR PTR READDATA
    CALL FAR PTR CLOSEFILE

	DONT_LOAD_SOUND:
    
	           
	           
	CALL FAR PTR START_FAST_CLOCK
	CALL FAR PTR SB_RESET


SB_TURN_ON_SPEAKER:
	MOV BL, 0D1H
	CALL FAR PTR SB_WRITE_DSP

	MOV DWORD PTR DS:[last_time], 0

	.NEXT_SAMPLE:
		CALL FAR PTR CLRBUFFR ;CLEAR THE KEYBOARD BUFFER JUST IN CASE
		;{DISABLE THE PREVIOUS SAMPLE FROM THE PORT
		MOV BL, 10H
		CALL FAR PTR SB_WRITE_DSP
		;}

	.WAIT:
		;{TO SYNCHRONIZE THE SAMPLE RATE PLAYED WITH CLOCK CYCLES
		CALL FAR PTR GET_CURRENT_TIME
		CMP EAX, DS:[LAST_TIME]
		JBE .WAIT
		MOV DS:[LAST_TIME], EAX
		;}

		;{GET THE SAMPLE WHOSE TURN HAS COME TO BE PLAYED IN BL
        MOV EBX, 0
		MOV BX, WORD PTR DS:VOC_INDEX
		MOV BL, BYTE PTR DS:[SOUNDDATA + EBX]  
		CALL FAR PTR SB_WRITE_DSP
		;}
	
		INC WORD PTR DS:VOC_INDEX ;INCREMENT THE INDEX OF THE SAMPLES 
		CMP WORD PTR DS:VOC_INDEX, FILESIZE ;CHECK IF WE REACHED THE END OF THE FILE
		JB .NEXT_SAMPLE;
	
    

STOP_PLAYING:
SB_TURN_OFF_SPEAKER:
		MOV BL, 0D3H
		CALL FAR PTR SB_WRITE_DSP

	;RETURN THE CLOCK CYCLES TO THE NORMAL SPEED FOR THE REST OF THE GAME 
    CALL FAR PTR START_NORMAL_CLOCK
    
    POPA
    RETF
SOUNDS ENDP
   
;========================================================================================
;  ______ _____ _      ______   _    _          _   _ _____  _      _____ _   _  _____ 
; |  ____|_   _| |    |  ____| | |  | |   /\   | \ | |  __ \| |    |_   _| \ | |/ ____|
; | |__    | | | |    | |__    | |__| |  /  \  |  \| | |  | | |      | | |  \| | |  __ 
; |  __|   | | | |    |  __|   |  __  | / /\ \ | . ` | |  | | |      | | | . ` | | |_ |
; | |     _| |_| |____| |____  | |  | |/ ____ \| |\  | |__| | |____ _| |_| |\  | |__| |
; |_|    |_____|______|______| |_|  |_/_/    \_\_| \_|_____/|______|_____|_| \_|\_____|
;
;=========================================================================================

OPENFILE PROC FAR

    MOV AH, 3DH
    MOV AL, 0 ; READ ONLY
    LEA DX, FILENAME
    INT 21H
    MOV DS:[FILEHANDLE], AX
    RETF

OPENFILE ENDP


;------------------------------------------------------------
; TO READ THE SOUND FILE DATA AND PUT IT IN THE DATA SEGMENT
;------------------------------------------------------------


READDATA PROC FAR

    MOV AH,3FH
    MOV BX, DS:[FILEHANDLE]
    MOV CX, FILESIZE ; NUMBER OF BYTES TO READ
    LEA DX, SOUNDDATA
    INT 21H
    RETF
READDATA ENDP 

;--------------------------------------------------
; AS THE NAME IMPLIES IT CLOSES THE OPEN FILE :D
;--------------------------------------------------

CLOSEFILE PROC FAR
	MOV AH, 3EH
	MOV BX, DS:[FILEHANDLE]

	INT 21H
	RETF
CLOSEFILE ENDP 

;=============================================================================================================================
;   _____  ____  _    _ _   _ _____     __  __          _   _ _____ _____  _    _ _            _______ _____ ____  _   _  _____ 
;  / ____|/ __ \| |  | | \ | |  __ \   |  \/  |   /\   | \ | |_   _|  __ \| |  | | |        /\|__   __|_   _/ __ \| \ | |/ ____|
; | (___ | |  | | |  | |  \| | |  | |  | \  / |  /  \  |  \| | | | | |__) | |  | | |       /  \  | |    | || |  | |  \| | (___  
;  \___ \| |  | | |  | | . ` | |  | |  | |\/| | / /\ \ | . ` | | | |  ___/| |  | | |      / /\ \ | |    | || |  | | . ` |\___ \ 
;  ____) | |__| | |__| | |\  | |__| |  | |  | |/ ____ \| |\  |_| |_| |    | |__| | |____ / ____ \| |   _| || |__| | |\  |____) |
; |_____/ \____/ \____/|_| \_|_____/   |_|  |_/_/    \_\_| \_|_____|_|     \____/|______/_/    \_\_|  |_____\____/|_| \_|_____/ 
;
;=============================================================================================================================
                                                                                                                              

;-----------------------------------------------------
; I USE IT TO GET THE CLOCK CYCLES BACK TO THE NORMAL 
; SPEED FOR THE REST OF THE GAME
;-----------------------------------------------------
START_NORMAL_CLOCK PROC FAR
    CLI
    MOV AL, 36H
    OUT 43H, AL
   

    MOV AL,  040H; LOW 2AH
    OUT 40H, AL
    MOV AL, 0FCH ; HIGH 01H
    OUT 40H, AL
    STI
    RETF 
START_NORMAL_CLOCK ENDP 

;----------------------------------------------------------------------------
; ADJUST THE CLOCK SPEED TO THE SAMPLE RATE OF THE SOUND FILE WHICH IS 8000HZ
;----------------------------------------------------------------------------

    
START_FAST_CLOCK PROC FAR
    CLI
    MOV AL, 36H
    OUT 43H, AL
    
    MOV AL, 090H 
    OUT 40H, AL
    MOV AL, 00H 
    OUT 40H, AL
    STI
    RETF 
START_FAST_CLOCK ENDP			
			

SB_RESET PROC FAR
	MOV DX, 226H
	MOV AL, 1
	OUT DX, AL
		
	MOV CX, 50
	.WAIT_A_LITTLE:
		NOP
	LOOP .WAIT_A_LITTLE

	MOV DX, 226H
	MOV AL, 0
	OUT DX, AL

	MOV CX, 0
	.CHECK_READ_DATA_AVAILABLE:
		MOV DX, 22EH
		IN AL, DX
		OR AL, AL
		JNS .NEXT_TRY
		
	.READ_DATA:
		MOV DX, 22AH
		IN AL, DX
		CMP AL, 0AAH
		JNZ .ERROR
	.OK:
		MOV AX,1
		JMP .END
	.NEXT_TRY:
		LOOP .CHECK_READ_DATA_AVAILABLE
	.ERROR:
		MOV AX, 0
	.END:	
	RETF
SB_RESET ENDP    
    

;---------------------------------------------------------------
; WRITE A SOUND NOTE IN WHICH IS IN BL TO THE PORT TO BE PLAYED 
;---------------------------------------------------------------

; BL = SEND BYTE DATA
SB_WRITE_DSP PROC FAR
	MOV DX, 22CH
	.BUSY:
		IN AL, DX
		TEST AL, 10000000B
		JNZ .BUSY
	MOV AL, BL
	OUT DX, AL
	RETF
SB_WRITE_DSP ENDP
                  
;---------------------------------------------------------
; GET CURRENT SYSTEM TIME ADN PUT IT IN EAX
;---------------------------------------------------------

GET_CURRENT_TIME PROC FAR
	PUSH ES
	MOV AX, 0
	MOV ES, AX
	MOV EAX, ES:[46CH]
	POP ES
	RETF
GET_CURRENT_TIME ENDP						    

;---------------------------------------------------------------------------------------------------------------
; CLEARS KEYBOARD BUFFER
; CREDIT: https://www.daniweb.com/programming/software-development/threads/77762/how-to-clear-keyboard-buffer 
;---------------------------------------------------------------------------------------------------------------
CLRBUFFR		PROC FAR
	PUSH		AX
	PUSH		ES
	MOV		AX, 0000H
	MOV		ES, AX
	MOV		ES:[041AH], 041EH
	MOV		ES:[041CH], 041EH	; CLEARS KEYBOARD BUFFER
	POP		ES
	POP		AX
	RETF
CLRBUFFR		ENDP 


    end SOUNDPLAY                           
    
    
    
    
    
    