				.model		tiny

				.code
				org				0100h
main:
				;	set display mode to text mode
				mov		ah, 0h
				mov		al,	3h
				int		10h

				; set initial value for cursor position
				mov 	dh, 0h
				mov		dl, 0h
				mov		bh,	0h

printA:	; move cursor to desired position and print 'a'

				; move cursor
				mov 	ah,	2h
				int		10h

				; print 'a'
				mov		ah, 9h	; set to write character mode
				mov   cx, 1		; print 1 character
				mov		bl, 7h	; set attribute for character
				mov		al, 61h	; set desired character to 'a'
				int 	10h
				jmp		shiftPos

shiftPos:	; decide if now on odd-indexed row or even-indexed row
				test	dh, 1h
				jz		evenShift	; if on even-indexed, jump to evenShift

oddShift:	; shift cursor index when in odd-indexed row
				dec		dl	; decrease cursor column index (move cursor to the left)
				cmp		dl, 0	; check if cursor is still in screen
				js		newlineEven	; if cursor is not in screen, go to newline
				jmp		printA	; else continue printing 'a'

evenShift: ; shift cursor index when in even-indexed row
				inc		dl	; increase cursor column index (move cursor to the right)
				cmp		dl, 50h ; check if cursor is still in screen
				jge		newlineOdd ; if cursor is not in screen, go to newline
				jmp		printA ; else continue printing 'a'

newlineEven: ; go to new line with even-indexed
				inc		dl ; increase cursor column index (move cursor back to screen)
				inc		dh	; increase row index
				jmp		printA ; go to print 'a'

newlineOdd:	; go to new line with odd-indexed
				cmp		dh, 18h	; check if row index exceed 24
				jge		exit	; if true, terminate program
				dec		dl	; decrease cursor column index (move cursor back to screen)
				inc		dh	; increase row index
				jmp		printA ; go to print 'a'

exit:
				mov 	ah, 6h
				mov		al, 0h
				mov		bh, 7h
				mov		cx, 0h
				mov		dx, 184fh
				int 	10h

				ret
				end		main
