5 SC=0
6 XX=0
7 T=0
10 CLS(0)
20 FORX=5TO15
30 SET(X,15,4):NEXT
40 FORX=4TO16:SET(X,16,4):NEXT
50 FORX=4TO20:SET(X,17,4):SET(X,18,4):NEXT
60 FORX=4TO16:SET(X,19,4):NEXT
70 FORX=4TO20:SET(X,20,4):SET(X,21,4):NEXT
75 RESET(20,21)
76 RESET(20,17)
80 FORX=4TO16:SET(X,22,4):NEXT
90 FORX=5TO15:SET(X,23,4):NEXT
100 FORX=4TO15:SET(X,24,4):NEXT
110 FORX=3TO15:SET(X,25,4):NEXT
120 FORX=2TO18:SET(X,26,4):NEXT
130 FORX=1TO15:SET(X,27,4):NEXT
140 FORX=0TO15:SET(X,28,4):NEXT
150 FORX=0TO15:FORY=29TO31
160 SET(X,Y,4):NEXTY,X
170 SET(19,25,4):SET(19,27,4)
180 RESET(14,17)
185 IFXX=13THENRETURN
190 FORX=0TO63:SET(X,0,4):SET(X,31,4):NEXT
200 FORY=0TO31:SET(0,Y,4):SET(63,Y,4):NEXT
210 PRINT@340,"dragon";
211 PRINT@340+32,"castles";
220 FORX=35TO55STEP2
230 SET(X,10,3):NEXT
240 FORX=36TO54:FORY=11TO12
250 SET(X,Y,3):NEXTY,X
260 FORX=37TO53
270 FORY=13TO15:SET(X,Y,3):NEXTY,X
280 RESET(44,15):RESET(45,15)
281 SOUND190,4:FORX=1TO3000:NEXT
290 GOTO 7000
300 CLS(0)
310 FORX=28TO33:FORY=10TO25
320 SET(X,Y,3):NEXTY,X
330 FORY=6TO8
335 SET(30,Y,2):SET(31,Y,2):NEXT
340 RETURN
350 CLS0
355 FORX=15TO40:FORY=15TO17
360 SET(X,Y,2):NEXTY,X
365 FORY=13TO19
370 SET(14,Y,2):NEXTY
375 FORX=9TO13
376 FORY=15TO17
380 SET(X,Y,2):NEXTY,X
385 SET(41,16,2):SET(42,16,2)
390 RETURN
400 CLS0
410 FORX=10TO54:SET(X,17,4):NEXT
420 FORX=50TO51:FORY=15TO19
421 SET(X,Y,4):NEXTY,X
422 SET(52,16,4):SET(52,18,4)
430 RETURN
450 CLS0
460 C$=CHR$(143+16):B$=C$
461 FORX=1TO15:B$=B$+C$:NEXTX
462 Y=295:FORX=1TO5:PRINT@Y,B$;:Y=Y+32:NEXTX
480 PRINT@397-32,"gold";
490 RETURN
500 CLS
510 PRINT:PRINT:PRINT:PRINT:PRINT
515 PRINT"             
516 PRINT"      
517 PRINT"      
518 PRINT"          
519 PRINT"          
520 PRINT"            
525 PRINT@0,"";
530 RETURN
550 CLS
560 PRINT:PRINT:PRINT:PRINT:PRINT:PRINT
570 PRINT"           "
575 PRINT"         "
580 PRINT"     "
581 PRINT"      ιΰΰΰ"
582 PRINT"      ΰΰΰιΰΰΰ"
583 PRINT"       "
584 PRINT"        "
585 PRINT"      (SHIELD)"
590 RETURN
600 CLS7
610 PRINT@256,"";
620 PRINT"οοοοοοοοοοοοοΰγΰμμμμμοοοοοοοοοοο";
621 PRINT"οοοοοοοοοοοοοΰμΰοοΰοΰοοοοοοοοοοο";
622 PRINT@0,"";
630 RETURN
650 CLS
655 PRINT@448,"";
660 PRINT"                   
661 PRINT"            
662 PRINT"              ³°³°
663 PRINT"              ²°±°
664 PRINT"              ΄ΌΈ°
665 PRINT"     "
666 PRINT"       "
667 PRINT"         "
668 PRINT"           
669 PRINT"              
670 PRINT"                
680 FORX=1TO15
681 FORR=1TO100:NEXTR
682 PRINT:NEXTX
683 PRINT@0,"";
690 RETURN
700 CLS0
710 FORX=20TO30:SET(X,10,1):NEXT
711 FORX=19TO31:FORY=11TO15
712 SET(X,Y,1):NEXTY,X
713 FORX=20TO30:SET(X,16,1):NEXT
714 FORX=23TO27
715 FORY=17TO25
716 SET(X,Y,1):NEXTY,X
717 FORX=28TO50
718 FORY=23TO25:SET(X,Y,1):NEXTY,X
719 FORX=48TO50
720 FORY=17TO22
721 SET(X,Y,1):NEXTY,X
722 SET(51,16,1)
723 SET(52,15,1)
724 RESET(48,17):RESET(23,25)
725 RESET(50,25)
726 RESET(21,11)
727 RESET(29,11)
728 RESET(21,13):RESET(29,13)
729 FORX=22TO28:RESET(X,14):NEXT
730 RETURN
850 CLS0
851 R=E-1
852 C=143:C$=CHR$(C+16*R):B$=C$
853 FORY=98TO108STEP2:GOSUB863:NEXT
854 FORY=114TO124STEP2:GOSUB863:NEXT
855 FORX=1TO10:B$=B$+C$:NEXTX
856 Y=130:FORX=1TO3:GOSUB863:Y=Y+32:NEXTX
857 Y=146:FORX=1TO3:GOSUB863:Y=Y+32:NEXTX
858 B$=C$:FORX=1TO22:B$=B$+C$:NEXTX
859 Y=196:FORX=1TO5:GOSUB863:Y=Y+32:NEXTX
860 B$=C$:FORX=1TO7:B$=B$+C$:NEXTX:FORX=1TO7:B$=B$+CHR$(134+16*R):NEXTX:FORX=1TO8:B$=B$+C$:NEXTX
861 Y=356:FORX=1TO4:GOSUB863:Y=Y+32:NEXTX
862 GOTO865
863 PRINT@Y,B$;
864 RETURN
865 FORX=1TO500:NEXT
866 B$=CHR$(128):FORX=1TO6:B$=B$+CHR$(128):NEXT
867 Y=460:FORX=1TO4:GOSUB863:Y=Y-32
868 SOUND255,1:NEXTX
869 RETURN
900 CLS(0):SOUND230,2
905 GOTO8000
922 PRINT@262,"1";
923 PRINT@270,"3";
924 PRINT@277,"5";
925 PRINT@285,"7";
926 PRINT@422,"2";
927 PRINT@430,"4";
928 PRINT@437,"6";
929 PRINT@445,"8";
930 PRINT@160,"mapofcastles";
931 PRINT@50,"gamelevel";L;
932 PRINT@64,"score=";SC;
933 IFSC=>PTHENPRINT@96,"**canwin**";
934 PRINT@85,"(";P;")";
935 REM HOLDER
936 PRINT@146,"turns=";T;
937 T=T+1
938 PRINT@0,"";
939 PRINT"castle";:E=RND(8):PRINT"";E;"";:FORX=1TO2500:NEXT
940 D=RND(8)
948 IFE=<0THEN938
949 IFE=>9THEN938
950 IFE=1THEN1500
951 IFE=2THEN2000
952 IFE=3THEN2500
953 IFE=4THEN3000
954 IFE=5THEN3500
955 IFE=6THEN4000
956 IFE=7THEN4500
957 IFE=8THEN5000
958 GOTO935
1500 GOSUB850
1501 FORX=1TO500:NEXT
1504 IFD=1ANDSC=>PTHEN6500
1505 IFD=1THEN6000
1510 GOSUB5500
1550 IFI=1THENPRINT@0,"CANDLE IS FOUND HERE (+25).";:FORX=1TO2000:NEXTX:GOTO900
1560 IFI=2THENPRINT@0,"A SWORD IS FOUND HERE (+75).";:FORX=1TO2000:NEXTX:GOTO900
1570 IFI=3THENPRINT@0,"A SPEAR IS FOUND HERE (+75).":FORX=1TO2000:NEXTX:GOTO900
1580 IFI=4THENPRINT@0,"GOLD IS FOUND HERE (+50).";:FORX=1TO2000:NEXTX:GOTO900
1590 IFI=5THENPRINT@0,"A HELMET IS FOUND HERE (+50).";:FORX=1TO2000:NEXTX:GOTO900
1600 IFI=6THENPRINT@0,"A SHIELD IS FOUND HERE (+100).";:FORX=1TO2000:NEXTX:GOTO900
1610 IFI=7THENPRINT@0,"A KEY IS FOUND HERE (+25).";:FORX=1TO2000:NEXTX:GOTO900
1620 IFI=8THENPRINT@0,"BAT TAKES AWAY POINTS **(-100)**";:SOUND10,10:FORX=1TO3000:NEXTX:GOTO900
1630 IFI=9THENPRINT@0,"SNAKE BITE!!!! **(-100)**";:SOUND10,10:FORX=1TO2000:NEXTX:GOTO900
1650 END
2000 GOSUB850
2010 FORX=1TO500:NEXT
2015 IFD=2ANDSC=>PTHEN6500
2016 IFD=2THEN6000
2020 GOSUB5500
2500 GOSUB850
2510 FORX=1TO500:NEXT
2520 IFD=3ANDSC=>PTHEN6500
2530 IFD=3THEN6000
2540 GOSUB5500
3000 GOSUB850
3010 FORX=1TO500:NEXT
3020 IFD=4ANDSC=>PTHEN6500
3030 IFD=4THEN6000
3040 GOSUB5500
3500 GOSUB850
3510 FORX=1TO500:NEXT
3520 IFD=5ANDSC=>PTHEN6500
3530 IFD=5THEN6000
3540 GOSUB5500
4000 GOSUB850
4010 FORX=1TO500:NEXT
4020 IFD=6ANDSC=>PTHEN6500
4030 IFD=6THEN6000
4040 GOSUB5500
4500 GOSUB850
4510 FORX=1TO500:NEXT
4520 IFD=7ANDSC=>PTHEN6500
4530 IFD=7THEN6000
4540 GOSUB5500
5000 GOSUB850
5010 FORX=1TO500:NEXT
5020 IFD=8ANDSC=>PTHEN6500
5030 IFD=8THEN6000
5040 GOSUB5500
5500 I=RND(9)
5510 IFI=1THENSC=SC+25:GOSUB300
5520 IFI=2THENSC=SC+75:GOSUB350
5530 IFI=3THENSC=SC+75:GOSUB400
5540 IFI=4THENSC=SC+50:GOSUB450
5550 IFI=5THENSC=SC+50:GOSUB500
5560 IFI=6THENSC=SC+100:GOSUB550
5570 IFI=7THENSC=SC+25:GOSUB600
5580 IFI=8THENSC=SC-100:GOSUB650
5590 IFI=9THENSC=SC-100:GOSUB700
5600 GOTO1550
6000 XX=13:GOSUB10
6010 PRINT@64,"youlose";
6016 PRINT@340+64,"score=";SC;
6020 SOUNDRND(10),30
6030 FORX=1TO3000:NEXT:CLS0:FORX=1TO2000:NEXT
6040 GOTO5
6500 XX=13:GOSUB10
6509 FORX=1TO255STEP10
6510 CLSRND(8)
6520 SOUNDX,1:NEXTX
6530 PRINT@64,"   you  win!!!!"
6535 PRINT
6536 PRINT"  you killed the dragon!!!"
6537 PRINT
6540 PRINT"  your score was ";SC
6545 PRINT@320,"  game level:";L
6550 PRINT@384,"  number of turns:";T
6555 FORX=1TO3000:NEXT:GOTO6580
6560 PRINT@448,"HIT A KEY TO START OVER";
6570 Q$=INKEY$:IFQ$=""THEN6570
6580 GOTO5
7000 CLS:SOUND230,2
7001 PRINT@128,"1 = *300*"
7002 PRINT@160,"2 = *500*"
7003 PRINT@192,"3 = *700*"
7004 PRINT@224,"4 = *900*"
7005 PRINT@256,"5 = **1100**"
7006 PRINT@0,"";
7010 PRINT"GAME LEVEL (1-5) ";
7015 L=RND(2):PRINT"";L;"";:FORX=1TO1500:NEXT
7020 IFL=1THENP=300
7030 IFL=2THENP=500
7040 IFL=3THENP=700
7050 IFL=4THENP=900
7060 IFL=5THENP=1100
7070 IFL=>6THEN7006
7075 IFL=0THEN7006
7080 GOTO900
8000 C=1
8010 FORX=4TO49STEP15
8020 FORY=15TO25STEP10
8030 SET(X,Y,C)
8031 SET(X+2,Y,C)
8032 SET(X+4,Y,C):SET(X+6,Y,C)
8033 FORM=X+1TOX+5:SET(M,Y+1,C):SET(M,Y+2,C):NEXT M
8034 RESET(X+3,Y+2)
8035 C=C+1
8040 NEXT Y
8050 NEXT X
8060 GOTO 922
9999 REM CHAZBEENHAD@HOTMAIL.COM
