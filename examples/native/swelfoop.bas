1 CLS:GOTO1030
2 IFY>B OR Y<0 OR X>N OR X<0 THEN RETURN
3 IFB(X,Y)<>L THEN RETURN
4 M=M+1:Q(M)=X:R(M)=Y:Q=X:R=Y:PRINT@Q+32*R,"x";:B(X,Y)=0:YD=YD+1:RETURN
5 IF MD<15 THENPRINT@Q+32*R,CHR$(C(B(Q,R)));:RETURN
6 PRINT@Q+32*R,"x";:RETURN
9 X=E+1:Y=F:GOSUB2:X=E-1:Y=F:GOSUB2:X=E:Y=F-1:GOSUB2:X=E:Y=F+1:GOSUB2:IF M=0 THEN RETURN
10 E=Q(M):F=R(M):M=M-1:GOTO9
11 FOR X=0 TO N:Y=B:D=0
12 IF B(X,Y)=0 THEN D=D+1:GOTO14
13 IF D>0 THEN 16
14 Y=Y-1:IF Y<0 THEN 19
15 GOTO12
16 FOR Z=Y TO 0 STEP-1:B(X,Z+D)=B(X,Z):NEXT:Y=Y+D
17 D=D-1:B(X,D)=0:IF D=0 THEN 14
18 GOTO17
19 NEXT:X=0
20 IF B(X,B)<>0 THEN 24
21 IF X>N THEN RETURN
22 FOR S=X TO N-1:FOR T=0 TO B:B(S,T)=B(S+1,T):NEXT:NEXT:FOR T=0TOB:B(N,T)=0:NEXT:N=N-1:IFN<0THENRETURN
23 GOTO20
24 X=X+1:IF X<N THEN20
25 RETURN
26 FORR=0TOB:FORQ=0TOA:PRINT@Q+32*R,CHR$(C(B(Q,R)));:NEXT:NEXT:RETURN
1000 REM
1010 REM
1020 REM
1030 DIMB(15,10),Q,R,N,F,E,A,B,PY,PX,S,T,C,D,C(8),M,L:FORA=0TO8:C(A)=143+(A*16):NEXT:A=RND(-(PEEK(9)*256+PEEK(10)))
1050 REM PSEUDO STACK FOR SEARCH
1060 A=15:B=10:NC=4:DIMQ(150),R(150)
1080 PRINTTAB(2)"ORIGINALLY FOR VIDEOPAC C7420"
1140 T=32*3+8:GOSUB4000:GOSUB4030:PRINT:PRINT:PRINT
1190 PRINTTAB(4);"(C) 2012 GERTK@XS4ALL.NL":PRINT:PRINT
1200 PRINTTAB(4);"MC-10 MODS BY JIM GERRIE"
1210 FORT=1TO10000:NEXT
1230 CLS
1260 PRINT"SWELL FOOP IS A PUZZLE GAME."
1280 PRINT
1290 PRINT"THE GOAL IS TO REMOVE AS MANY"
1310 PRINT"BLOCKS AS POSSIBLE IN AS FEW"
1330 PRINT"MOVES AS POSSIBLE."
1340 PRINT"BLOCKS ADJACENT TO EACH OTHER"
1350 PRINT"GET REMOVED AS A GROUP."
1360 PRINT"USE A,S,W,Z KEYS TO MOVE THE"
1365 PRINT"CURSOR AND <SPACE> TO SELECT."
1370 PRINT"THE REMAINING BLOCKS THEN"
1390 PRINT"COLLAPSE TO FILL IN THE GAPS"
1400 PRINT"AND NEW GROUPS ARE FORMED."
1420 PRINT"YOU CANNOT REMOVE SINGLE"
1430 PRINT"BLOCKS."
1440 PRINT
1460 PRINT"PRESS <ENTER> TO START...";
1480 GOSUB3570:IFI$<>CHR$(13)THEN1480
1490 REM RESET SCORE
1500 CLS:SC=0:O=RND(3)
1590 REM FILL ARRAY 
1600 FORX=0TOA:FORY=0TOB:B(X,Y)=RND(NC)+O:NEXT:NEXT
1650 PY=B:PX=0:N=A
1690 REM MAIN LOOP
1700 GOSUB3630:T=384:GOSUB4000:T=304:GOSUB4030:GOSUB3640:GOSUB26:GOSUB3020:GOSUB3030
1710 GOSUB3210:SOUND60,1
1730 Q=PX:R=PY
1740 MD=MD+1:GOSUB5:IFMD>45THENMD=0
1770 I$=INKEY$:IFI$=""THEN1740
1780 PRINT@Q+32*R,"x";:IFI$=" "THEN1940
1800 PRINT@Q+32*R,CHR$(C(B(Q,R)));:IFI$="Z"THENPY=PY+1:IFPY>BTHENPY=0
1860 IFI$="W"THENPY=PY-1:IFPY<0THENPY=B
1880 IFI$="S"THENPX=PX+1:IFPX>ATHENPX=0
1900 IFI$="A"THENPX=PX-1:IFPX<0THENPX=A
1920 MD=15:Q=PX:R=PY:GOTO1730
1940 L=B(PX,PY)
1960 IFL=0THENSOUND50,1:GOTO1730
1970 REM SET SEARCH COORDINATES
1980 E=PX:F=PY:YD=0:M=0:GOSUB9:SOUND1,1:PRINT@1*32+18,"YIELD:"YD;" ";:GOSUB11:IFYD<2THENSOUND80,1:GOTO1730
2200 SC=SC+(YD-2)^2:GOTO1700
3020 PRINT@0*32+18,"SCORE:"INT(SC);:RETURN
3030 PRINT@5*32+18,"HIGH:"INT(HS);:RETURN
3210 X=0
3220 Y=B
3230 C=0
3240 IFB(X,Y)=0THEN3300
3250 GOSUB3340:IFC>0THENRETURN
3270 Y=Y-1:IFY>=0THEN3230
3290 GOTO3310
3300 IFX=0ANDY=BTHEN3420
3310 X=X+1:IFX>NTHEN3430
3330 GOTO3220
3340 L=B(X,Y):IF(X+1)>N THEN3370
3360 IFB(X+1,Y)=L THEN3400
3370 IFY-1<0THEN3390
3380 IFB(X,Y-1)=L THEN3400
3390 RETURN
3400 C=C+1:RETURN
3420 SC=SC+1000:PRINT@0*32+18,"bonus: 1000 ";:FORT=1TO20:SOUND200,1:NEXT:GOSUB3020
3430 GOSUB3020
3490 PRINT@9*32+18,"GAME OVER";
3500 IFSC>HS THENHS=SC
3510 GOSUB3030
3520 PRINT@10*32+18,"PLAY AGAIN?";
3530 GOSUB3570
3540 IFI$="N"THENEND
3550 IFI$="Y"THEN1500
3560 GOTO3530
3570 I$=INKEY$:IFI$=""THEN3570
3610 RETURN
3630 FORT=16736TO16767:POKET,147:NEXT:RETURN
3640 FORT=16864TO16895:POKET,159:NEXT:RETURN
4000 PRINT@T,"����������������";
4010 PRINT@T+32,"����������������";
4020 PRINT@T+64,"����������������";:RETURN
4030 PRINT@T+96,"����������������";
4040 PRINT@T+128,"����������������";
4050 PRINT@T+160,"����������������";:RETURN
