          .model  tiny

.data
          titleMsg db '//============================================================================\\'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                     ___ _ __   __ _  ___ ___                               ||'
                   db '||                    / __| ''_ \ / _` |/ __/ _ \                              ||'
                   db '||                    \__ \ |_) | (_| | (_|  __/                              ||'
                   db '||                    |___/ .__/ \__,_|\___\___|                              ||'
                   db '||                        |_|         _                                       ||'
                   db '||                                   (_) __ _ _ __ ___                        ||'
                   db '||                                   | |/ _` | ''_ ` _ \                       ||'
                   db '||                                   | | (_| | | | | | |                      ||'
                   db '||                                  _/ |\__,_|_| |_| |_|                      ||'
                   db '||                                 |__/                                       ||'
                   db '||                                                                            ||'
                   db '||                       EASY    -- UNLIMITED BULLETS                         ||'
                   db '||                       NORMAL  -- STARTS WITH 20 BULLETS                    ||'
                   db '||                       VETERAN -- 5 BULLETS TO YOU, CAN YOU SURVIVE?        ||'
                   db '||                       EXIT                                                 ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '\\============================================================================//$', 0

          overMsg  db '//============================================================================\\'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                      ____                                                  ||'
                   db '||                     / ___| __ _ _ __ ___   ___                             ||'
                   db '||                    | |  _ / _` | ''_ ` _ \ / _ \                            ||'
                   db '||                    | |_| | (_| | | | | | |  __/                            ||'
                   db '||                     \____|\__,_|_| |_| |_|\___|                            ||'
                   db '||                                    ___                                     ||'
                   db '||                                   / _ \__   _____ _ __                     ||'
                   db '||                                  | | | \ \ / / _ \ ''__|                    ||'
                   db '||                                  | |_| |\ V /  __/ |                       ||'
                   db '||                                   \___/  \_/ \___|_|                       ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                            Your score:                                     ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                    Press Enter to go back to main menu                     ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '||                                                                            ||'
                   db '\\============================================================================//$', 0

          bulletLabel    db 'BULLET(S): $', 0
          scoreLabel     db 'SCORE(S): $', 0
          unlimitedLabel db '== UNLIMITED ==$', 0

          menuIndex db 15
          mode      db ?
          bullets   db ?
          randChar  db 65
          bulletPos db 80 dup(99)

          template  db 55, -110, 92, 73, -63, -71, -33, 40, -24, 80, 120, 102
                    db -57, 56, -82, -122, 112, 68, -45, -105, -43, -116, -61
                    db 90, 124, -108, 98, -37, 35, 103, -94, 57, -84, -113, -13
                    db 38, -14, -52, 113, 97, 99, -91, -68, -111, -112, -73, -19
                    db 72, -56, 71, -38, -117, -16, 49, -34, -64, -83, -80, -41
                    db 31, -49, 84, -126, 127, -78, 123, -20, 125, -102, 69, 117
                    db -55, -27, -86, -35, -65, 88, -81, -74, -114

          sequence  db 36, 17, 77, 64, 8, 31, 54, 50, 58, 52, 39, 51, 11, 56, 42
                    db 49, 13, 44, 32, 60, 33, 34, 16, 73, 48, 55, 53, 20, 57, 70
                    db 71, 59, 46, 75, 62, 28, 41, 6, 76, 74, 67, 1, 7, 35, 63, 12
                    db 78, 61, 43, 18, 72, 79, 3, 69, 19, 29, 30, 26, 15, 37, 22, 4
                    db 21, 10, 25, 9, 66, 0, 40, 23, 45, 14, 27, 24, 47, 38, 65, 2, 5, 68
          poscol    db 80 dup(0)

          seed      db  78
          playerPos db  40
          score     dw  0
          moveEnemyTimer dw  0
          moveBulletsTimer dw 0
          sequenceIndex db 0

          .code
          org     0100h
