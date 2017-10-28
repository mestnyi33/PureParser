EnableExplicit

Global Window_0=-1, 
Window_0=-1, 
Window_0_Button_0=-1, 
Window_0_Button_1=-1, 
Window_0_Button_2=-1

Declare Window_0_Events()

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any, 550, 300, 300, 200, "Window_0", Flag)
    Window_0_Button_0 = ButtonGadget(#PB_Any, 35, 19, 80, 20, "Button_0")
    Window_0_Button_1 = ButtonGadget(#PB_Any, 102, 64, 80, 20, "Button_1")
    Window_0_Button_2 = ButtonGadget(#PB_Any, 167, 125, 80, 20, "Button_2")
    
    BindEvent(#PB_Event_Gadget, @Window_0_Events(), Window_0)
  EndIf

  ProcedureReturn Window_0
EndProcedure

Procedure Window_0_Events()
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