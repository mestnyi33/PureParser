; https://www.purebasic.fr/english/viewtopic.php?f=13&t=71911&p=530342&sid=abb657eb8229fcd812c993e17d47b116#p530342

Prototype P0()
Prototype P1(Param1$ = "")
Prototype P2(Param1$ = "", Param2$ = "")
Prototype P3(Param1$ = "", Param2$ = "", Param3$ = "")
Prototype P4(Param1$ = "", Param2$ = "", Param3$ = "", Param4$ = "")
Prototype P5(Param1$ = "", Param2$ = "", Param3$ = "", Param4$ = "", Param5$ = "")

EnableExplicit

Runtime Procedure MessageWithoutParameter()
  MessageRequester("Without Parameter", "No parameter")
EndProcedure

Runtime Procedure MessageOneParameter(Text.s)
  MessageRequester("Only one Parameter", Text)
EndProcedure

Runtime Procedure MessageTwoParameters(Text1.s, Text2.s)
  MessageRequester("Two parameters", Text1 + Text2)
EndProcedure

Runtime Procedure MessageThreeParameters(Text1.s, Text2.s, Text3.s)
  MessageRequester("Three parameters", Text1 + Text2 + Text3)
EndProcedure

Procedure CallProcedure(NomProcedure.s, Parameter$ = "")
  
  Protected i, *PtrProc = GetRuntimeInteger(NomProcedure + "()")
  Protected MaxParam = CountString(Parameter$, ",") + Bool(Parameter$ <> "")
  Protected Dim ArrayParams.s(MaxParam)
  
  If MaxParam
    For i = 1 To MaxParam
      ArrayParams(i) = StringField(Parameter$, i, ",")
    Next 
  EndIf
  
  Debug "Pre Call Size = " + ArraySize(ArrayParams())
  
  Select MaxParam
    Case 0
      Call.P0 = *PtrProc 
      Call()
    Case 1
      Call.P1 = *PtrProc
      Call(ArrayParams(1))
    Case 2
      Call.P2 = *PtrProc
      Call(ArrayParams(1), ArrayParams(2))
    Case 3
      Call.P3 = *PtrProc
      Call(ArrayParams(1), ArrayParams(2), ArrayParams(3))
    Case 4
      Call.P4 = *PtrProc
      Call(ArrayParams(1), ArrayParams(2), ArrayParams(3),ArrayParams(4))
    Case 5
      Call.P5 = *PtrProc
      Call(ArrayParams(1), ArrayParams(2), ArrayParams(3), ArrayParams(4), ArrayParams(5))
  EndSelect
  
  Debug "Post Call Size = " + ArraySize(ArrayParams())
  Debug "------------------"
  
  FreeArray(ArrayParams())
  
EndProcedure

CallProcedure("MessageWithoutParameter")
CallProcedure("MessageOneParameter", "Hello it's KCC")
CallProcedure("MessageTwoParameters", "Hello it's KCC a second time, but it's more long")
CallProcedure("MessageThreeParameters", "Hello it's KCC another time, and this time, it's one time too much")
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = --
; EnableXP