main:

          mov   ah, 00h
          mov   al, 3
          int   10h

          mov   ah, 09h
          mov   dx, offset titleMsg
          int   21h

          mov   ah, 02h
          mov   dh, menuIndex
          mov   dl, 21
          mov   bh, 0
          int   10h

          mov   ah, 09h
          mov   al, '>'
          mov   bl, 00000100b
          mov   cx, 1
          int   10h

waitTitle:
          mov   ah, 00h
          int   16h

          call  downPress
          je    downTitlePress

          call  upPress
          je    upTitlePress

          call  enterPress
          je    enterTitlePress

          jmp   waitTitle

downTitlePress:
          push  cx
          mov   cl, menuIndex
          cmp   cl, 17
          jg    returnMain
          inc   cl
          mov   menuIndex, cl
          jmp   returnMain

upTitlePress:
          push  cx
          mov   cl, menuIndex
          cmp   cl, 16
          jl    returnMain
          dec   cl
          mov   menuIndex, cl
          jmp   returnMain

enterTitlePress:
          push  cx
          mov   cl, menuIndex
          cmp   cl, 18
          je    exitProgramNode
          cmp   cl, 15
          je    easyModePrep
          cmp   cl, 16
          je    normalModePrep
          cmp   cl, 17
          je    hardModePrep

returnMain:
          jmp   main

exitProgramNode:
          jmp far ptr exitProgram

easyModePrep:
          mov   cl, 1
          mov   mode, cl
          jmp   gameplayPrep

normalModePrep:
          mov   cl, 2
          mov   mode, cl
          mov   cl, 20
          mov   bullets, cl
          jmp   gameplayPrep

hardModePrep:
          mov   cl, 3
          mov   mode, cl
          mov   cl, 5
          mov   bullets, cl
          jmp   gameplayPrep

gameplayPrep:
          mov   ah, 00h
          mov   al, 3
          int   10h

          mov   ah, 0h
          int   1ah      ; get system time

          mov   ax, cx
          xor   dx, dx
          mov   cx, 90   ; get random number by divide system time --
          div   cx       ; with 90 and use remainder as seed

          mov   al, 40
          mov   playerPos, al
          xor   ax, ax
          mov   score, ax
          mov   moveEnemyTimer, ax
          mov   moveBulletsTimer, ax

          mov   seed, dl
          mov   si, 79

prepare:
          mov   dl, template[si]
          mov   poscol[si], dl

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

printChar:       ; move cursor to desired position and print randomed character --
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

          cmp   bl, 2       ; if far from head in 3 char, print light green
          jz    printL_Green
          jc    printL_Green

          cmp   bl, 4       ; if far from head in 8 char, print green
          jc    printGreen
          jz    printGreen

          cmp   bl, 6      ; if far from head in 10 char, print gray
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

output:   ; print random character

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
          cmp   dh, 15h       ; check if we're on line index 21
          jge   tolinezero    ; if yes (means we exceed play area border) move to first line
          inc   dh            ; else just increase row
          jmp   printChar     ; go back and print random character

tolinezero:
          push  bx
          mov   si, 0

loopPrintBulletOnGameStage:
          mov   dx, si
          mov   dh, bulletPos[si]
          cmp   dh, 99
          je    nothingToDoHere
          mov   ah, 2
          mov   bh, 0
          int   10h

          mov   ah, 9
          mov   al, '|'
          mov   cx, 1
          mov   bl, 00001110b
          int   10h

