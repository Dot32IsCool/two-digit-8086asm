.MODEL SMALL            ; Used as our program's code/data is smaller than 64kb
.STACK 100h             ; Allocates 256 bytes (100h in hex) for the stack

.DATA                   ; Variables begin here
num DW 32               ; We initialise num to 32, with the width of 2 bytes
newline DB 13,10,'$'    ; Characters 13 and 10 result in a new line

.CODE                   ; Code begins here
MAIN PROC               ; Begin the main procedure
    
    MOV AX, @DATA       ; In order to use our variables, we must initialise
    MOV DS, AX          ; the Data Segment. 

    PUSH num            ; Push the 2 digit number onto the stack
    CALL PRINTNUM       ; Print the number we pushed to the stack

    MOV AH, 4Ch         ; The value "4Ch" in the AH register signifies to the
    INT 21h             ; interupt request that we would like to exit DOS
MAIN ENDP               ; End the main procedure

PRINTNUM PROC
    POP DX              ; Pop the return address (IP) from the stack into DX
    POP AX              ; Pop the 2 digit number from the stack into AX
    PUSH DX             ; Push the return address back onto the stack

    MOV BL, 10          ; We move 10 into BL, so that we can divide AX by 10
    DIV BL              ; Dividig a 2 digit number by 10 will output the left 
                        ; digit (quotient) and right digit (remainder) into 
                        ; AL and AH respectively

    ADD AL, 48          ; Adding 48 to a number turns it into the ASCII
    ADD AH, 48          ; representation of that number. Here we are adding
                        ; 48 to both AL and AH to transform both digits

    MOV BX, AX          ; We use BX as a temporary place to store AX while we 
                        ; use AH for interupt requests.

    MOV DL, BL          ; We move the left digit into DL to be displayed
    MOV AH, 2           ; "2" signifies to the interupt request that we want
    INT 21H             ; to display a single character from DL.

    MOV DL, BH          ; We move the right digit into DL to be displayed
    MOV AH, 2           ; As before, we are asking to display a single
    INT 21H             ; character. We then call the interupt request.

    RET                 ; Return from the procedure to the address pointer
PRINTNUM ENDP
END MAIN