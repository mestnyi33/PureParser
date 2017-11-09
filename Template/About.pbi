EnableExplicit

Global About=-1,
       About_Close=-1

Declare About_Events(Event)

Procedure About_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If IsWindow(About)
    SetActiveWindow(About)
    ProcedureReturn About
  EndIf
  
  About = OpenWindow(#PB_Any, 0, 0, 259, 157, "About", Flag, ParentID)
  About_Close = ButtonGadget(#PB_Any, 174, 132, 80, 20, "Close")
  
  ProcedureReturn About
EndProcedure

Procedure About_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      CloseWindow(EventWindow())
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case About_Close
              CloseWindow(EventWindow())
              
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn About
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  About_Open()

  While IsWindow(About_Events(WaitWindowEvent())) : Wend
CompilerEndIf