nothingToDoHere:
          inc   si
          cmp   si, 80
          jne   loopPrintBulletOnGameStage

          mov   ah, 2
          mov   bh, 0
          mov   dh, 22
          mov   dl, 0
          int   10h

          mov   ah, 9
          mov   al, '+'
          mov   cx, 80
          mov   bl, 00000011b
          int   10h

          mov   ah, 2
          mov   bh, 0
          mov   dh, 23
          mov   dl, 0
          int   10h

          mov   ah, 9
          mov   al, ' '
          mov   cx, 80
          mov   bl, 0
          int   10h

          mov   ah, 2
          mov   bh, 0
          mov   dh, 23
          mov   dl, playerPos
          int   10h

          mov   ah, 9
          mov   al, 'A'
          mov   cx, 1
          mov   bl, 00000100b
          int   10h

          mov   ah, 2
          mov   bh, 0
          mov   dh, 24
          mov   dl, 1
          int   10h

          mov   ah, 9
          mov   bl, 00000111b
          mov   cx, 75
          mov   al, ' '
          int   10h

          mov   ah, 09h
          mov   dx, offset bulletLabel
          int   21h

          pop   bx
          cmp   mode, 1
          je    printUnlimited
          jmp   printBullets

printUnlimited:
          mov   ah, 09h
          mov   dx, offset unlimitedLabel
          int   21h
          jmp   printScore

printBullets:
          push  cx
          mov   ch, 0
          mov   cl, bullets
          mov   ah, 9
          mov   al, '|'
          mov   bl, 00001110b
          int   10h

          pop   cx

printScore:
          mov   ah, 2
          mov   bh, 0
          mov   dh, 24
          mov   dl, 60
          int   10h

          mov   ah, 09h
          mov   dx, offset scoreLabel
          int   21h

preparePrintScore:
          push  ax
          push  cx
          push  bx

          mov   cx, 0
          mov   ax, score
          mov   bx, 10

loopPrintScore:
          mov   dx, 0
          div   bx

          push  ax
          add   dl, '0'
          pop   ax
          push  dx
          inc   cx
          cmp   ax, 0
          jnz   loopPrintScore

loopReversePrint:
          mov   ah, 2
          pop   dx
          int   21h
          loop  loopReversePrint

          pop   bx
          pop   cx
          pop   ax

          push  cx
delayMovement:
          push  dx            ;  push current cursor position to stack

          ; wait with 16 microsecs
          mov   ah, 86h
          mov   cx, 0000h
          mov   dx, 0010h
          int   15h
          pop   dx      ;  pop current cursor position from stack back

          push  cx
          mov   cx, moveBulletsTimer
          cmp   cx, 50
          je    moveBullets
          inc   cx
          mov   moveBulletsTimer, cx
          pop   cx
          jmp   noBulletMove

moveBullets:
          mov   cx, 0
          mov   moveBulletsTimer, cx
          pop   cx
          mov   si, 0
          push  dx
          push  ax

loopMoveBullets:
          mov   dh, bulletPos[si]
          cmp   dh, 0
          je    resetBullet
          cmp   dh, 99
          je    bulletNotOnScreen
          dec   dh
          mov   dl, poscol[si]
          sub   dl, dh
          cmp   dl, 10
          jc    gotShot
          jz    gotShot

          jmp   notGotShot

gotShot:
          mov   dl, template[si]
          mov   poscol[si], dl
          mov   dl, bullets
          inc   dl
          mov   bullets, dl
          push  dx
          xor   dx, dx
          mov   dl, sequenceIndex
          inc   dl
          cmp   dl, 80
          jne   updateSequenceIndex
          mov   dl, 0
          mov   sequenceIndex, dl
          jmp   endUpdateSequenceIndex

updateSequenceIndex:
          mov   sequenceIndex, dl

endUpdateSequenceIndex:
          pop   dx
          mov   ax, score
          inc   ax
          mov   score, ax
          jmp   resetBullet

notGotShot:
          jmp   pushBack

resetBullet:
          mov   dh, 99

pushBack:
          mov   bulletPos[si], dh

bulletNotOnScreen:
          inc   si
          cmp   si, 80
          jne   loopMoveBullets
          pop   ax
          pop   dx

noBulletMove:
          push  ax
          mov   ah, 01h
          int   16h

          je    increaseTimer

          mov   ah, 00h
          int   16h

handleKeyPressInGame:
          call  leftPress
          je    leftGamePress

          call  rightPress
          je    rightGamePress

          call  spacePress
          je    spaceGamePress

          jmp   increaseTimer

