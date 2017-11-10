EnableExplicit

Global W_Window_0=-1,
       G_Window_0_Button_0=-1,
       G_Window_0_Button_1=-1

Declare W_Window_0_Events(Event)

XIncludeFile "Window_1.pbi"

Procedure W_Window_0_CallBack()
  W_Window_0_Events(Event())
EndProcedure

Procedure W_Window_0_Open(ParentID.i=0, Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If IsWindow(W_Window_0) 
    SetActiveWindow(W_Window_0)
    ProcedureReturn W_Window_0
  EndIf
  
  W_Window_0 = OpenWindow(#PB_Any, 0, 0, 399, 283, "Window_0", Flag, ParentID)
  G_Window_0_Button_0 = ButtonGadget(#PB_Any, 6, 6, 80, 20, "Button_0")
  G_Window_0_Button_1 = ButtonGadget(#PB_Any, 314, 258, 80, 20, "Button_1")
  
  ProcedureReturn W_Window_0
EndProcedure

Procedure W_Window_0_Events(Event)
  Select Event
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case G_Window_0_Button_1
              ProcedureReturn #PB_Event_CloseWindow
      
            Case G_Window_0_Button_0
              DisableWindow(EventWindow(), #True)
              W_Window_1_Open(WindowID(EventWindow()), #PB_Window_WindowCentered)
              
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Event
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  W_Window_0_Open()

  While IsWindow(W_Window_0)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case W_Window_0
        If W_Window_0_Events( Event ) = #PB_Event_CloseWindow
          CloseWindow(EventWindow())
          Break
        EndIf
        
      Case W_Window_1
        If W_Window_1_Events( Event ) = #PB_Event_CloseWindow
          DisableWindow(W_Window_0, #False)
          CloseWindow(EventWindow())
        EndIf
        
    EndSelect
  Wend
CompilerEndIf