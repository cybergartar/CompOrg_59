          .model  tiny

.data
          randChar  db   93
          poscol    db  80 dup(0)
          seed      db  ?

          .code
          org     0100h

main:
          mov   ah, 0h
          int   1ah

          mov   ax, dx
          xor   dx, dx
          mov   cx, 90
          div   cx

          mov   seed, dl
          mov   si, 79

prepare:
          mov   dl, seed
          mov   poscol[si], dl
          nop

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

          ;	set display mode to text mode
          mov		ah, 0h
          mov		al,	3h
          int		10h

          ; set initial value for cursor position
  				mov 	dh, 0h	;	row variable
  				mov		dl, 0h	; column variable
  				mov		bh,	0h

printChar:	  ; move cursor to desired position and print 'a'

  				; move cursor
  				mov 	ah,	2h
  				int		10h

          push  dx
          mov   dh, 0
          mov   si, dx
          pop   dx

          mov   bl, poscol[si]
          sub   bl, dh
          cmp   bl, 1
          jc    printWhite
          jz    printWhite

          cmp   bl, 3
          jz    printL_Green
          jc    printL_Green

          cmp   bl, 8
          jc    printGreen
          jz    printGreen

          cmp   bl, 10
          jc    printGray
          jz    printGray

          jmp   printBlack



          jmp   printWhite
printBlack:
          mov		bl, 00000000b	; set attribute for character
          jmp   output

printWhite:
          mov		bl, 00000111b	; set attribute for character
          jmp   output

printL_Green:
          mov   bl, 00001010b
          jmp   output

printGreen:
          mov   bl, 00000010b
          jmp   output

printGray:
          mov   bl, 00001000b

output:
          ; print random character
  				mov		ah, 9h	; set to write character mode
  				mov   cx, 1		; print 1 character
  				mov		al, randChar	; set desired character the one that we randomed
  				int 	10h
          jmp   nothingToDoHere

nothingToDoHere:
          nop
          call  incRand

          inc		dl	; increase cursor column index (move cursor to the right)
  				cmp		dl, 50h ; check if cursor is still in screen
  				jge		newline ; if cursor is not in screen, go to newline
  				jmp		printChar ; else continue printing random character

newline:
          mov   dl, 0h
          cmp   dh, 18h
          jge   tolinezero
          inc   dh
          jmp printChar

tolinezero:
          ;	push current cursor position to stack
          push	dx

          ; wait with 10000 microsecs
          mov		ah, 86h
          mov		cx, 0000h
          mov		dx, 0AFC8h
          int		15h

          ;	pop current cursor position from stack
          pop		dx
          mov   dh, 0h

          mov   si, 0

incArrayLoop:
          inc   poscol[si]
          cmp   poscol[si], 37
          jl   nothingJa
          mov   poscol[si], 0

nothingJa:
          inc   si
          cmp   si, 80
          jne   incArrayLoop

            ; inc   poscol
            ; cmp   poscol, 35
            ; jl   nothingJa
            ; mov   poscol, 0

; nothingJa:
            jmp   printChar



incRand:  ; (32*seed+4) % 93
          push  ax
          push  dx

          mov   dl, 32        ; multipiler
          mov   al, randChar
          mul   dl            ; ax = al * dl
          add   ax, 4
          mov   dl, 93        ; divider
          div   dl            ; remainder = ax % dl
          mov   randChar, ah
          add   randChar, 33  ; make it back in range

          pop   dx
          pop   ax
          ret


exit:
          ret
          end     main
