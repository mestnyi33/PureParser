CompilerIf Not Defined(Constant, #PB_Module)
  DeclareModule Constant
    Enumeration #PB_Event_FirstCustomValue
      #PB_Event_Create
      #PB_Event_MouseMove
      #PB_Event_LeftButtonDown
      #PB_Event_LeftButtonUp
      #PB_Event_Destroy
    EndEnumeration
    
    Enumeration #PB_EventType_FirstCustomValue
      #PB_EventType_Create
      #PB_EventType_Move
      #PB_EventType_Size
      #PB_EventType_Destroy
    ;  #PB_EventType_Repaint
    EndEnumeration
  EndDeclareModule
  
  Module Constant
  EndModule 
  
  UseModule Constant
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP