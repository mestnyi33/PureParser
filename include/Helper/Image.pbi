EnableExplicit

Global IH=-1, 
       IH_Container_0=-1,
       IH_Open=-1,
       IH_Save=-1,
       IH_Copy=-1,
       IH_Cut=-1,
       IH_Paste=-1,
       IH_Ok=-1,
       IH_Close=-1

Declare IH_Events(Event)

Procedure IH_Open(Flag.i=#PB_Window_SystemMenu|#PB_Window_ScreenCentered, ParentID.i=0)
  If Not IsWindow(IH) 
    IH = OpenWindow(#PB_Any, 400, 108, 386, 231, "J", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)                                                   
    IH_Container_0 = ContainerGadget(#PB_Any, 5, 5, 291, 196, #PB_Container_Flat)           
    CloseGadgetList()
    IH_Open = ButtonGadget(#PB_Any, 302, 6, 80, 20, "Button_1")
    IH_Save = ButtonGadget(#PB_Any, 302, 30, 80, 20, "Button_2")
    IH_Copy = ButtonGadget(#PB_Any, 300, 65, 81, 21, "Button_3")
    IH_Cut = ButtonGadget(#PB_Any, 300, 90, 81, 21, "Button_4")
    IH_Paste = ButtonGadget(#PB_Any, 300, 115, 81, 21, "Button_5")
    IH_Ok = ButtonGadget(#PB_Any, 300, 180, 81, 21, "Button_6")
    IH_Close = ButtonGadget(#PB_Any, 300, 205, 81, 21, "Close")     
    
  EndIf

  ProcedureReturn IH
EndProcedure

Procedure IH_Events(Event)
  Select Event
    Case #PB_Event_CloseWindow
      ProcedureReturn #False
      
    Case #PB_Event_Gadget
      Select EventType()
        Case #PB_EventType_LeftClick
          Select EventGadget()
            Case IH_Close
              ProcedureReturn #False
      
          EndSelect
      EndSelect
  EndSelect
  
  ProcedureReturn IH
EndProcedure


CompilerIf #PB_Compiler_IsMainFile
  IH_Open()

  While IsWindow(IH_Events(WaitWindowEvent())) : Wend
CompilerEndIf