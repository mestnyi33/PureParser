: Procedure.i Win(win=-1)

OpenWindow   (32, 800, 219, 200, 300, "Window 32",#PB_Window_SizeGadget)
  ButtonGadget(20, 10, 60, 80, 20, "Button 20")
EndProcedure

Macro Func(Name,wid,wx,wy,wWidth,wHeight,wCaption,wFlag)

  OpenWindow(wid,wx,wy,wWidth,wHeight,wCaption,wFlag)

EndMacro

;  WindowID = OpenWindow(Window, 0, 0, 995, 455, "", Flags); :If Window =-1 :Window = WindowID :EndIf 
OpenWindow (11, 360, 219, 200, 300, "Window = 11",
            #PB_Window_SystemMenu) 
;OpenWindow(1, 360, 219, 200, 300, "Window 1", #PB_Window_SystemMenu)
ButtonGadget(10, 10, 10, 80, 20, "Button 10")
win1 = OpenWindow(#PB_Any,0,0,200,300,"PB_Any", #PB_Window_SystemMenu|#PB_Window_ScreenCentered| #PB_Window_SizeGadget)
but1 = ButtonGadget(-1,10,250,60,20,"but1",#PB_Button_Toggle)


; Procedure WinEndProcedure()
;   OpenWindow   (22, 800, 219, 200, 300, "Window 22", #PB_Window_SizeGadget)
;   ButtonGadget(20, 10, 60, 80, 20, "Button 20")
; EndProcedure
; 
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

UseGadgetList(WindowID(11))
Button = ButtonGadget(#PB_Any, 1, 30, 80, 20, "Button 3",#PB_Button_Right)
ButtonGadget(Button5, 110, 30, 80, 20, "Button 5")

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
; IDE Options = PureBasic 5.60 (Windows - x86)
; CursorPosition = 71
; FirstLine = 20
; Folding = -
; EnableXP
; CompileSourceDirectory