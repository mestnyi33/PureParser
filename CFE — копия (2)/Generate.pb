Procedure Generate()
  Protected i, ReadText.S, Find.S, Text.S
  Text.S = "111"+#LF$+ 
           "222"+#LF$+
           "333"+#LF$+
           "444"+#LF$+
           "555"
  
  Protected f=0,ff
  For i=0 To CountString(Text, #LF$)-1
    f=FindString(Text, #LF$, f+Len(#LF$))
    ReadText.S = Mid(Text,ff+Len(#LF$),f)
    ff=Len(Left(Text,f))
    Debug  i
    Debug ReadText
  Next
  
EndProcedure

Generate()
