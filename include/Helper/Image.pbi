EnableExplicit

Global J=-1, 
       J_Container_0=-1,
       J_Open=-1,
       J_Save=-1,
       J_Copy=-1,
       J_Cut=-1,
       J_Paste=-1,
       J_Ok=-1,
       J_Close=-1

Declare J_Events(Event)

Procedure J_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If Not IsWindow(J) 
    J = OpenWindow(#PB_Any, 400, 108, 386, 231, "J", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)                                                   
    J_Container_0 = ContainerGadget(#PB_Any, 5, 5, 291, 196, #PB_Container_Flat)           
    CloseGadgetList()
    J_Open = ButtonGadget(#PB_Any, 302, 6, 80, 20, "Button_1")
    J_Save = ButtonGadget(#PB_Any, 302, 30, 80, 20, "Button_2")
    J_Copy = ButtonGadget(#PB_Any, 300, 65, 81, 21, "Button_3")
    J_Cut = ButtonGadget(#PB_Any, 300, 90, 81, 21, "Button_4")
    J_Paste = ButtonGadget(#PB_Any, 300, 115, 81, 21, "Button_5")
    J_Ok = ButtonGadget(#PB_Any, 300, 180, 81, 21, "Button_6")
    J_Close = ButtonGadget(#PB_Any, 300, 205, 81, 21, "Close")     
    
  EndIf

  ProcedureReturn J
EndProcedure

Procedure J_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case J_Close
              ProcedureReturn #False
      
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn J
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  J_Open()

  While IsWindow(J_Events(WaitWindowEvent())) : Wend
CompilerEndIf