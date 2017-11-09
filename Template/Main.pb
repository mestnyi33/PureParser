EnableExplicit

Global Main=-1,
       Main_About=-1,
       Main_Close=-1

Declare Main_Events(Event)

XIncludeFile "About.pbi"

Procedure Main_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If IsWindow(Main)
    SetActiveWindow(Main)
    ProcedureReturn Main
  EndIf
  
  Main = OpenWindow(#PB_Any, 0, 0, 399, 283, "Main", Flag, ParentID)
  Main_About = ButtonGadget(#PB_Any, 6, 6, 80, 20, "About")
  Main_Close = ButtonGadget(#PB_Any, 314, 258, 80, 20, "Close")
  
  ProcedureReturn Main
EndProcedure

Procedure Main_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      CloseWindow(EventWindow())
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case Main_Close
              CloseWindow(EventWindow())
      
            Case Main_About
              About_Open(#PB_Window_WindowCentered, WindowID(EventWindow()))
      
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn Main
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  Main_Open()

  While IsWindow(Main)
    Define Event = WaitWindowEvent()
    
    Select EventWindow()
      Case Main
        Main_Events( Event ) 
        
      Case About
        About_Events( Event ) 
        
    EndSelect
  Wend
CompilerEndIf