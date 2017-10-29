CompilerIf Not Defined(Const, #PB_Module)
  DeclareModule Const
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
    EndEnumeration
  EndDeclareModule
  
  Module Const 
  EndModule 
  
  UseModule Const
CompilerEndIf