leftGamePress:
          push  dx
          mov   dl, playerPos
          cmp   dl, 0
          je   endLeftGamePress
          dec   dl
          mov   playerPos, dl

endLeftGamePress:
          pop   dx
          jmp   increaseTimer

rightGamePress:
          push  dx
          mov   dl, playerPos
          cmp   dl, 79
          jge   endRightGamePress
          inc   dl
          mov   playerPos, dl

endRightGamePress:
          pop   dx
          jmp   increaseTimer

spaceGamePress:
          push  dx
          mov   dl, playerPos
          mov   dh, 0
          mov   si, dx
          mov   dh, bulletPos[si]
          cmp   dh, 99
          jne   endSpaceGamePress
          mov   dh, mode
          cmp   dh, 1
          je    shoot
          mov   dh, bullets
          cmp   dh, 0
          je    endSpaceGamePress
shoot:
          mov   dh, 21
          mov   bulletPos[si], dh
          mov   dh, bullets
          dec   dh
          mov   bullets, dh

endSpaceGamePress:
          pop   dx
          jmp   increaseTimer

increaseTimer:
          pop   ax
          mov   cx, moveEnemyTimer
          cmp   cx, 50
          je    shiftEnemy
          inc   cx
          mov   moveEnemyTimer, cx
          jmp   delayMovement

shiftEnemy:
          pop   cx

          mov   dh, 0h  ; set row to row index 0
          mov   dl, sequenceIndex

          mov   si, dx   ;initial loop variable
          mov   dl, sequence[si]
          mov   di, dx

incArrayLoop:
          mov   cx, 0
          mov   moveEnemyTimer, cx
          inc   poscol[di]      ; increase head of column #si
          cmp   poscol[di], 22  ; see if it exceed 37
          je    gameOverScreen
          jl    goPrintChar ; if not, just continue
          mov   cl, template[di]
          mov   poscol[di], cl   ; else reset it to 0
          inc   dx
          cmp   dl, 80
          jne   notexceedEighty
          mov   dl, 0
          mov   sequenceIndex, dl
          jmp   goPrintChar

notexceedEighty:
          mov   sequenceIndex, dl

goPrintChar:
          mov   dx, 0
          jmp   printChar     ; after go to line zero and increase all head --
                        ; go print like we used to do~x

gameOverScreen:
          mov   ah, 00h
          mov   al, 3
          int   10h

          mov   ah, 09h
          mov   dx, offset overMsg
          int   21h

          mov   ah, 02h
          mov   dh, 16
          mov   dl, 42
          mov   bh, 0
          int   10h

          mov   ah, 09
          mov   al, ' '
          mov   cx , 5
          mov   bh, 0
          mov   bl, 3
          int   10h

          push  ax
          push  cx
          push  bx

          mov   cx, 0
          mov   ax, score
          mov   bx, 10

loopPrintScoreOver:
          mov   dx, 0
          div   bx

          push  ax
          add   dl, '0'
          pop   ax
          push  dx
          inc   cx
          cmp   ax, 0
          jnz   loopPrintScoreOver

loopReversePrintOver:
          mov   ah, 2
          pop   dx
          int   21h
          loop  loopReversePrintOver

          pop   bx
          pop   cx
          pop   ax

waitOver:
          mov   ah, 00h
          int   16h

          call  enterPress
          je    enterOverPress

          jmp   waitOver

enterOverPress:
          jmp   main

enterPress:
          cmp   ah, 01ch
          ret

upPress:
          cmp   ah, 048h
          ret

downPress:
          cmp   ah, 050h
          ret

leftPress:
          cmp   ah, 04bh
          ret

rightPress:
          cmp   ah, 04dh
          ret

spacePress:
          cmp   ax, 03920h
          ret

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

exitProgram:
          mov   ah, 00h
          mov   al, 3
          int   10h

          ret
          end     main
