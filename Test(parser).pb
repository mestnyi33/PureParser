WindowID = OpenWindow(#PB_Any, 10, 30, 110, 100, "(#pb_any) flag=no_gadgets", #PB_Window_NoGadgets); :If Window =-1 :Window = WindowID :EndIf 
Macro Func(Name,wid,wx,wy,wWidth,wHeight,wCaption,wFlag) : OpenWindow(2,wx,wy,wWidth,wHeight,"in macro (2)",wFlag) : EndMacro
;  WindowID = OpenWindow(Window, 0, 0, 995, 455, "(#pb_any) comment", Flags) ; :If Window =-1 :Window = WindowID :EndIf 
;OpenWindow(100, 360, 219, 200, 300, "(100) comment ", #PB_Window_SystemMenu)
OpenWindow (3, 20, 60, 110, 100, "(3) flag=system_menu",
            #PB_Window_SystemMenu) 
Procedure.i Win(win=-1) : OpenWindow     (1, 30, 90, 110, 100, "(1) in procedure flag=size",#PB_Window_SizeGadget) : EndProcedure

win1 = OpenWindow(#PB_Any,0,0,200,300,"flag=size|screen|system", #PB_Window_SystemMenu|
                                                                 #PB_Window_ScreenCentered|
                                                                 #PB_Window_SizeGadget)
but1 = ButtonGadget(-1,10,250,60,20,"button 1",#PB_Button_Toggle)

Procedure WinEndProcedure()
  OpenWindow   (42, 800, 219, 200, 300, "Window 42", #PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "Button 20")
EndProcedure

Procedure.i EndProcedureWin()
  OpenWindow(52, 800, 219, 200, 300, "Window 52", #PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "Button 20")
EndProcedure

Procedure ProcedureWin()
  OpenWindow   (62, 800, 219, 200, 300, "Window 62", #PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "Button 20")
EndProcedure

;ProcedureWin()

;WinEndProcedure()

;EndProcedureWin()

UseGadgetList = UseGadgetList(WindowID(3))
Button = ButtonGadget(#PB_Any, 1, 30, 80, 20, "Button 3",#PB_Button_Right)

UseGadgetList(UseGadgetList)
ButtonGadget(2, 110, 30, 80, 20, "button 2 used")

sd = Win()

Repeat
  
  
  Select WaitWindowEvent()
      
    Case #PB_Event_Gadget
      ;Debug EventGadget()
    Case #PB_Event_CloseWindow
      Quit = 1     
      
  EndSelect
  
Until Quit = 1
End

; IDE Options = PureBasic 5.31 (Windows - x86)
; Folding = -
; EnableUnicode
; EnableXP