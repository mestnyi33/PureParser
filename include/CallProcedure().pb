Structure info
  FonctionName.s
  info1.s
  info2.s
EndStructure

Prototype Function(*data.info)

Runtime Procedure Function1(*data.info)
  Debug *data\info1
  Debug *data\info2
EndProcedure

Runtime Procedure Function2(*data.info)
  Debug *data\info1
  Debug *data\info2
EndProcedure

Procedure LaunchProcedure(*data.info)
  Protected ProcedureName.Function = GetRuntimeInteger(*data\FonctionName + "()")
  ProcedureName(*data)
EndProcedure

Define Info.info

info\FonctionName = "Function1"
info\info1 = "Info 1 from function1"
info\info2 = "info 2 from function1"
LaunchProcedure(@info)

info\FonctionName = "Function2"
info\info1 = "Info 1 from function2"
info\info2 = "info 2 from function2"
LaunchProcedure(@info)
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = -
; EnableXP