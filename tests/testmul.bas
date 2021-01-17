0 CLS:DIMW(383),S(7),T(7),E(6),F(6),X(6),Y(6),C(7),T,C,P,X,Y,L,P,Z,M,I$
10 P=1
20 S(P)=1:T(P)=8:E(P)=23:F(P)=9:X(P)=ABS(S(P)-E(P)):Y(P)=-10+RND(40)
70 FORT=0TO1STEP.01

75 T1=(1-T)*(1-T):T2=2*(1-T)*T:T3=T*T

76 U=T1*S(P) +T2*X(P) + T3*E(P)
77 V=T1*T(P) +T2*Y(P) + T3*F(P)

80 X=(1-T)*(1-T)*S(P) + 2*(1-T)*T*X(P) + T*T*E(P)
90 Y=(1-T)*(1-T)*T(P) + 2*(1-T)*T*Y(P) + T*T*F(P)

105 ?U;V
100 ?X;Y
125 IF INKEY$=""GOTO125
130 NEXT
