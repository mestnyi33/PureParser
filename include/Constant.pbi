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
      ;#PB_EventType_CloseItem
       
      #PB_EventType_Create
      #PB_EventType_Move
      #PB_EventType_Size
      #PB_EventType_Destroy
    ;  #PB_EventType_Repaint
   EndEnumeration
   
   ;#PB_MDI_Image = 555
   ;#PB_MDI_TileImage = 666
  EndDeclareModule
  
  Module Constant
  EndModule 
  
  UseModule Constant
CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 21
; Folding = -
; EnableXP