EnableExplicit

Global J=-1, 
       J_Close=-1,
       J_Container_0=-1

Declare J_Events(Event)

Procedure J_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If IsWindow(J) : ProcedureReturn J : EndIf
  
  J = OpenWindow(#PB_Any, 400, 108, 386, 231, "J", Flag, ParentID)                                             
  J_Close = ButtonGadget(#PB_Any, 300, 205, 81, 21, "Close")
  J_Container_0 = ContainerGadget(#PB_Any, 5, 5, 291, 196, #PB_Container_Flat)
  CloseGadgetList()
  
  ProcedureReturn J
EndProcedure

Procedure J_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      ProcedureReturn #PB_Default
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case J_Close
              ProcedureReturn #PB_Default
      
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn J
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  J_Open()
  
  While IsWindow(J_Events(WaitWindowEvent())) : Wend
CompilerEndIf