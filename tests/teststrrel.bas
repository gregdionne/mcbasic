10 A$="THIS IS A TEST TO SEE IF REPEATED CALLS"
20 B$="TO STRING CONCATENATION GENERATE A LEAK"
30 C$="WHEN USING MID$ or RIGHT$"
40 FOR I=1 TO 1000
50 ?LEN(LEFT$(A$+B$+C$,1))
60 NEXT

