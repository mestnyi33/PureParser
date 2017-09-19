EnableExplicit

Global.i Window_0=-1, 
      Window_0_Button_0=-1, 
      Window_0_String_0=-1

Enumeration Gadget
  #Window_0_Button_1
EndEnumeration

Declare Window_0_Event()

Procedure Window_0_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(Window_0)
    Window_0 = OpenWindow(#PB_Any,230,230,200,200,"Window_0", Flag)
    Window_0_Button_0 = ButtonGadget(#PB_Any, 10,10,80,20,"Button_0")
    Window_0_String_0 = StringGadget(#PB_Any, 10,35,80,20,"String_0")
    ButtonGadget(#Window_0_Button_1, 10,70,80,20,"Button_1")
    
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
