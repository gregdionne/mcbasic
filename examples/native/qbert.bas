1 CLS:POKE16925,0:POKE16926,1:GOSUB4000:CLEAR4000:GOTO900
2 PRINT@L,X$(C,2);:PRINT@L+W,Y$(C,2);:X=X-2:Y=Y-2:L=W*Y+X:ONY+3GOTO52:P=PEEK(M+L):PRINT@L,X$(C,1);:PRINT@L+W,Y$(C,1);:GOTO24
3 PRINT@L,X$(C,2);:PRINT@L+W,Y$(C,2);:X=X+2:Y=Y-2:L=W*Y+X:ONY+3GOTO52:P=PEEK(M+L):PRINT@L,X$(C,0);:PRINT@L+W,Y$(C,0);:GOTO24
4 PRINT@L,X$(C,2);:PRINT@L+W,Y$(C,2);:X=X-2:Y=Y+2:L=W*Y+X:P=PEEK(M+L):PRINT@L,X$(C,1);:PRINT@L+W,Y$(C,1);:GOTO24
5 PRINT@L,X$(C,2);:PRINT@L+W,Y$(C,2);:X=X+2:Y=Y+2:L=W*Y+X:P=PEEK(M+L):PRINT@L,X$(C,0);:PRINT@L+W,Y$(C,0);:GOTO24
6 IFC<>K(P)THENJ=J+1:N=N+1:PRINT@I,N;:IFJ>27THEN95
8 RETURN
7 SOUND10,1:SOUND20,1:P=0:RETURN
9 D=1:V=-2:RETURN
10 V=-2:RETURN
11 ONBGOTO8,12,8,12,8,12,8,12,8,12,8,10:V=2:RETURN
12 V=V(RND(2)):RETURN
13 D=0:V=2:RETURN
14 V=2:RETURN
15 ON2+SGN(X-A)GOSUB9,11,13:U=V:ON2+SGN(Y-B)GOSUB10,11,14:G=K:K=K(PEEK(W*(B+V)+A+U+M)):ONKGOTO40,60,16,16,16,16,16,22,22
16 ?@O,X$(G,2);:?@O+W,Y$(G,2);:A=A+U:B=B+V:O=W*B+A:ONKGOSUB42,90:?@O,A$(K,D);:?@O+W,B$(K,D);:SOUNDH,1:SOUND50,1:RETURN
18 ONA(T)GOTO44:PRINT@O(T),X$(I(T),2);:PRINT@O(T)+W,Y$(I(T),2);:GOSUB12:U=2:G(T)=I(T):I(T)=K(PEEK(W*(B(T)+U)+A(T)+V+M)) 
19 ONI(T)GOTO46,90,20,20,20,20,20,21,21
20 A(T)=A(T)+V:B(T)=B(T)+U:O(T)=W*B(T)+A(T):PRINT@O(T),A$(I(T),2);:PRINT@O(T)+W,B$(I(T),2);:ONAGOSUB38:RETURN
21 PRINT@O(T),A$(G(T),2);:PRINT@O(T)+W,B$(G(T),2);:I(T)=G(T):RETURN
22 PRINT@O,A$(G,D);:PRINT@O+W,B$(G,D);:K=G:RETURN
24 ONK(P)GOSUB50,8,6,6,6,6,6,70,80,200:RETURN
25 FORZ=1TO65000:GOSUB83:IFL>448THENL=14
26 ONK(ASC(INKEY$+B$))GOSUB2,3,4,5:ONRND(S)GOSUB15:FORT=1TO2:ONRND(S(T))GOSUB18
28 IFLC<>0THENZ=65000:J=28
29 NEXT:NEXT
31 I$=INKEY$:IFJ>27THENN=N+H:PRINT@I,N;:PRINT@480,"           NEXT LEVEL!";:GOSUB6000:GOTO120
32 LF=LF-1:IFLF>0THENGOSUB230:PRINT@0,"         @!#@!";:FORT=1TO10:SOUNDRND(H),1:NEXT:PRINT@0,BL$;:GOTO260
33 PRINT@21,"PLAY AGAIN?";:PRINT@218,LF;
34 I$=INKEY$:R=RND(1000):IFI$=""THEN34
35 IFI$="Y"THEN100
36 IFI$="N"THENCLS:END
37 GOTO33
38 IFRND(8)>1THENRETURN
39 S=SS:O=O(T):A=A(T):B=B(T):K=I(T):G=G(T):A(T)=1:PRINT@O,A$(K,D);:FORF=1TO10:SOUNDH,1:SOUND50,1:NEXT:PRINT@O+W,B$(K,D);:RETURN
40 S=0:N=N+H:PRINT@O,X$(G,2);:PRINT@O+W,Y$(G,2);:A=A+U:B=B+V:O=W*B+A:PRINT@O,A$(K,D);:PRINT@O+W,B$(K,D);
42 FL=2+(ABS(B)*2):PRINT@O,X$(1,2);:PRINT@O+W,Y$(1,2);:O=W*14+A:FORF=30TO1STEP-1:IFF=FLTHENPRINT@O,A$(1,D);:PRINT@O+W,B$(1,D);
43 SOUNDF,1:PRINT@O,X$(1,2);:PRINT@O+W,Y$(1,2);:NEXT:SOUND1,5:PRINT@I,N;:A=1:RETURN
44 ONRND(2)GOTO8:A(T)=14:B(T)=0:O(T)=W*B(T)+A(T):I(T)=K(PEEK(M+O(T))):PRINT@O(T),A$(C,2);:PRINT@O(T)+W,B$(C,2);:G(T)=I(T)
45 SOUND1,1:PRINT@O(T),X$(C,2);:PRINT@O(T)+W,Y$(C,2);:ON1-(O(T)=L)GOTO48,49
46 A(T)=A(T)+V:B(T)=B(T)+2:O(T)=W*B(T)+A(T):PRINT@O(T),A$(1,2);:PRINT@O(T)+W,B$(1,2);
47 PRINT@O(T),X$(1,2);:PRINT@O(T)+W,Y$(1,2);:A(T)=1:SOUND200,1:RETURN
48 PRINT@O(T),A$(C,2);:PRINT@O(T)+W,B$(C,2);:I(T)=C:RETURN
49 PRINT@O(T),A$(C,2);:PRINT@O(T)+W,B$(C,2);:I(T)=C:GOSUB91:GOSUB18:PRINT@L,X$(C,1);:PRINT@L+W,Y$(C,1);:RETURN
50 PRINT@L,X$(1,2);:PRINT@L+W,Y$(1,2);:PRINT@0,"@!#?@!        ";
52 FL=2+(ABS(Y)*2):L=W*14+X:Z=65000:FORF=30TO1STEP-1:IFF=FLTHENPRINT@L,X$(1,1);:PRINT@L+W,Y$(1,1);
53 SOUNDF,1:PRINT@L,X$(1,2);:PRINT@L+W,Y$(1,2);:NEXT:SOUND1,5:RETURN
60 K=C:GOSUB16:PRINT@0,"SNAKE BITE!   ";:GOSUB99:FORZ2=1TO25:I$=INKEY$:NEXT:RETURN
70 PRINT@O,A$(K,D);:PRINT@O+W,B$(K,D);:PRINT@0,"HIT THE SNAKE!";:GOSUB99:RETURN
80 FORT=1TO2:IFL=O(T)THENPRINT@O(T),A$(I(T),2);:PRINT@O(T)+W,B$(I(T),2);
81 NEXT:PRINT@0,"HIT AN EGG!   ";:GOSUB99:FORZ2=1TO25:I$=INKEY$:NEXT:RETURN
83 FORZ2=1TOZ3:NEXT:RETURN
90 I(T)=C:GOSUB20
91 PRINT@0,"HIT BY EGG!   ";:GOSUB99:RETURN
95 LC=-1:PRINT@0,"LEVEL CLEARED!";:FORZ=1TO10:SOUNDZ*10,1:NEXTZ
99 FORZ=1TO800:NEXTZ:Z=65000:RETURN
100 LV=0:SS=30:S(1)=20:S(2)=20:IFN>HSTHENHS=N
110 N=0:LF=3
120 CLS1:GOSUB3000:GOSUB2000
140 J=0:X=14:Y=0:L=14:C=2+RND(5):IFC=QTHEN140
145 GOSUB250
150 D=0:A=1:A(1)=1:A(2)=1:SS=SS-2:S(1)=S(1)-1:S(2)=S(2)-1:IFSS<10THENSS=10:S(1)=10:S(2)=10
155 S=0:GOTO260
200 PRINT@0,"              ";:PRINT@L,X$(1,0);:PRINT@L+W,Y$(1,0);:IFS>0THENS=4
210 FORY=Y TO 2 STEP-1:L=W*Y+X:PRINT@L,X$(1,2);:PRINT@L+W,Y$(1,2);
220 PRINT@L-64,X$(1,0);:PRINT@L-W,Y$(1,0);:SOUNDH,1:SOUND30-(Y*2),1:FORT=1TO2
221 IFA(T)=14ANDB(T)=0THENGOSUB18
222 NEXT
223 FORT=1TO2:ONRND(S(T))GOSUB18:ONRND(S)GOSUB15
225 NEXT:NEXT:PRINT@L-64,X$(1,2);:PRINT@L-W,Y$(1,2);:IFS=4THENS=SS
230 X=14:Y=0:L=14
250 P=PEEK(M+L):PRINT@L,X$(C,1);:PRINT@L+W,Y$(C,1);:ONK(P)GOSUB50,8,6,6,6,6,6,70,80,200:RETURN
260 PRINT@218,LF;:FORZ=1TO25:GOSUB83:IFLC<>0THENZ=65000:J=28
261 ONK(ASC(INKEY$+B$))GOSUB2,3,4,5:NEXT:GOTO25
900 DIMX$(9,2),Y$(9,2),A$(9,2),B$(9,2),K(255),V(2),A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
910 DIMO(2),I(2),G(2),A(2),B(2),S(2),LF,LV,FL,SS,I$,B$,BL$:GOSUB1000:GOSUB5000:GOTO100
1000 FORT=0TO7
1010 X$(T+1,0)=CHR$(132+16)+CHR$(132+16)+CHR$(141+(16*T)):Y$(T+1,0)=CHR$(132+(16*T))+CHR$(138+(16*T))+CHR$(141+(16*T))
1020 X$(T+1,1)=CHR$(142+(16*T))+CHR$(136+16)+CHR$(136+16):Y$(T+1,1)=CHR$(142+(16*T))+CHR$(133+(16*T))+CHR$(136+(16*T))
1030 X$(T+1,2)=CHR$(143+(16*T))+CHR$(143+(16*T))+CHR$(143+(16*T)):Y$(T+1,2)=CHR$(143+(16*T))+CHR$(143+(16*T))+CHR$(143+(16*T))
1040 A$(T+1,0)=CHR$(140+(16*T))+CHR$(141+(16*T))+CHR$(136+112):A$(T+1,1)=CHR$(244)+CHR$(142+(16*T))+CHR$(140+(16*T))
1045 B$(T+1,0)=CHR$(133+(16*T))+CHR$(132+(16*T))+CHR$(133+(16*T)):B$(T+1,1)=CHR$(138+(16*T))+CHR$(136+(16*T))+CHR$(138+(16*T))
1050 A$(T+1,2)=CHR$(136+(16*T))+CHR$(128)+CHR$(141+(16*T))
1055 B$(T+1,2)=CHR$(130+(16*T))+CHR$(128)+CHR$(135+(16*T))
1060 NEXT:C=1:FORT=143TO255STEP16:K(T)=C:C=C+1:NEXT:K(96)=10:W=32:I=122:H=100
1070 FORT=142TO255STEP16:K(T)=2:NEXT:K(148)=2
1075 FORT=140TO255STEP16:K(T)=8:NEXT:K(244)=8
1080 FORT=136TO255STEP16:K(T)=9:NEXT
1090 A$(8,0)=CHR$(32)+CHR$(32)+CHR$(32):B$(8,0)=CHR$(140)+CHR$(140)+CHR$(140)
1095 Y$(1,0)=CHR$(132)+CHR$(136)+CHR$(140)
1110 K(65)=1:K(83)=2:K(90)=3:K(88)=4:B$=CHR$(128):M=16384:V(1)=-2:V(2)=2:B1=200
1120 FORT=1TO14:BL$=BL$+CHR$(143):NEXT
1220 RETURN
2000 T=254:PRINT@T+4,A$(8,0);
2065 PRINT@T+4+32,B$(8,0);
2070 R=RND(3)-1:T=80+(64*R)+(2*R):PRINT@T+4,A$(8,0);
2075 PRINT@T+4+32,B$(8,0);
2090 RETURN
3000 Q=2+RND(5):X=0:FORY=0TO6:X=X+1
3010 PRINT@(32*Y*2)+(16-(X*2)),;:FORC=1TOX:PRINTX$(Q,2);" ";:NEXT
3011 PRINT@(32*Y*2)+32+(16-(X*2)),;:FORC=1TOX:PRINTY$(Q,2);
3012 IFY=7ANDC=8THEN3020
3013 PRINT" ";
3020 NEXT:NEXT
3030 LV=LV+1:IFLV=99THENCLS:PRINT"JIM LOVES HIS PATTY, BOO,":PRINT"CHUM AND NAY":END
3035 IF(LV/3)-INT(LV/3)=0THENLF=LF+1:FORZ2=1TO10:PRINT@0,"BONUS LIFE";:SOUND100,2:PRINT@0,"          ";:SOUND50,2:NEXT
3040 PRINT@91,"LV";LV;:PRINT@122,N;:IFN>9999THENPRINT@121,N;
3041 PRINT@122+33,"HIGH";:PRINT@122+64,HS;:IFHS>9999THENPRINT@121+64,HS;
3050 RETURN
4000 CLS:PRINT@77,"q*bert":PRINT:PRINT"  BY JIM GERRIE & GREG DIONNE"
4010 PRINT
4015 PRINT" USE THE A,S,Z&X KEYS TO MOVE.
4020 PRINT" JUMP ON EACH SQUARE TO CHANGE"
4030 PRINT" ITS COLOR. YOU GET A FREE MAN"
4040 PRINT" EVERY 3 LEVELS. USE THE LIFTS"
4050 PRINT" TO KILL THE SNAKE=100. MOVE  "
4060 PRINT" QUICKLY FROM THE TOP SQUARE."
4070 RETURN
5000 I$=INKEY$:PRINT@448,"     ENTER DIFFICULTY (1-3)?";:LC=0
5010 I$=INKEY$:R=RND(1000):IFI$=""THEN5010
5015 IFVAL(I$)<0ORVAL(I$)>3THEN5010
5016 Z3=400-VAL(I$)*100
5020 RETURN
6000 PRINT@448,"          GET READY FOR     ";:LC=0
6010 FORZ2=1TO22000:NEXT:FORZ2=1TO25:I$=INKEY$:NEXT:RETURN
