;-----------------------------------------------------------------------------
;  MACRO TO GET RANDOM NUMBER WITHIN A PROVIDED RANGE 
;-----------------------------------------------------------------------------
RANDOMIZE MACRO LOWER, UPPER, NUMBER, SEED 
LOCAL SET, NODIVISION
   PUSH     AX
   PUSH     BX
   PUSH     CX
   PUSH     DX

   MOV     AX, 25173          ; LCG MULTIPLIER 
   MUL     WORD PTR SEED      ;DX:AX = LCG MULTIPLIER * SEED
   ADD     AX, 13849          ; ADD LCG INCREMENT VALUE
   ; MODULO 65536, AX = (MULTIPLIER*SEED+INCREMENT) MOD 65536
   CMP     SEED, AX
   JNE     SET
   MOV     AH, 0
   INT     1AH
   MOV     SEED, DX    ; SEED WITH THE SYSTEM TIME
   
   SET:
   MOV     SEED, AX          ; UPDATE SEED = RETURN VALUE

   SUB      DX, DX
   MOV      CX, UPPER
   INC      CX
   SUB      CX, LOWER 
   CMP CX, 0 
   JE NODIVISION
   DIV      CX     ;THIS DIVIDES AX/CX AND THE REMAINDER IS AT DX(NUMBER WITHIN RANGE OF THE SUBTRACTION UPPER - LOWER)
   NODIVISION:
   ADD      DX, LOWER
   MOV      NUMBER, DX

   POP      DX
   POP      CX
   POP      BX
   POP      AX
ENDM RANDOMIZE