10 ?"ENTER EXP AND INIT LOG ESTIMATE"
20 INPUT E,X
30 GOSUB 100
50 GOTO 10

100 ?"E=";E;"X=";X
105 ?"E(X)=";EXP(X)
110 FOR I=1TO5
120 X = X-1 + E/EXP(X)
125 IF X>15.94235 THEN X=15.94235
130 ?"X=";X;"E(X)=";EXP(X)
140 NEXT I
150 ?"LOG(E)=";LOG(E)
160 RETURN
