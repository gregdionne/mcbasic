10 FORT=1TO100
20 X=16384:Y=PEEK(X):Z=64-(YAND64):POKEX,YAND63ORZ
30 FORX=1TO1000:NEXT
40 NEXT
