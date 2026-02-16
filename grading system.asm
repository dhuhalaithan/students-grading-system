org 0x0100

jmp start

; -------------------------
; Messages
; -------------------------
msg1 db 10, 'Enter marks (0-100) or Q to quit: $'
msg2 db 10, 'Grade: $'
msgErr db 10, 'Score should be out of 100$'
line db 10, '$'

; -------------------------
; Input buffer (DOS 0Ah)
; -------------------------
buffer:
    db 4
    db 0
    db 0, 0, 0

; -------------------------
; Grade strings
; -------------------------
gradeFstr     db 'F$'
gradeDstr     db 'D$'
gradeDplusstr db 'D+$'
gradeCstr     db 'C$'
gradeCplusstr db 'C+$'
gradeBstr     db 'B$'
gradeBplusstr db 'B+$'
gradeAstr     db 'A$'
gradeAplusstr db 'A+$'

; =========================
; Program start
; =========================
start:
main_loop:

    ; Prompt
    mov dx, msg1
    mov ah, 09h
    int 21h

    ; Read input
    mov dx, buffer
    mov ah, 0Ah
    int 21h

    ; Check for Q/q
    mov al, [buffer+2]
    cmp al, 'Q'
    je exit_program
    cmp al, 'q'
    je exit_program

    ; -------------------------
    ; Convert to number
    ; -------------------------
    xor cx, cx
    xor si, si
    mov bl, [buffer+1]     ; length

convert_loop:
    cmp si, bx
    je done_convert

    mov al, [buffer+2+si]
    sub al, '0'
    xor ah, ah

    ; CX = CX * 10
    mov dx, cx
    shl cx, 1
    shl cx, 1
    shl cx, 1
    add cx, dx
    add cx, dx

    add cx, ax

    inc si
    jmp convert_loop

done_convert:

    ; -------------------------
    ; CHECK IF >100
    ; -------------------------
    cmp cx, 100
    jle show_grade         ; <=100 is fine

    ; Print error message
    mov dx, msgErr
    mov ah, 09h
    int 21h

    jmp main_loop          ; ask again

show_grade:

    mov dx, msg2
    mov ah, 09h
    int 21h

    ; Grade decision
    cmp cx, 95
    jge gradeAplus
    cmp cx, 90
    jge gradeA
    cmp cx, 85
    jge gradeBplus
    cmp cx, 80
    jge gradeB
    cmp cx, 75
    jge gradeCplus
    cmp cx, 70
    jge gradeC
    cmp cx, 65
    jge gradeDplus
    cmp cx, 60
    jge gradeD
    jmp gradeF

gradeF:
    mov dx, gradeFstr
    jmp print_grade
gradeD:
    mov dx, gradeDstr
    jmp print_grade
gradeDplus:
    mov dx, gradeDplusstr
    jmp print_grade
gradeC:
    mov dx, gradeCstr
    jmp print_grade
gradeCplus:
    mov dx, gradeCplusstr
    jmp print_grade
gradeB:
    mov dx, gradeBstr
    jmp print_grade
gradeBplus:
    mov dx, gradeBplusstr
    jmp print_grade
gradeA:
    mov dx, gradeAstr
    jmp print_grade
gradeAplus:
    mov dx, gradeAplusstr

print_grade:
    mov ah, 09h
    int 21h

    jmp main_loop

; -------------------------
; Exit
; -------------------------
exit_program:
    mov ax, 4C00h
    int 21h