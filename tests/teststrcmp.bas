10 A$="FRED":B$="BARNEY":GOSUB100
20 A$="BARNEY":B$="FRED":GOSUB100
30 A$="FRE":B$="FRED":GOSUB100
40 A$="FRED":B$="FRE":GOSUB100
50 A$="FRE":B$="FRA":GOSUB100
60 A$="FRE":B$="FRE":GOSUB100
70 END

100 ? "<" A$<B$ "<=" A$<=B$ "=" A$=B$ "=>" A$=>B$ ">" A$>B$ "<>" A$<>B$ 
170 RETURN

