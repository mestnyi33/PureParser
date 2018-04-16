CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  
  ; - The following functions can be used To act on this Element: 
  
  ; - GetElementColor()
  ; - SetElementColor()
  ; - ElementToolTip()          ; A 'mini help' can be added To this Element using . 
  
  ; - GetElementState()         ; Returns the current slider Position (value between 'Minimum' And 'Maximum - PageLength + 1' range). 
  ; - SetElementState()         ; Changes the current slider Position. 
  
  ; - GetElementAttribute()     ; With one of the following attributes ; 
  ;   #PB_ScrollBar_Minimum     ; Returns the minimum scroll Position.
  ;   #PB_ScrollBar_Maximum     ; Returns the maximum scroll Position.
  ;   #PB_ScrollBar_PageLength  ; Returns the PageLength value.
  
  ; - SetElementAttribute()     ; With one of the following attributes ; 
  ;   #PB_ScrollBar_Minimum     ; Changes the minimum scroll Position.
  ;   #PB_ScrollBar_Maximum     ; Changes the maximum scroll Position.
  ;   #PB_ScrollBar_PageLength  ; Changes the PageLength value.
  
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ ScrollBar element functions
Procedure DrawScrollBarElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height
  
  With *CreateElement\This()
    
    If ListSize(\Items())
      X = \InnerCoordinate\X
      Y = (\FrameCoordinate\Y+\bSize)
      
      PushListPosition(\Items())
      ForEach \Items()
        If \IsVertical
          
          \Items()\FrameCoordinate\X = 1
          \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - 2
          \Items()\FrameCoordinate\Height = \Scroll\ButtonSize-1
          
          ; Верхняя кнопка на скролл баре
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\Y = 1
            
            ; Нижняя кнопка на скролл баре
          ElseIf ListIndex(\Items()) = 1 
            \Items()\FrameCoordinate\Y = \InnerCoordinate\Height-\Items()\FrameCoordinate\Height-1
            
          ; Ползунок на скролл баре
          ElseIf ListIndex(\Items()) = 2
            \Items()\FrameCoordinate\Y = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Height = \Scroll\ThumbSize
          EndIf
        Else
          
          \Items()\FrameCoordinate\Y = 1
          \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - 2
          \Items()\FrameCoordinate\Width = \Scroll\ButtonSize-1
          
          ; Верхняя кнопка на скролл баре
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\X = 1
            
          ; Нижняя кнопка на скролл баре
          ElseIf ListIndex(\Items()) = 1 
            \Items()\FrameCoordinate\X = \InnerCoordinate\Width-\Items()\FrameCoordinate\Width-1
            
          ; Ползунок на скролл баре
          ElseIf ListIndex(\Items()) = 2
            \Items()\FrameCoordinate\X = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Width = \Scroll\ThumbSize
          EndIf
        EndIf
        
       
        DrawContent(\Items(), X,Y)
        
        If ListIndex(\Items()) = 2
          DrawingMode(#PB_2DDrawing_Default)
          If \IsVertical
            ;  Box(X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,11, 11,0)
            Line(X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,2+Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,11, 1,\FrameColor)
            Line(X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,2+Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2+3,11, 1,\FrameColor)
            Line(X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,2+Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2+6,11, 1,\FrameColor)
          Else
            ;Line(X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,11, 11,0)
            Line(2+X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2,Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,1, 11,\FrameColor)
            Line(2+X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2+3,Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,1, 11,\FrameColor)
            Line(2+X+\Items()\FrameCoordinate\X+(\Items()\FrameCoordinate\Width-11)/2+6,Y+\Items()\FrameCoordinate\Y+(\Items()\FrameCoordinate\Height-11)/2,1, 11,\FrameColor)
          EndIf
      EndIf
       Next
      PopListPosition(\Items())
    EndIf
    
  EndWith
EndProcedure

Procedure.q SetScrollBarElementFlag(Flag.q)
  Protected Result.q = Flag
  ProcedureReturn Result
EndProcedure

Procedure.q GetScrollBarElementFlag(Flag.q)
  Protected Result.q = Flag
  ProcedureReturn Result
EndProcedure


;-
;- PRIVATE
Procedure SetScrollStep(List This.S_CREATE_ELEMENT(), ScrollStep)
  This()\Scroll\ScrollStep = ScrollStep 
EndProcedure

Procedure UpdateScrollPos(List This.S_CREATE_ELEMENT(), ThumbPos)
  Protected Result
  
  With This()
    Result = Round((ThumbPos - \Scroll\ButtonSize - \bSize) / (\Scroll\Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest)
    
    If (\IsVertical And \Type = #_Type_TrackBar) 
      Result = ((\Scroll\Max-\Scroll\Min)-Result)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateScrollThumbSize(List This.S_CREATE_ELEMENT(), Area)
  With This()
    If (\Scroll\Max-\Scroll\Min) > \Scroll\PageLength
      Area = Round(Area - (Area / (\Scroll\Max-\Scroll\Min))*((\Scroll\Max-\Scroll\Min) - \Scroll\PageLength), #PB_Round_Nearest)
    EndIf
  EndWith

 ProcedureReturn Area
EndProcedure

Procedure UpdateScrollThumbPos(List This.S_CREATE_ELEMENT(), ScrollPos, Area)
  Protected Result 
  
  With This()
    
    If ScrollPos =< 0
      Result = \Scroll\ButtonSize 
      \Scroll\Pos = 0
    Else
      If ScrollPos>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
        \Scroll\Pos=((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
        ScrollPos=\Scroll\Pos
      EndIf
      
      Result = (\Scroll\ButtonSize + Round(ScrollPos * (Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest))
      
      If \IsVertical
        If (Result+\Scroll\ThumbSize) > (\InnerCoordinate\Height-\Scroll\ButtonSize)
          Result = \InnerCoordinate\Height - \Scroll\ButtonSize - \Scroll\ThumbSize
        EndIf
      Else
        If (Result+\Scroll\ThumbSize) > (\InnerCoordinate\Width-\Scroll\ButtonSize)
          Result = \InnerCoordinate\Width - \Scroll\ButtonSize - \Scroll\ThumbSize
        EndIf
      EndIf
    EndIf
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateScrollCoordinate(List This.S_CREATE_ELEMENT())
  Protected Area, Result, ButtonSize 
  
  With This()
    If \IsVertical
      \Scroll\Area = \InnerCoordinate\Height - \Scroll\ButtonSize*2 
    Else
      \Scroll\Area = \InnerCoordinate\Width - \Scroll\ButtonSize*2 
    EndIf
    
    Area = \Scroll\Area
    ButtonSize = \Scroll\ButtonSize
    
    If \Scroll\Max = 0 : \Scroll\Max = Area : EndIf
    If \Scroll\PageLength = 0 : \Scroll\PageLength = 25 : EndIf
    
    Result = UpdateScrollThumbSize(This(), Area)
    
    If (Area > ButtonSize)
      If (Result < ButtonSize)
        Area = Round(\Scroll\Area - (ButtonSize-Result), #PB_Round_Nearest)
        Result = ButtonSize 
      EndIf
    Else
      Result = Area 
    EndIf
    
    \Scroll\ThumbSize = Result
        
    If Area > 0
      \Scroll\ThumbPos = UpdateScrollThumbPos(This(), \Scroll\Pos, Area)
    EndIf
  EndWith
  
EndProcedure

Procedure SetScrollState(List This.S_CREATE_ELEMENT(), State)
  Protected Result, rb = 0 ; Регулируем конец прокрутки
      
  With This()
    If (\IsVertical And \Type = #_Type_TrackBar)
      State = (\Scroll\Max-\Scroll\Min)-State
    EndIf
    
    If (State<\Scroll\Min) : State = \Scroll\Min : EndIf
    
    If \Scroll\Pos <> State
      If (\Scroll\Pos > State) : Result = 1 : Else : Result =- 1 : EndIf  
      
      If State>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)+rb
        State=((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)+rb
      EndIf
      
      If State <> \Scroll\Pos : \Scroll\Pos = State
        UpdateScrollCoordinate(This())
      Else
        Result = 0
      EndIf                
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateScrolls(List This.S_CREATE_ELEMENT())
  Protected iX,iY,iWidth,iHeight, HorzHeight, VertWidth, ColumnHeight
 ; ProcedureReturn 
  With This()
    If Not \IsContainer ; Для лист виев
      iX = \InnerCoordinate\X 
      iY = \InnerCoordinate\Y 
      iWidth = \InnerCoordinate\Width 
      iHeight = \InnerCoordinate\Height
      ;ColumnHeight = \Column\Height;-(\bSize)*2 - 1
      
      If IsElement(\Scroll\Horz)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
        
        If \Scroll\Max > \FrameCoordinate\Width
          HorzHeight = \FrameCoordinate\Height
          \HideState = 0
          \Hide = 0
        Else
          \HideState = 1
          \Hide = 1
        EndIf
        
        PopListPosition(This())
      EndIf
      
      If IsElement(\Scroll\Vert)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
        
        If \Scroll\Max > \FrameCoordinate\Height
          VertWidth = \FrameCoordinate\Width
          \HideState = 0
          \Hide = 0
        Else
          \HideState = 1
          \Hide = 1
        EndIf
        
        PopListPosition(This())
      EndIf
      
      If IsElement(\Scroll\Horz)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
        
        \FrameCoordinate\Width = iWidth-VertWidth : ResizeElementX(This())
        \FrameCoordinate\X = iX : ResizeElementX(This(), \FrameCoordinate\X)
        \FrameCoordinate\Y = (iY+iHeight)-\FrameCoordinate\Height : ResizeElementY(This(), \FrameCoordinate\Y)
        \Scroll\PageLength = \FrameCoordinate\Width
        
        UpdateScrollCoordinate(This())
        PopListPosition(This())
      EndIf
      
      If IsElement(\Scroll\Vert)
        PushListPosition(This())
        ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
        
        \FrameCoordinate\Height = iHeight-HorzHeight : ResizeElementY(This())
        \FrameCoordinate\Y = iY : ResizeElementY(This(), \FrameCoordinate\Y)
        \FrameCoordinate\X = (iX+iWidth)-\FrameCoordinate\Width : ResizeElementX(This(), \FrameCoordinate\X)
        \Scroll\PageLength = \FrameCoordinate\Height-ColumnHeight
        
        UpdateScrollCoordinate(This())
        PopListPosition(This())
      EndIf
      
    EndIf
    
  EndWith
  
EndProcedure


;-
;- PUBLIC
Procedure SetScrollBarElementState(State)
  Protected Result, PostEvent.q, Min, Max, PageLength, IsVertical
  
  With *CreateElement
      State = SetScrollState(\This(), State)
      
      Select State 
        Case   1 : PostEvent = #_Event_Up
        Case - 1 : PostEvent = #_Event_Down 
      EndSelect
      
      Result = \This()\Scroll\Pos
      
      ; 
      If IsElement(\This()\Scroll\Element) And Not IsContainerElement(\This()\Scroll\Element)
        
        IsVertical = Bool((\This()\Flag&#_Flag_Vertical)=#_Flag_Vertical) 
        
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(\This()\Scroll\Element))
          Min = \This()\Scroll\Min
          Max = \This()\Scroll\Max
          
          If IsVertical
            \This()\Scroll\PosY = Result
            PageLength = \This()\InnerCoordinate\Height 
          Else
            \This()\Scroll\PosX = Result
            PageLength = \This()\InnerCoordinate\Width 
          EndIf
        PopListPosition(\This())
        
;         \This()\Scroll\Min = Min
;         \This()\Scroll\Max = Max
;         \This()\Scroll\PageLength = PageLength
      EndIf
      
      If PostEvent
        PostEventElement(PostEvent, \This()\Element, \This()\Items()\Element)
        
        ElementDrawCallBack(\This()\Element)
      EndIf 
    EndWith
    
    ProcedureReturn Result
EndProcedure

Procedure GetScrollBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
  Protected Result
  
  With This()
    Select Attribute
      Case #PB_ScrollBar_Minimum    : Result = \Scroll\Min
      Case #PB_ScrollBar_Maximum    : Result = \Scroll\Max
      Case #PB_ScrollBar_PageLength : Result = \Scroll\PageLength
    EndSelect
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetScrollBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)
  Protected Update 
  
  With This()
    
    Select Attribute
      Case #PB_ScrollBar_Minimum
        If \Scroll\Min <> Value
          \Scroll\Min = Value
          Update = #True
        EndIf
        
      Case #PB_ScrollBar_Maximum
        If \Scroll\Max <> Value
          If \Scroll\Min > Value
            \Scroll\Max = (\Scroll\Min + 1)
          Else
            \Scroll\Max = Value
          EndIf
          Update = #True
        EndIf
        
      Case #PB_ScrollBar_PageLength
        If \Scroll\PageLength <> Value
          If Value > (\Scroll\Max-\Scroll\Min)
            \Scroll\PageLength = (\Scroll\Max-\Scroll\Min)
          Else
            \Scroll\PageLength = Value
          EndIf
          \Scroll\Pos = Abs(\Scroll\Pos)
          Update = #True
        EndIf
        
    EndSelect
    
    If Update
;       If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
;         \Scroll\Pos = ((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
;       EndIf
;       ;SetScrollState(This(), Value)
      UpdateScrollCoordinate(This())
    EndIf
    
  EndWith
  
EndProcedure

Procedure ScrollBarElementCallBack(Event.q, EventElement, EventElementItem)
  Static LastX, LastY
  
  With *CreateElement 
    
    Select Event
      Case #_Event_LeftButtonDown, #_Event_LeftButtonUp  
        LastX = \MouseX - \This()\Scroll\ThumbPos
        LastY = \MouseY - \This()\Scroll\ThumbPos
        
        Select EventElementItem
          Case 0 : SetElementState(EventElement, \This()\Scroll\Pos-\This()\Scroll\ScrollStep)
          Case 1 : SetElementState(EventElement, \This()\Scroll\Pos+\This()\Scroll\ScrollStep)
        EndSelect
        
      Case #_Event_MouseMove
        If \Buttons
          If \This()\IsVertical
            SetElementState(EventElement, Steps(UpdateScrollPos(\This(), (\MouseY-LastY)),\This()\Scroll\ScrollStep))
          Else
            SetElementState(EventElement, Steps(UpdateScrollPos(\This(), (\MouseX-LastX)),\This()\Scroll\ScrollStep))
          EndIf
        EndIf
        
    EndSelect  
    
  EndWith
EndProcedure


Procedure ScrollBarElement( Element, X,Y,Width,Height, Min, Max, PageLength, Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ScrollBar, Element, X,Y,Width,Height,"", -1, -1, -1, Flag)
;    Min=0
; Max=0
;    PageLength=0
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    SetScrollBarElementAttribute(\This(), #PB_ScrollBar_Minimum, Min)
    SetScrollBarElementAttribute(\This(), #PB_ScrollBar_Maximum, Max)
    SetScrollBarElementAttribute(\This(), #PB_ScrollBar_PageLength, PageLength)
    
    If Radius : \This()\Radius = Radius : EndIf
    PopListPosition(\This())         
  EndWith
  
  AddElementItem(Element, 0, "", -1, #_Flag_Image_Center|#_Flag_Border)
  AddElementItem(Element, 1, "", -1, #_Flag_Image_Center|#_Flag_Border)
  AddElementItem(Element, 2, "", -1, #_Flag_Image_Center|#_Flag_Border)
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; ScrollBar element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Procedure ScrollBarGadgetEvent()
;     Select EventType()
;       Case #PB_EventType_Down
;         Debug Str(EventGadget())+" - Down"
;       Case #PB_EventType_Up
;         Debug Str(EventGadget())+" - Up"
;       Case #PB_EventType_Change
    Debug Str(GetGadgetState(EventGadget()))+" - scroll gadget change"
    If EventGadget() = 10
      SetElementState(10, GetGadgetState(EventGadget()))
    Else
      SetElementState(15, GetGadgetState(EventGadget()))
    EndIf
    ;     EndSelect
  EndProcedure
  
  Define i = OpenWindow(1, 10,10,300,190, "SystemMenu", #PB_Window_SystemMenu)
  SetWindowColor(1, $8C9C65)
  
  Define g = ListViewGadget(#PB_Any,10,10,200,130,#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  For i=0 To 50
    AddGadgetItem(g, -1,Str(i)+"_item_long_very_long")
  Next
  
  ScrollBarGadget(10, 210+8,10+1,17,130-2,0,100,30,#PB_ScrollBar_Vertical)
  Define g=10
  SetGadgetState(g,50)
  
  BindGadgetEvent(g, @ScrollBarGadgetEvent());, #PB_EventType_LeftClick)
  ScrollBarGadget(15, 10+1,140+8,200-2,17,0,1,50)
  Define g=15
  SetGadgetState(g,100)
  
  BindGadgetEvent(g, @ScrollBarGadgetEvent());, #PB_EventType_LeftClick)
  
  
  Procedure ScrollBarElementEvent(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement()))+" - scroll element change"
    EndSelect
    
    If EventElement() = 10
      SetGadgetState(10, GetElementState(EventElement()))
      
;       *CreateElement\This()\Scroll\Element = 20
;       With *CreateElement
;         PushListPosition(\This())
;         ChangeCurrentElement(\This(), ElementID(EventElement()))
;         Protected Min = \This()\Scroll\Min
;         Protected Max = \This()\Scroll\Max-(\This()\bSize-\This()\BorderSize)
;         Protected PageLength = (\This()\bSize-\This()\BorderSize)*2
;         
;         ;If IsElement(\Scroll\Element)
;         ChangeCurrentElement(\This(), ElementID(20))
;         \This()\Scroll\Min = Min
;         \This()\Scroll\Max = Max
;         \This()\Scroll\PageLength = \This()\InnerCoordinate\Height+\This()\BorderSize*2+PageLength
;         ;EndIf
;         ; CurrentElement(20)
;         Debug ElementClass(\This()\Type)
;         SetScrollState(\This(), GetElementState(EventElement()))
;         ;SetScrollBarElementState(GetElementState(EventElement()))
;         PopListPosition(\This())
;       EndWith
;         
    Else
      SetGadgetState(15, GetElementState(EventElement()))
    EndIf
    
  EndProcedure
  
  Define i = OpenWindowElement(1, 20,10,300,190, "BorderLess", #_Flag_SizeGadget|#_Flag_MoveGadget|#_Flag_BorderLess) ; |#PB_Window_MoveGadget
  ;SetWindowElementColor(1, $8C9C65)
  
  ;Define e = ListViewElement(20,10-4,10-4,200+8,130+8,"");,#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  Define e = ListViewElement(20,10-4,10-4,200+8,130+8,"",#_Flag_SizeGadget);|#_Flag_BorderLess) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  For i=0 To 50
    AddListViewElementItem(e, -1,Str(i)+"_item_long_very_long")
  Next
  
  ;UseGadgetList(WindowID(*CreateElement\CanvasWindow)) : ScrollBarGadget(10, 210+8+50,10+1+13,17,130,0,100,30,#PB_ScrollBar_Vertical)
  Define e=ScrollBarElement(10, 220-4,10-4,17+8,130+8,0,100,30, #_Flag_SizeGadget|#_Flag_Vertical);,-1,5);#_Flag_MoveGadget|
  ChangeCurrentElement(*CreateElement\This(), ElementID(10))
  *CreateElement\This()\Scroll\Element = 20
  SetElementState(e, 50)
  
  BindGadgetElementEvent(e, @ScrollBarElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  Define e=ScrollBarElement(15, 10-4,150-4,200+8,17+8,0,1,50, #_Flag_SizeGadget);#_Flag_MoveGadget|
  SetElementState(e, 100) 
  
;     SetGadgetState(10,10)
;     SetElementState(10, 10) 
  i=52
  SetElementAttribute(10,#PB_ScrollBar_Minimum, 0)
  SetGadgetAttribute(10,#PB_ScrollBar_Minimum, 0)
  
  SetElementAttribute(10,#PB_ScrollBar_Maximum, i*13)
  SetGadgetAttribute(10,#PB_ScrollBar_Maximum, i*13)
  
  SetElementAttribute(10,#PB_ScrollBar_PageLength, 130) ;: SetElementState(10, 0) 
  SetGadgetAttribute(10,#PB_ScrollBar_PageLength, 130)
  
      
;  
  ;SetGadgetState(10, 0) 
  
  BindGadgetElementEvent(e, @ScrollBarElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  WaitWindowEventClose(Window)
CompilerEndIf

