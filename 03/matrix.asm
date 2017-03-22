          .model  tiny

.data
          randChar  db   93       ; variable of randomed character
          poscol    db  80 dup(0) ; array to keep head position of matrix --
                                  ; line in each column
          seed      db  ?         ; seed var use as random

          .code
          org     0100h

main:
          mov   ah, 0h
          int   1ah      ; get system time

          mov   ax, dx
          xor   dx, dx
          mov   cx, 90   ; get random number by divide system time --
          div   cx       ; with 90 and use remainder as seed

          mov   seed, dl
          mov   si, 79


prepare:                          ; loop through poscol and generate pseudo --
          mov   dl, seed          ; random number
          mov   poscol[si], dl

          ; using pseudo random number generator
          ; random number with equation seed = (5 * seed + 7) % 37

          mov   dl, 5        ; multipiler
          mov   al, seed
          mul   dl            ; ax = al * dl
          add   ax, 7
          mov   dl, 37        ; divider
          div   dl            ; remainder = ax % dl
          mov   seed, ah

          dec   si
          cmp   si, 0
          jge   prepare

          ;  set display mode to text mode
          mov   ah, 0h
          mov   al, 3h
          int   10h

          ; set initial value for cursor position
          mov   dh, 0h  ;  row variable
          mov   dl, 0h  ; column variable
          mov   bh, 0h

printChar:  ; move cursor to desired position and print randomed character --
            ; with color releate to cursor position and head of matrix line --
            ; position

          ; move cursor
          mov   ah,  2h
          int    10h

          push  dx     ; use dl (column) as index subscript --
          mov   dh, 0  ; to see if current cursor's row should --
          mov   si, dx ; print coloured character or not
          pop   dx

          mov   bl, poscol[si]
          sub   bl, dh      ; if (current row - head position of matrix line)
          cmp   bl, 1       ; is less than or equal 1 then we should print white
          jc    printWhite
          jz    printWhite

          cmp   bl, 3       ; if far from head in 3 char, print light green
          jz    printL_Green
          jc    printL_Green

          cmp   bl, 8       ; if far from head in 8 char, print green
          jc    printGreen
          jz    printGreen

          cmp   bl, 10      ; if far from head in 10 char, print gray
          jc    printGray
          jz    printGray

          jmp   printBlack  ; if not in range, print black char

printBlack:
          mov   bl, 00000000b  ; set attribute black color for character
          jmp   output

printWhite:
          mov   bl, 00000111b  ; set attribute white color for character
          jmp   output

printL_Green:
          mov   bl, 00001010b  ; set attribute light green color for character
          jmp   output

printGreen:
          mov   bl, 00000010b  ; set attribute green color for character
          jmp   output

printGray:
          mov   bl, 00001000b  ; set attribute gray color for character

output:
          ; print random character
          mov   ah, 9h        ; set to write character mode
          mov   cx, 1         ; print 1 character
          mov   al, randChar  ; set desired character the one that we randomed
          int   10h

          call  randNewChar   ; random new character

          inc    dl           ; increase cursor column index (move cursor to the right)
          cmp    dl, 50h      ; check if cursor is still in screen
          jge    newline      ; if cursor is not in screen, go to newline
          jmp    printChar    ; else continue printing random character

newline:
          mov   dl, 0h        ; move cursor to left edge of screen
          cmp   dh, 18h       ; check if we're on line index 24
          jge   tolinezero    ; if yes (means we exceed screen border) move to first line
          inc   dh            ; else just increase row
          jmp   printChar     ; go back and print random character

tolinezero:
          push  dx            ;  push current cursor position to stack

          ; wait with 45000 microsecs
          mov   ah, 86h
          mov   cx, 0000h
          mov   dx, 0AFC8h
          int   15h

          pop   dx      ;  pop current cursor position from stack back
          mov   dh, 0h  ; set row to row index 0

          mov   si, 0   ;initial loop variable

incArrayLoop:
          inc   poscol[si]      ; increase head of column #si
          cmp   poscol[si], 37  ; see if it exceed 37
          jl    notExceedScreen ; if not, just continue
          mov   poscol[si], 0   ; else reset it to 0

notExceedScreen:
          inc   si            ; increase loop var
          cmp   si, 80        ; if loop var exceed 80 then break
          jne   incArrayLoop  ; else just contiue loop

          jmp   printChar     ; after go to line zero and increase all head --
                              ; go print like we used to do~



randNewChar:  ; using pseudo random number generator
              ; random character with equation (32*seed+4) % 93
          push  ax
          push  dx

          mov   dl, 32        ; multipiler
          mov   al, randChar
          mul   dl            ; ax = al * dl
          add   ax, 4
          mov   dl, 93        ; divider by 93 (126-33)
          div   dl            ; remainder = ax % dl
          mov   randChar, ah
          add   randChar, 33  ; make it back in range

          pop   dx
          pop   ax
          ret


exit:
          ret
          end     main
