EnableExplicit

Global Main=-1,
       Main_About=-1,
       Main_Close=-1

Declare Main_Events(Event)

Procedure Main_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If Not IsWindow(Main)
    Main = OpenWindow(#PB_Any, 0, 0, 500, 400, "Window_0", Flag, ParentID)
    Main_About = ButtonGadget(#PB_Any, 6, 6, 80, 20, "About")
    Main_Close = ButtonGadget(#PB_Any, 314, 258, 80, 20, "Close")
    
  EndIf

  ProcedureReturn Main
EndProcedure

Procedure Main_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      ProcedureReturn #PB_Default
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case Main_Close
              ProcedureReturn #PB_Default
      
            Case Main_About
              About_Open()
      
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Main
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Main_Open()

  While IsWindow(Main_Events(WaitWindowEvent())) : Wend
CompilerEndIf