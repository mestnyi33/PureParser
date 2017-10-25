                                                                                                                                                                                                                                                                                           EnableExplicit

Enumeration Window
  #Window_0
EndEnumeration

Enumeration Gadget
EndEnumeration

Enumeration Font
EndEnumeration

Declare WE_Events()

Procedure WE_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If Not IsWindow(#Window_0)
    OpenWindow(#Window_0,230,230,240,200,"Window_0", Flag)


    BindEvent(#PB_Event_Gadget, @WE_Events(), #Window_0)
  EndIf

  ProcedureReturn #Window_0
EndProcedure

Procedure WE_Events()
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
  WE_Open()

  While IsWindow(#Window_0)
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        If IsWindow(EventWindow())
          CloseWindow(EventWindow())
        Else
          CloseWindow(#Window_0)
        EndIf
    EndSelect
  Wend
CompilerEndIf