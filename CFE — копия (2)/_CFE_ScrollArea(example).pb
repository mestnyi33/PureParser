; 05,04,2017 копия 
; TODO Вовремя изменения размера не правильно работает
CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;   - AddGadgetItem()      ; Add an Item. 
  ;   - GetGadgetItemText()  ; Returns the Gadget Item Text. 
  ;   - CountGadgetItems()   ; Count the items in the current ScrollArea. 
  ;   - ClearGadgetItems()   ; Remove all the items. 
  ;   - RemoveGadgetItem()   ; Remove an Item. 
  ;   - SetGadgetItemText()  ; Changes the Gadget Item Text. 
  ;   - SetGadgetItemImage() ; Changes the Gadget Item Image (need To be created With the #PB_ScrollArea_Image Flag). 
  ;   - GetGadgetState()     ; Get the Index (starting from 0) of the current Element, -1 If no Element added Or Not selected. 
  ;   - GetGadgetText()      ; Get the (Text) content of the current Element. 
  ;   - SetGadgetState()     ; Change the selected Element. 
  ;   - SetGadgetText()      ; Set the displayed Text. If the ScrollAreaGadget is Not editable, the Text must be in the dropdown List. 
  ;   - GetGadgetItemData()  ; Returns the value that was stored With Item. 
  ;   - SetGadgetItemData()  ; Stores a value With the Item. 
  
  XIncludeFile "CFE.pbi"
CompilerEndIf

Global dbs = 8

;{ Window element functions
Procedure DrawScrollAreaElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height
  
  With *CreateElement\This()
    
    If ListSize(\Items())
      X = \InnerCoordinate\X
      Y = (\FrameCoordinate\Y+\bSize)
      
      PushListPosition(\Items())
      ForEach \Items()
        If \IsVertical
          
          \Items()\FrameCoordinate\X = \InnerCoordinate\Width-\Scroll\ButtonSize
          \Items()\FrameCoordinate\Width = \Scroll\ButtonSize
          \Items()\FrameCoordinate\Height = \Scroll\ButtonSize
          
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\Y = 0
            
          ElseIf ListIndex(\Items()) = 1 
            \Items()\FrameCoordinate\Y = \InnerCoordinate\Height-\Items()\FrameCoordinate\Height
            
          ElseIf ListIndex(\Items()) = 2
            \Items()\FrameCoordinate\Y = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Height = \Scroll\ThumbSize
          EndIf
        Else
          
          \Items()\FrameCoordinate\Y = 1
          \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - 2
          \Items()\FrameCoordinate\Width = \Scroll\ButtonSize
          
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\X = 0
            
          ElseIf ListIndex(\Items()) = 1 
            \Items()\FrameCoordinate\X = \InnerCoordinate\Width-\Items()\FrameCoordinate\Width
            
          ElseIf ListIndex(\Items()) = 2
            \Items()\FrameCoordinate\X = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Width = \Scroll\ThumbSize
          EndIf
        EndIf
        
        DrawContent(\Items(), X,Y)
      Next
      PopListPosition(\Items())
    EndIf
    
  EndWith
EndProcedure

Procedure.q SetScrollAreaElementFlag(Flag.q)
  Protected Result.q = Flag
  ; 1  - #PB_ScrollArea_Flat                ; Flat frame.
  ; 2  - #PB_ScrollArea_Raised              ; Raised frame (Default).
  ; 4  - #PB_ScrollArea_Single              ; Single sunken frame.
  ; 8  - #PB_ScrollArea_BorderLess          ; Without any border
  ; 16 - #PB_ScrollArea_Center              : If the inner Size is smaller than the outer, the inner area is automatically centered.
  
  Select Flag
    Case #PB_ScrollArea_BorderLess 
      Result &~ #PB_ScrollArea_BorderLess
      Result | #_Flag_BorderLess
    Default
      If ((Flag & #PB_ScrollArea_Flat) = #PB_ScrollArea_Flat)
        Result &~ #PB_ScrollArea_Flat
        Result | #_Flag_Flat
      ElseIf ((Flag & #PB_ScrollArea_Single) = #PB_ScrollArea_Single)
        Result &~ #PB_ScrollArea_Single
        Result | #_Flag_Single
        ;       ElseIf ((Flag & #PB_ScrollArea_Double) = #PB_ScrollArea_Double)
        ;         Result = #_Flag_Double
      ElseIf ((Flag & #PB_ScrollArea_Raised) = #PB_ScrollArea_Raised)
        Result &~ #PB_ScrollArea_Raised
        Result | #_Flag_Raised
      EndIf
  EndSelect
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetScrollAreaElementFlag(Flag.q)
  Protected Result.q = Flag
  
  If ((Flag & #_Flag_BorderLess) = #_Flag_BorderLess)
    Result = #PB_ScrollArea_BorderLess
  ElseIf ((Flag & #_Flag_Flat) = #_Flag_Flat)
    Result = #PB_ScrollArea_Flat
  ElseIf ((Flag & #_Flag_Single) = #_Flag_Single)
    Result = #PB_ScrollArea_Single
    ;   ElseIf ((Flag & #_Flag_Double) = #_Flag_Double)
    ;     Result = #PB_ScrollArea_Double
  ElseIf ((Flag & #_Flag_Raised) = #_Flag_Raised)
    Result = #PB_ScrollArea_Raised
  EndIf
  
  ProcedureReturn Result
EndProcedure


;- PRIVATE
Procedure ScrollAreaBarEvent(Event.q, EventElement)
  
  Select Event
    Case #_Event_Up, #_Event_Down
      With *CreateElement
        Protected IsVertical = Bool((\This()\Flag&#_Flag_Vertical)=#_Flag_Vertical) 
        
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
        
        If IsVertical
          SetScrollAreaElementAttribute(\This(), #PB_ScrollArea_Y, GetElementState(EventElement))
        Else
          SetScrollAreaElementAttribute(\This(), #PB_ScrollArea_X, GetElementState(EventElement))
        EndIf
        
        If \This()\Element
          PostEventElement(#_Event_Change, \This()\Element, EventElement)
        EndIf
        PopListPosition(\This())    
      EndWith
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure ResizeScrollVert(List This.S_CREATE_ELEMENT(), Height, bSize)
  
  With This()
    If IsElement(\Scroll\Vert)
      ResizeElement(\Scroll\Vert, #PB_Ignore, #PB_Ignore, #PB_Ignore, Height, #PB_Ignore)
      
      PushListPosition(This())    
      ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
      SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, Height+\FrameCoordinate\Width+bSize)
      SetScrollBarElementState(Height)
      PopListPosition(This())    
    EndIf
  EndWith
  
EndProcedure

Procedure ResizeScrollHorz(List This.S_CREATE_ELEMENT(), Width, bSize)
  
  With This()
    If IsElement(\Scroll\Horz)
      
      PushListPosition(This())    
      ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
      SetScrollBarElementAttribute(This(), #PB_ScrollBar_PageLength, Width+\FrameCoordinate\Height+bSize)
      SetScrollBarElementState(Width)
      PopListPosition(This())  
      
      ResizeElement(\Scroll\Horz, #PB_Ignore, #PB_Ignore, Width, #PB_Ignore, #PB_Ignore)
      
    EndIf
  EndWith
  
EndProcedure

Procedure ScrollAreaSizeEvent(Event.q, EventElement)
  Protected bSize, IsVertical, Bs, Vb,Hb,X,Y,Width, Height,iWidth, iHeight, ElementWidth, ElementHeight 
  
  Select Event ; ElementEvent()
    Case #_Event_Size ;: Debug EventClass(Event)
      With *CreateElement\This()
        Bs = \bSize
        bSize = \bSize
        X=\InnerCoordinate\X
        Y=\InnerCoordinate\Y
        Width=\FrameCoordinate\Width
        Height=\FrameCoordinate\Height
        
        iWidth=\InnerCoordinate\Width
        iHeight=\InnerCoordinate\Height
        
        PushListPosition(*CreateElement\This())
        If IsElement(\Scroll\Element)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Element))
        EndIf
        
        If IsElement(\Scroll\Horz)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Horz))
          
          ResizeElement(\Element, #PB_Ignore, (Y+iHeight)-\FrameCoordinate\Height, iWidth-ElementWidth(\Scroll\Vert), #PB_Ignore, #PB_Ignore)
          ;SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Width)
          
          If \Scroll\Max =< Width
            \HideState = 1
            \Hide = 1
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight, #PB_Ignore)
            ResizeScrollVert(*CreateElement\This(), iHeight, bSize*2)
          Else 
            \HideState = 0
            \Hide = 0
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, (iHeight-\FrameCoordinate\Height), #PB_Ignore)
            ResizeScrollVert(*CreateElement\This(), (iHeight-\FrameCoordinate\Height), bSize*2)
          EndIf
          
        EndIf
        
        If IsElement(\Scroll\Vert)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Vert))
          
          ResizeElement(\Element, (X+iWidth)-\FrameCoordinate\Width, #PB_Ignore, #PB_Ignore, (iHeight-ElementHeight(\Scroll\Horz)), #PB_Ignore)
          ;SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Height)
          
          If \Scroll\Max =< Height
            \HideState = 1
            \Hide = 1
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore, #PB_Ignore)
            ResizeScrollHorz(*CreateElement\This(), iWidth, bSize*2)
          Else 
            \HideState = 0
            \Hide = 0
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, (iWidth-\FrameCoordinate\Width), #PB_Ignore, #PB_Ignore)
            ResizeScrollHorz(*CreateElement\This(), (iWidth-\FrameCoordinate\Width), bSize*2)
          EndIf
          
        EndIf
        
        PopListPosition(*CreateElement\This())    
        
        
      EndWith
  EndSelect
  
  ProcedureReturn #True
EndProcedure

Procedure _ScrollAreaSizeEvent(Event.q, EventElement)
  Protected IsVertical, Bs, Vb,Hb,X,Y,Width, Height,iWidth, iHeight, ElementWidth, ElementHeight
  
  Select ElementEvent()
    Case #_Event_Size
      With *CreateElement\This()
        Bs = \bSize
        X=\InnerCoordinate\X
        Y=\InnerCoordinate\Y
        Width=\FrameCoordinate\Width
        Height=\FrameCoordinate\Height
        
        iWidth=\InnerCoordinate\Width
        iHeight=\InnerCoordinate\Height
        
        PushListPosition(*CreateElement\This())
        If IsElement(\Scroll\Element)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Element))
          ElementHeight = \FrameCoordinate\Height
          ElementWidth = \FrameCoordinate\Width
          
          If ElementWidth<iWidth : Hb = 0 : Else : Hb = 17 : EndIf
          If ElementHeight<iHeight : Vb = 0 : Else : Vb = 17 : EndIf
        EndIf
        
        If IsElement(\Parent\Element)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Parent\Element))
          \FrameCoordinate\Height = iHeight-Hb
          \FrameCoordinate\Width = iWidth-Vb
          ResizeElementY(*CreateElement\This())
          ResizeElementX(*CreateElement\This())
        EndIf
        
        ChangeCurrentElement(*CreateElement\This(), ElementID(EventElement))
        If Hb = 0 
          SetScrollAreaElementAttribute(*CreateElement\This(), #PB_ScrollArea_X, 0)
        EndIf
        If Vb = 0
          SetScrollAreaElementAttribute(*CreateElement\This(), #PB_ScrollArea_Y, 0)
        EndIf
        
        If IsElement(\Scroll\Vert)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Vert))
          \FrameCoordinate\X = X+iWidth-\FrameCoordinate\Width
          ResizeElementX(*CreateElement\This(), \FrameCoordinate\X)
          \FrameCoordinate\Height = iHeight-Hb
          ResizeElementY(*CreateElement\This())
          
          SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Height)
          If Vb
            \Hide=0
          Else
            \Hide=1
          EndIf
        EndIf
        
        If IsElement(\Scroll\Horz)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Horz))
          \FrameCoordinate\Y = Y+iHeight-\FrameCoordinate\Height
          ResizeElementY(*CreateElement\This(), \FrameCoordinate\Y)
          \FrameCoordinate\Width = iWidth-Vb
          ResizeElementX(*CreateElement\This())
          SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Width)
          If Hb
            \Hide=0
          Else
            \Hide=1
          EndIf
        EndIf
        
        PopListPosition(*CreateElement\This())    
        
        
      EndWith
  EndSelect
  
  ProcedureReturn #True
EndProcedure



;- PUBLIC
Procedure GetScrollAreaElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
  Protected Result
  
  With This()
    Select Attribute
      Case #PB_ScrollArea_X           : Result = \Linked\Area\X
      Case #PB_ScrollArea_Y           : Result = \Linked\Area\Y
      Case #PB_ScrollArea_InnerWidth  : Result = \Linked\Area\Width
      Case #PB_ScrollArea_InnerHeight : Result = \Linked\Area\Height
      Case #PB_ScrollArea_ScrollStep  : Result = \Scroll\ScrollStep
    EndSelect
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetScrollAreaElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)
  Protected iX,iY,iWidth,iHeight, bSize
  Protected Update, X=#PB_Ignore,Y=#PB_Ignore,Width=#PB_Ignore,Height=#PB_Ignore 
  Protected ScrollAreaElement
  
  With This()
    ScrollAreaElement = \Scroll\Element
    bSize = \bSize
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    Select Attribute
      Case #PB_ScrollArea_X
        If \Linked\Area\X <> Value : \Linked\Area\X = Value
          If IsElement(\Scroll\Horz)
            PushListPosition(This())
            ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
            Value = SetScrollBarElementState(Value)
            PopListPosition(This())
          EndIf
          
          Update = #True
          X=-Value
        EndIf
        
      Case #PB_ScrollArea_Y
        If \Linked\Area\Y <> Value : \Linked\Area\Y = Value
          If IsElement(\Scroll\Vert)
            PushListPosition(This())
            ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
            Value = SetScrollBarElementState(Value)
            PopListPosition(This())
          EndIf
          
          Update = #True
          Y=-Value
        EndIf
        
      Case #PB_ScrollArea_InnerWidth
        If \Linked\Area\Width <> Value : \Linked\Area\Width = Value
          If IsElement(\Scroll\Horz)
            PushListPosition(This())
            ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
            
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, (Value+ElementWidth(\Scroll\Vert)+bSize*2))
            
            If Value < \Scroll\PageLength 
              \Hide = 1
              ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight, #PB_Ignore)
              ResizeElement(\Scroll\Vert, #PB_Ignore, #PB_Ignore, #PB_Ignore, iHeight, #PB_Ignore)
            Else 
              \Hide = 0
              ResizeElement(\Element, #PB_Ignore, (\FrameCoordinate\Height+iHeight)+1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, (iHeight-\FrameCoordinate\Height), #PB_Ignore)
              ResizeElement(\Scroll\Vert, #PB_Ignore, #PB_Ignore, #PB_Ignore, (iHeight-\FrameCoordinate\Height), #PB_Ignore)
            EndIf
            
            PopListPosition(This())
          EndIf
          
          Update = #True
          Width=Value
        EndIf
        
      Case #PB_ScrollArea_InnerHeight
        If \Linked\Area\Height <> Value : \Linked\Area\Height = Value
          If IsElement(\Scroll\Vert)
            PushListPosition(This())
            ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
            
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, (Value+ElementHeight(\Scroll\Horz)+bSize*2))
            
            If Value < \Scroll\PageLength 
              \Hide = 1
              ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore, #PB_Ignore)
              ResizeElement(\Scroll\Horz, #PB_Ignore, #PB_Ignore, iWidth, #PB_Ignore, #PB_Ignore)
            Else 
              \Hide = 0
              ResizeElement(\Element, (\FrameCoordinate\Width+iWidth)+1, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
              ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, (iWidth-\FrameCoordinate\Width), #PB_Ignore, #PB_Ignore)
              ResizeElement(\Scroll\Horz, #PB_Ignore, #PB_Ignore, (iWidth-\FrameCoordinate\Width), #PB_Ignore, #PB_Ignore)
            EndIf
            
            PopListPosition(This())
          EndIf
          
          Update = #True
          Height=Value
        EndIf
        
      Case #PB_ScrollArea_ScrollStep
        If \Scroll\ScrollStep <> Value : \Scroll\ScrollStep = Value
          PushListPosition(This())
          If IsElement(\Scroll\Vert)
            ChangeCurrentElement(This(), ElementID(\Scroll\Vert)) : \Scroll\ScrollStep = Value
          EndIf
          If IsElement(\Scroll\Horz)
            ChangeCurrentElement(This(), ElementID(\Scroll\Horz))  : \Scroll\ScrollStep = Value
          EndIf
          PopListPosition(This())
        EndIf
        
    EndSelect
    
    If Update
      ResizeElement(ScrollAreaElement, X,Y,Width,Height)
    EndIf
  EndWith
  
EndProcedure


Procedure ScrollAreaElement( Element, X,Y,Width,Height, ScrollAreaWidth,ScrollAreaHeight, ScrollStep, Flag.q = #_Flag_Double, Parent =- 1 )
  Protected Type, iWidth = Width, iHeight = Height 
  Protected ScrollAreaElement, ScrollHeightElement, ScrollWidthElement
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  Protected ScrollBarSize = 17
  
  Flag = SetScrollAreaElementFlag(Flag)
  
  ; Border type then draw
  If ((Flag & #_Flag_Flat) = #_Flag_Flat)
    dbs=2
  EndIf
  If (((Flag & #_Flag_Double) = #_Flag_Double) Or
      ((Flag & #_Flag_Raised) = #_Flag_Raised))
    dbs=4
  EndIf
  If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
    dbs=8
  EndIf
  dbs+1
  
  Element = CreateElement( #_Type_ScrollArea, Element, X,Y,Width,Height,"", -1, -1, -1, Flag)
  BindGadgetElementEvent(Element, @ScrollAreaSizeEvent(), #_Event_Size)
  
  If ScrollAreaWidth > Width : iHeight - ScrollBarSize : EndIf
  If ScrollAreaHeight > Height : iWidth - ScrollBarSize : EndIf
  
  If ScrollAreaHeight < Height
    ScrollAreaHeight = Height
  EndIf
  
  If ScrollAreaWidth < Width
    ScrollAreaWidth = Width
  EndIf
  
  
  Protected Container = ContainerElement(#PB_Any,0,0,iWidth-dbs,iHeight-dbs, #_Flag_BorderLess);|#_Flag_AlignFull)  
  ScrollAreaElement = ContainerElement(#PB_Any,0,0, ScrollAreaWidth,ScrollAreaHeight, #_Flag_BorderLess) : CloseElementList() 
  CloseElementList()
  
  ScrollHeightElement = ScrollBarElement(#PB_Any, iWidth-dbs,0,ScrollBarSize,iHeight-dbs, 0, ScrollAreaHeight+ScrollBarSize+dbs, Height,#_Flag_Vertical|#_Flag_BorderLess);|#_Flag_DockRight)
  SetElementData(ScrollHeightElement, Element)
  BindGadgetElementEvent(ScrollHeightElement, @ScrollAreaBarEvent(), #_Event_Up|#_Event_Down)
  
  ScrollWidthElement = ScrollBarElement(#PB_Any, 0,iHeight-dbs,iWidth-dbs,ScrollBarSize, 0, ScrollAreaWidth+ScrollBarSize+dbs, Width,#_Flag_BorderLess);|#_Flag_DockBottom)
  SetElementData(ScrollWidthElement, Element)
  BindGadgetElementEvent(ScrollWidthElement, @ScrollAreaBarEvent(), #_Event_Up|#_Event_Down)
  
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Type = \This()\Type
    
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\Vert = ScrollHeightElement
    \This()\Scroll\Horz = ScrollWidthElement
    
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Container))
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\Vert = ScrollHeightElement
    \This()\Scroll\Horz = ScrollWidthElement
    
    ChangeCurrentElement(\This(), ElementID(ScrollAreaElement))
    \This()\Scroll\Element = Element
    \This()\Scroll\Vert = ScrollHeightElement
    \This()\Scroll\Horz = ScrollWidthElement
    
    ChangeCurrentElement(\This(), ElementID(ScrollWidthElement))
    \This()\Scroll\Element = Container
    \This()\Scroll\ScrollStep = ScrollStep
    \This()\Scroll\Vert = ScrollHeightElement
    
    If ScrollAreaWidth = Width
      \This()\Scroll\Pos = 0
      \This()\Hide = 1
    EndIf
    
    ChangeCurrentElement(\This(), ElementID(ScrollHeightElement))
    \This()\Scroll\Element = Container
    \This()\Scroll\ScrollStep = ScrollStep
    \This()\Scroll\Horz = ScrollWidthElement
    
    If ScrollAreaHeight = Height
      \This()\Hide = 1
    EndIf
    PopListPosition(\This())
    
    PopListPosition(\This())         
    
    OpenElementList(ScrollAreaElement)
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  Define Sw = 300, Sh = 200
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  Time = ElapsedMilliseconds()
  
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Procedure ScrollAreaGadgetEvent()
    ;     Select EventType()
    ;       Case #PB_EventType_Down
    ;         Debug Str(EventGadget())+" - Down"
    ;       Case #PB_EventType_Up
    ;         Debug Str(EventGadget())+" - Up"
    ;       Case #PB_EventType_Change
    Debug Str(GetGadgetState(EventGadget()))+" - scroll gadget change"
    ;     EndSelect
  EndProcedure
  
  OpenWindow(1, 10,10,400,490, "SystemMenu", #PB_Window_SystemMenu)
  ;SetWindowColor(1, $8C9C65)
  ScrollAreaGadget(10,10,10,280+dbs,170+dbs, Sw, Sh, 5, #PB_ScrollArea_Flat)
    Define g = 10
    ButtonGadget  (1, 10, 10, 230, 30,"Button 1")
    ButtonGadget  (2, 50, 50, 230, 30,"Button 2")
    ButtonGadget  (3, 90, 90, 230, 30,"Button 3")
    TextGadget    (4,130,130, 230, 20,"This is the content of a ScrollAreaGadget!",#PB_Text_Right)
    
    ;     Define i
    ;     For i=0 To 1000
    ;       ButtonGadget  (-1, 575-130, 555-30, 130, 30,"Button 3"+Str(i))
    ;     Next
    
    ButtonGadget  (5, Sw-130, Sh-30, 130, 30,"Button 3")
  CloseGadgetList()
  
  Define g32 = ButtonGadget   (#PB_Any, 10,70,163,25, "32ButtonElement")
  Define g3 = SplitterGadget  (#PB_Any, 10,10,280+dbs,355, g,g32, #PB_Splitter_Separator)
  
  BindGadgetEvent(g, @ScrollAreaGadgetEvent());, #PB_EventType_LeftClick)
  
  
  OpenWindowElement(1, 20,20,400+8,490+8, "BorderLess", #_Flag_SizeGadget|#_Flag_MoveGadget|#_Flag_BorderLess) ; |#PB_Window_MoveGadget
                                                                                                               ;SetWindowElementColor(1, $8C9C65)
  
  Procedure ScrollAreaElementEvent(Event.q, EventElement)
   Select EventElement
   Case 10
   Select Event;ElementEvent()
      Case #_Event_LeftClick
        Debug EventElement
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementAttribute(EventElement, #PB_ScrollArea_X))+" - scroll element change"
        ;SetGadgetAttribute(10, #PB_ScrollArea_X, GetElementState(EventElementItem()))
        
        SetGadgetAttribute(10, #PB_ScrollArea_X, GetElementAttribute(EventElement, #PB_ScrollArea_X))
        SetGadgetAttribute(10, #PB_ScrollArea_Y, GetElementAttribute(EventElement, #PB_ScrollArea_Y))
        
    EndSelect
     EndSelect
    ;Debug GetElementState(EventElementItem())
    
  EndProcedure
  
  ;Define e=ButtonElement  (11, 10,10,272+dbs,162+dbs,"Button 1",#_Flag_MoveGadget|#_Flag_SizeGadget)
  
  If dbs
    Define Flag = #_Flag_AnchorGadget
  EndIf
  
  Define e=ScrollAreaElement(10,10-dbs/2,10-dbs/2,280+dbs,170+dbs, Sw, Sh, 5, Flag|#PB_ScrollArea_Flat);|#_Flag_MoveGadget)
  ButtonElement  (11, 10, 10, 230, 30,"Button 1")
  ButtonElement  (12, 50, 50, 230, 30,"Button 2")
  ButtonElement  (13, 90, 90, 230, 30,"Button 3")
  TextElement    (14,130,130, 230, 20,"This is the content of a ScrollAreaElement!",#_Flag_Text_Right)
  ;       Define i
  ;       For i=0 To 1000
  ;         ButtonElement  (-1, 575-130, 555-30, 130, 30,"Button 3"+Str(i))
  ;       Next
  ButtonElement  (15, Sw-130, Sh-30, 130, 30,"Button 3"+Str(i))
  CloseElementList()
  
  ;   SetElementAttribute(10, #PB_ScrollArea_InnerWidth, 575)
  ;   SetElementAttribute(10, #PB_ScrollArea_InnerHeight, 555)
  
  
  
;   Define e32 = ButtonElement(#PB_Any, 10,70,163,25, "32ButtonElement")
;   Define e43 = SplitterElement(#PB_Any, 10,10,280,340, e,e32, #_Flag_Separator|Flag)
;   ;Define e43 = SplitterElement(#PB_Any, 10,10,355,180, e,e32, #_Flag_Vertical|#_Flag_Separator|Flag)
  
  ;   Define e42 = ButtonElement(#PB_Any, 10,70,163,25, "32ButtonElement")
  ;   Define e5 = SplitterElement(#PB_Any, 10,10,500,355, e43,e42, #_Flag_Vertical|#_Flag_Separator|Flag)
  
  SetElementAttribute(10, #PB_ScrollArea_X, 100)
  SetElementAttribute(10, #PB_ScrollArea_Y, 100)
  
  ;ButtonElement(#PB_Any, 210, 30, 130, 12,"demo close list"+Str(i))
  
  
  ;BindGadgetElementEvent(e,@ScrollAreaElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  BindEventElement(@ScrollAreaElementEvent(), -1, -1, #_Event_Change|#_Event_Up|#_Event_Down)
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  
  WaitWindowEventClose(Window)
CompilerEndIf



