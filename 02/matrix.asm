          .model  tiny

.data
          randChar  db   33

          .code
          org     0100h

main:
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

  				; print random character
  				mov		ah, 9h	; set to write character mode
  				mov   cx, 1		; print 1 character
  				mov		bl, 00000000b	; set attribute for character
  				mov		al, randChar	; set desired character the one that we randomed
  				int 	10h

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
          jmp printA

tolinezero:
          ;	push current cursor position to stack
          push	dx

          ; wait with 10000 microsecs
          mov		ah, 86h
          mov		cx, 0001h
          mov		dx, 41248
          int		15h

          ;	pop current cursor position from stack
          pop		dx

          mov   dh, 0h
          jmp   printA



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


exit:
          ret
          end     main
