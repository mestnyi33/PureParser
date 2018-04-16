CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "CFE.pbi" ; Ok 
CompilerEndIf

;-
; Sticky window element example
CompilerIf #PB_Compiler_IsMainFile
  Global Desktop_0
  Global Desktop_0_Window_0, Desktop_0_Window_0_Button_0, Desktop_0_Window_0_Button_1
  Global Desktop_0_Window_1, Desktop_0_Window_1_Button_0, Desktop_0_Window_1_Button_1
  Global Desktop_0_Window_2, Desktop_0_Window_2_Button_0, Desktop_0_Window_2_Button_1
  
  Desktop_0 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 600,400)
  
  Desktop_0_Window_0 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"Window_0", #_Flag_SystemMenu)
  Desktop_0_Window_0_Button_0 = ButtonElement(#PB_Any, 10,10, 100, 25,"Button_0")
  Desktop_0_Window_0_Button_1 = ButtonElement(#PB_Any, 10,25, 100, 25,"Button_1")
  CloseElementList()
  
  Desktop_0_Window_1 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"Window_1", #_Flag_SystemMenu)
  Desktop_0_Window_1_Button_0 = ButtonElement(#PB_Any, 10,10, 100, 25,"Button_0")
  Desktop_0_Window_1_Button_1 = ButtonElement(#PB_Any, 10,25, 100, 25,"Button_1")
  CloseElementList()
  
  Desktop_0_Window_2 = OpenWindowElement(#PB_Any, #PB_Ignore,#PB_Ignore, 200,150,"Window_2", #_Flag_SystemMenu)
  Desktop_0_Window_2_Button_0 = ButtonElement(#PB_Any, 10,10, 100, 25,"Button_0")
  Desktop_0_Window_2_Button_1 = ButtonElement(#PB_Any, 10,25, 100, 25,"Button_1")
  CloseElementList()
  
  StickyWindowElement(Desktop_0_Window_0,1)
  StickyWindowElement(Desktop_0_Window_0,0)
  StickyWindowElement(Desktop_0_Window_2,1)
  
  SetElementText(StickyWindowElement(),"StickyWindow")
  WaitWindowEventClose(Desktop_0)
CompilerEndIf