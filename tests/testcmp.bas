10 ?"EQ"
20 A=1:B=1:GOSUB10000
30 A=1000:B=1000:GOSUB10000
40 A=100000:B=100000:GOSUB10000
50 A=-1:B=-1:GOSUB10000
60 A=-1000:B=-1000:GOSUB10000
70 A=-100000:B=-100000:GOSUB10000
80 A=1.1:B=1.1:GOSUB10000
90 A=1000.1:B=1000.1:GOSUB10000
100 A=100000.1:B=100000.1:GOSUB10000
110 A=-1.1:B=-1.1:GOSUB10000
120 A=-1000.1:B=-1000.1:GOSUB10000
130 A=-100000.1:B=-100000.1:GOSUB10000
140 A=0:B=0:GOSUB10000
150 GOSUB 20000
160 ?"LE"
170 A=-1:B=1:GOSUB10000
180 A=-1000:B=1000:GOSUB10000
190 A=-100000:B=100000:GOSUB10000
200 A=1.1:B=1.2:GOSUB10000
210 A=1000.1:B=1000.2:GOSUB10000
220 A=100000.1:B=100000.2:GOSUB10000
230 A=1:B=1.1:GOSUB10000
240 A=1000:B=1000.1:GOSUB10000
250 A=100000:B=100000.1:GOSUB10000
251 ?A;B
260 GOSUB 20000
270 ?"GT"
280 B=-1:A=1:GOSUB10000
290 B=-1000:A=1000:GOSUB10000
300 B=-100000:A=100000:GOSUB10000
310 B=1.1:A=1.2:GOSUB10000
320 B=1000.1:A=1000.2:GOSUB10000
330 B=100000.1:A=100000.2:GOSUB10000
340 B=1:A=1.1:GOSUB10000
350 B=1000:A=1000.1:GOSUB10000
360 B=100000:A=100000.1:GOSUB10000
361 ?A;B


9999 END
10000 ? "<" A<B "<=" A<=B "=" A=B "=>" A=>B ">" A>B "<>" A<>B 
10010 RETURN
20000 ?"PRESS KEY"
20010 IF INKEY$="" THEN 20010
20020 RETURN
