CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;   ; StatusBar functions
  Declare AddStatusBarElementField(Width)
  Declare CreateStatusBarElement(StatusBarElement, Parent = #PB_Default)
  Declare FreeStatusBarElement(StatusBarElement)
  Declare.b IsStatusBarElement(StatusBarElement)
  Declare StatusBarElementHeight(StatusBarElement  =  #PB_Default)
  Declare StatusBarElementID(StatusBarElement)
  Declare StatusBarElementImage(StatusBarElement, Field, Image, Appearance = 0)
  Declare StatusBarElementProgress(StatusBarElement, Field, Value, Appearance = 0,Min = 0,Max = 100)
  Declare StatusBarElementText(StatusBarElement, Field, Text$, Appearance = 0)
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ - StatusBar element functions
;-
Macro StatusBarElement() : *CreateElement\CreateStatusBarElement : EndMacro

Procedure AddStatusBarElementItem(Item, Width)
  Protected StatusBarElement
  
  With *CreateElement
    StatusBarElement  =  StatusBarElement()
    
    If IsStatusBarElement(StatusBarElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(StatusBarElement))
      
      Static w
      Static i : If Item  = - 1 : Item  =  i : i+1 : EndIf
      
      Item  =  AddElementItem(StatusBarElement, Item, Str(Width),-1,#_Flag_Border)
      
      If IsElementItem(Item)
        PushListPosition(\This()\Items()) 
        ChangeCurrentElement(\This()\Items(), ItemID(Item))
        \This()\Items()\FrameCoordinate\X  =  0
        \This()\Items()\FrameCoordinate\Y  =  0
        
        
        \This()\Items()\DrawingMode  =  #PB_2DDrawing_AlphaBlend
        \This()\Items()\Flag | #_State_Default
        \This()\Items()\FrameColor  =  \This()\FrameColor
        
        
        \This()\Items()\BackColor  =  \This()\BackColor
        \This()\Items()\FontColor  =  \This()\FontColor
        \This()\Items()\FrameColor  =  \This()\FrameColor
        
        \This()\Items()\FrameCoordinate\Height  =  \This()\FrameCoordinate\Height
        
        If Item = 65535
           w  =  Width
           \This()\Items()\FrameCoordinate\X  =  \This()\FrameCoordinate\Width-Width 
           
        Else
          \This()\Item\X + \This()\Item\Width
          \This()\Items()\FrameCoordinate\X  =  \This()\Item\X
          
          If Width  =  #PB_Ignore
            Width  =  ((\This()\FrameCoordinate\Width - w) - \This()\Item\X)-100
            
          EndIf
          
          \This()\Item\Width  =  Width
        EndIf
        
        \This()\Items()\FrameCoordinate\Width  =  Width
        
        PopListPosition(\This()\Items()) 
      EndIf
      
;       ChangeCurrentElement(\This()\Items(), ItemID(65535))
;       MoveElement(\This()\Items(), #PB_List_Last)
;       UpdateItemIndex()
      
      ;SortStructuredList(\This()\Items()    
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Item
EndProcedure

Procedure AddStatusBarElementField(Width)
  ProcedureReturn AddStatusBarElementItem(#PB_Any, Width)
EndProcedure

Procedure CreateStatusBarElement(StatusBarElement, Parent = #PB_Default)
  Protected PrevParent  = - 1, Height = 23
  
  With *CreateElement
    If IsElement(Parent) 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Parent))
      If \This()\StatusBarHeight
        \CreateStatusBarElement  = - 1
        ProcedureReturn 
      EndIf
      PopListPosition(\This())
      
      PrevParent  =  OpenElementList(Parent) 
      
      PushListPosition(\This())
      ForEach \This()
        If (\This()\Parent\Element = Parent)
;           If IsGadgetElement(\This()\Element) 
;             ResizeElement(\This()\Element, #PB_Ignore, \This()\FrameCoordinate\Y + Height, #PB_Ignore, #PB_Ignore, #False)
;           EndIf
        Else
          If Parent = \This()\Element And \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, \This()\FrameCoordinate\Height + Height + 4, #False)
            
            If ((\This()\FrameCoordinate\Height + Height)>ElementHeight(\This()\Parent\Element))
              ResizeElement(\This()\Parent\Element,#PB_Ignore,#PB_Ignore,#PB_Ignore,(Height+\This()\FrameCoordinate\Height+\This()\bSize*2), #False)
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(\This())
    EndIf
    
    
    StatusBarElement  =  CreateElement(#_Type_StatusBar, StatusBarElement,0,0,ElementWidth(\Parent, #_element_frameCoordinate),Height, "",-1,-1,-1, #_Flag_AlignLeft|#_Flag_AlignBottom|#_Flag_AlignRight)
    
    AddStatusBarElementItem(65535, 17)
    
    ; Bug
    ; If IsElement(Parent) : SetElementParent(StatusBarElement, Parent) : EndIf
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn StatusBarElement
EndProcedure

Procedure FreeStatusBarElement(StatusBarElement)
  If IsStatusBarElement(StatusBarElement)
    FreeElement(StatusBarElement)
  EndIf
EndProcedure

Procedure StatusBarElementHeight(StatusBarElement  =  #PB_Default)
  If StatusBarElement  =  #PB_Default 
    StatusBarElement  =  StatusBarElement() 
  EndIf
  
  If IsStatusBarElement(StatusBarElement)
    ProcedureReturn ElementHeight(StatusBarElement, #_Element_FrameCoordinate)
  EndIf
EndProcedure

Procedure StatusBarElementID(StatusBarElement)
  If IsStatusBarElement(StatusBarElement)
    ProcedureReturn ElementID(StatusBarElement)
  EndIf
EndProcedure

Procedure StatusBarElementImage(StatusBarElement, Field, Image, Appearance = 0)
EndProcedure

Procedure StatusBarElementProgress(StatusBarElement, Field, Value, Appearance = 0,Min = 0,Max = 100)
EndProcedure

Procedure StatusBarElementText(StatusBarElement, Field, Text$, Appearance = 0)
  Static Text.S
  Protected X,Y, TextWidth, TextHeight, Size  =  0
  Protected Flag.q  =  #_Flag_Border|#_Flag_Text_HCenter|#_Flag_Text_Left
  
  If Text.S <> Text$
    If Appearance  =  #PB_StatusBar_BorderLess
      Flag &~ #_Flag_Border
    EndIf
    
    If Appearance  =  #PB_StatusBar_Center
      Flag  =  Flag&~#_Flag_Text_Left
    ElseIf Appearance  =  #PB_StatusBar_Right
      Flag  =  Flag|#_Flag_Text_Right&~#_Flag_Text_Left
    EndIf
    
    With *CreateElement
      If IsStatusBarElement(StatusBarElement)
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(StatusBarElement))
        
        If IsElementItem(Field)
          PushListPosition(\This()\Items()) 
          ChangeCurrentElement(\This()\Items(), ItemID(Field))
          \This()\Items()\Text\String$  =  Text$
          \This()\Items()\Flag  =  Flag
          PopListPosition(\This()\Items()) 
        EndIf
        
        PopListPosition(\This())
      EndIf
    EndWith
  EndIf

EndProcedure
;}


;-
; StatusBar element bind event example
CompilerIf #PB_Compiler_IsMainFile
  Procedure StatusBarItemEvent(Event.q, EventElement)
    
    StatusBarElementText(StatusBarElement(), 1, "Area borderless :"+Str(EventElement())+" - "+EventClass(ElementEvent()), #PB_StatusBar_BorderLess)
  
  EndProcedure
CompilerEndIf


;-
; StatusBar element example
CompilerIf #PB_Compiler_IsMainFile
  ;Define d  =  OpenWindowElement(#PB_Any, 0,0, 840,620) 
  Define Window  =  OpenWindowElement(#PB_Any, 0,0, 540,120, "Demo StatusBarElement()");, #_Flag_SystemMenu|#_Flag_ScreenCentered|#_Flag_SizeGadget|#_Flag_MaximizeGadget) 
  ; good
  Define e  =  ContainerElement(#PB_Any, 10,10,280,100) : CloseElementList()
  e = ButtonElement(#PB_Any, 10,10,100,30,"Button",0,e)
  
  If CreateStatusBarElement(#PB_Any, Window)
    AddStatusBarElementField(90)
    AddStatusBarElementField(200)
    AddStatusBarElementField(#PB_Ignore) ; automatically resize this field
    AddStatusBarElementField(100)
    
    BindMenuElementEvent(StatusBarElement(), 1, @StatusBarItemEvent())
  EndIf
  
  StatusBarElementText(StatusBarElement(), 0, "Area normal")
  StatusBarElementText(StatusBarElement(), 1, "Area borderless", #PB_StatusBar_BorderLess)
  StatusBarElementText(StatusBarElement(), 2, "Area right", #PB_StatusBar_Right) 
  StatusBarElementText(StatusBarElement(), 3, "Area centered", #PB_StatusBar_Center)
  
  
  BindGadgetElementEvent(e,@StatusBarItemEvent());, #_Event_Focus)
  WaitWindowEventClose(Window)
CompilerEndIf
