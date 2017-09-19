EnableExplicit

Global.i Window_0=-1, 
      Window_0_Button_0=-1

Declare Window_0_Event()

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 665, 312, 200, 200, "Окно", Flag)                                                     
    Window_0_Button_0 = ButtonGadget(#PB_Any, 115, 175, 80, 20, "Закрыть")                                              
    
    BindEvent(#PB_Event_Gadget, @Window_0_Event(), Window_0)
  EndIf
  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Event()
  Select Event()
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            
          EndSelect
      EndSelect
  EndSelect
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Window_0_Open()
  
  While IsWindow(Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf
indow(Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf
