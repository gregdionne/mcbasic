0 CLS:LV=RND(-(PEEK(9)*256+PEEK(10))):GOSUB400:POKE16925,0:POKE16926,1:GOTO5
1 C=-1:D=O:C2=C2+1:C1=(1ANDC2):RETURN
2 C=1:D=O:C2=C2+1:C1=(1ANDC2):RETURN
3 D=1:C=O:C2=C2+1:C1=(1ANDC2):RETURN
4 D=-1:C=O:C2=C2+1:C1=(1ANDC2):RETURN
5 DIMW(2),Z(2),F(2),X(2),Y(2),H(2),S(21),K(255),P(4):P(0)=25:P(1)=24:P(2)=25:P(3)=28:P(4)=47
6 DIMV,Q,O,A,B,P,C,D,G,N,E,W,Z,H,X,Y,F,K,U,I,J
7 K(65)=1:K(68)=2:K(83)=3:K(87)=4:K(32)=5
8 R=0:T=0:SH=1:O=0
9 PRINT@23,"closeout";:POKE16415,33
10 R=R+1:PRINT@23+64,"round"R;:SH=SH+2:IFSH>9THENSH=9
11 GOSUB68:GOSUB75
12 Q=32:M=O
13 V=16384:K(96)=3:K(255)=3:K(33)=3:K(240)=3:K(195)=2:K(220)=3:LN$="������"
14 FORI=1TO6:K(ASC(MID$(LN$,I,1)))=1:NEXT:K(42)=1:K(24)=5:K(25)=5
16 FORJ=0TO15STEP2:PRINT@J*32,;
17 FORI=1TO22:PRINTMID$(LN$,RND(6),1);:NEXT
18 PRINT@J*32+32,"����������������������";
19 NEXT:PRINT"�";:TT=160
20 FORI=0TO448STEPQ:PRINT@I,"�";:PRINT@I+21,"��";:NEXT
21 FORI=1TO9
23 A=INT(7*RND(O))*3+3:B=2+INT(6*RND(O))*2:L=2+INT(3*RND(O))*2:IFB+L>15THEN23
24 FORJ=B*QTO(B+L)*QSTEPQ:K=PEEK(V+A+J):IFK(K)=1THENTT=TT-1
25 PRINT@A+J,"�";:NEXT:NEXT:TT=TT-1:PRINT@375,"time":IFR>2THENGOSUB300
26 J=V+8+RND(120):L=PEEK(J):IFK(L)<>1THEN26
27 POKEJ,42:W(O)=1:W(1)=2:W(2)=3:FORI=OTO2:Z(I)=O:Y(I)=O:NEXT
28 H(O)=30:H(1)=35:H(2)=37:K(30)=4:K(35)=4:K(37)=4
29 X(O)=1:X(1)=1:X(2)=-1
30 FORI=OTO2:F(I)=136:NEXT
31 A=2:B=14:C=O:D=O:G=128:K=O:L=379:C2=O
32 FORU=500TOOSTEP-1:PRINT@L,U;:FORZ2=1TOZ3:NEXT:GOSUB83:IFCTHENCC=C
33 C=O:D=O:ONK(K)GOSUB1,2,3,4,59:P=V+A+Q*B:IFDTHENIFK(G)<>2ORK(PEEK(P+Q*D))=3ORB+D<OTHEND=O
34 IFCTHENIFK(PEEK(P+C))=3THENC=O:K=O
35 POKEP,G:A=A+C:B=B+D:N=V+A+Q*B:G=PEEK(N):IFK(G)<>1THEN41
39 T=T+LV:J=PEEK(9)AND128:POKE49151,J:POKE49151,128-J:IFG=42THENT=T+LV*50:FORI=200TO210:U=U+5:PRINT@L,U;:SOUNDI,1:NEXT
40 PRINT@247,T:G=128:M=M+1:IFM=TTTHENPOKEN,P(C1):FORI=1TOLV:GOSUB90:NEXT:GOTO9
41 IFK(G)=4THENPOKEN,191:GOTO51
42 POKEN,P(C1):E=-(E+1)*(E<2):W=W(E):Z=Z(E):H=H(E):X=X(E):Y=Y(E):F=F(E):P=V+W+Q*Z:POKEP,F
43 IFK(PEEK(P-Q))=2ORK(PEEK(P+Q))=2THENIFRND(O)>.1THENX=O:Y=SGN(B-Z)
44 IFK(PEEK(P+Y*Q))=3OR(Z=BANDZ/2=INT(Z/2))THENY=O:X=SGN(A-W)
45 W=W+X:Z=Z+Y:IFW=OORW=21THENX=-X
46 N=V+W+Q*Z:F=PEEK(N):IFK(F)=5THENPOKEN,191:GOTO51
47 IFK(F)<>4THENPOKEN,H:W(E)=W:Z(E)=Z:F(E)=F:X(E)=X:Y(E)=Y:NEXT:GOTO200
48 FORI=OTO2:IFF<>H(I)THENNEXT:STOP
49 F=F(I):I=2:NEXT:POKEN,H:W(E)=W:Z(E)=Z:F(E)=F:X(E)=X:Y(E)=Y:NEXT:GOTO200
51 U=O:NEXT:FORI=1TO20:POKE49151,68:FORJ=1TO100:NEXT:SOUND110+RND(100),1:NEXT
52 PRINT@23+32*11," nabbed!";:POKEV+30+32*11,33:SOUND1,5
53 PRINT@23+32*14,"PRESS r";:PRINT@23+32*15,"TO REPLA";:POKEV+511,89:IFT>HSTHENHS=T
54 GOSUB76:FORI=1TO20:A$=INKEY$:NEXT
55 A$=INKEY$:IFA$=""THEN55
56 ON-(A$="Q")GOTO500:IFA$="N"THENGOSUB400:GOTO8
57 IFA$<>"R"THEN55
58 PRINT@23+32*11,"         ";:PRINT@23+32*14,"       ";:PRINT@23+32*15,"        ";:POKEV+511,96:GOTO8
59 REM SHOVE!
60 IFCC=OTHENSOUND1,10:K=O:RETURN
61 IFSH=0THENSOUND20,10:K=O:RETURN
62 P=V+Q*B:K=O
63 FORI=ATO-21*(CC>O)STEPCC:S(I)=PEEK(P+I):POKEP+I,P(3+(1ANDINT(I))):SOUNDS(I),1:IFK(S(I))=4THENGOSUB70
65 NEXT
66 FORI=ATO-21*(CC>O)STEPCC
67 POKEP+I,S(I):NEXT:SH=SH-1
68 PRINT@23+128,"shoves"STR$(SH);
69 RETURN
70 FORJ=OTO2:IFS(I)<>H(J)THENNEXT:STOP
71 S(I)=F(J)
72 W(J)=INT(18*RND(O)+2):Z(J)=0:F(J)=PEEK(V+W(J)):IFK(F(J))=5THEN72
73 X(J)=-1:IFRND(O)>.5THENX(J)=1
74 Y(J)=O:T=T+LV*50:SOUND10,4:J=2:NEXT
75 PRINT@215,"score:";:PRINT@247,T:RETURN
76 PRINT@215+64,"high:";:PRINT@215+96,HS:RETURN
83 K=O:IF PEEK(2) AND 4 AND NOT PEEK(16952) THEN K=87
84 IF PEEK(2) AND 1 AND NOT PEEK(16946) THEN K=65
85 IF PEEK(2) AND 4 AND NOT PEEK(16948) THEN K=83
86 IF PEEK(2) AND 1 AND NOT PEEK(16949) THEN K=68
87 IF PEEK(2) AND 8 AND NOT PEEK(16952) THEN K=32
89 RETURN
90 PRINT@215,"SCORE:";:FORJ=100TO150STEP2:T=T+LV:PRINT@247,T:SOUNDJ,1:NEXT:RETURN
200 PRINT@379,"'S UP";:FORI=1TO20:POKE49151,68:FORJ=1TO100:NEXT:SOUND110+RND(100),1:NEXT
210 GOTO53
300 L=3:IFR>4THENL=5:IFR>9THENL=7:IFR>14THENL=9
305 FORI=1TORND(L):ONRND(2)GOSUB310,320:NEXT:RETURN
310 J=RND(5)*2+1:IFPEEK(V+Q*J+21)=220THENRETURN
311 PRINT@Q*J,"�";:IFPEEK(V+Q*J+64)=220THENPRINT@Q*J+Q,"�";
312 IFPEEK(V+Q*J-64)=220THENPRINT@Q*J-Q,"�";
315 RETURN
320 J=RND(5)*2+1:IFPEEK(V+Q*J)=220THENRETURN
321 PRINT@Q*J+21,"�";:IFPEEK(V+Q*J+21+64)=220THENPRINT@Q*J+21+Q,"�";
322 IFPEEK(V+Q*J+21-64)=220THENPRINT@Q*J+21-Q,"�";
325 RETURN
400 CLS:PRINTTAB(12)"closeout!"
410 PRINTTAB(10)"BY L. L. BEH"
420 PRINTTAB(6)"COMPUTE! MARCH 1983"
430 PRINT"  MC-10 EDITS JIM GERRIE 2020"
435 PRINT" USING MCBASIC BY GREG DIONNE":PRINT
440 PRINT"THE OBJECT OF 'CLOSEOUT' IS TO"
441 PRINT"SNATCH UP AS MANY SALE ITEMS"
442 PRINT"AS POSSIBLE WHILE EVADING THE"
443 PRINT"HOSTILE BARGAIN HUNTERS. IF"
444 PRINT"THEY GET TOO CLOSE, USE YOUR"
445 PRINT"'SHOVE' TO CHASE THEM BACK TO"
446 PRINT"THE TOP FLOOR. USE wasd TO MOVE"
447 PRINT"AND space TO SHOVE."
448 PRINT@490,"LEVEL (1-3)?";:A$=INKEY$:IFA$<"1"ORA$>"3"THEN448
449 Z3=550-(50*VAL(A$)):LV=VAL(A$):CLS:RETURN
500 END