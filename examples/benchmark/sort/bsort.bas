10 FOR X=16384+510 TO 16385 STEP -1
20 FOR Y=16384 TO X
30 A=PEEK(Y):B=PEEK(Y+1)
40 IF A>B THEN POKE Y,B:POKE Y+1,A
50 NEXT Y
60 NEXT X
