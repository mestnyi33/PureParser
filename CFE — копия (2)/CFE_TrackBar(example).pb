CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  
  ; - The following functions can be used To act on this Element: 
  
  ; - GetElementColor()
  ; - SetElementColor()
  ; - ElementToolTip()          ; A 'mini help' can be added To this Element using . 
  
  ; - GetElementState()         ; Returns the current slider Position (value between 'Minimum' And 'Maximum - PageLength + 1' range). 
  ; - SetElementState()         ; Changes the current slider Position. 
  
  ; - GetElementAttribute()     ; With one of the following attributes ; 
  ;   #PB_TrackBar_Minimum     ; Returns the minimum Track Position.
  ;   #PB_TrackBar_Maximum     ; Returns the maximum Track Position.
  ;   #PB_TrackBar_PageLength  ; Returns the PageLength value.
  
  ; - SetElementAttribute()     ; With one of the following attributes ; 
  ;   #PB_TrackBar_Minimum     ; Changes the minimum Track Position.
  ;   #PB_TrackBar_Maximum     ; Changes the maximum Track Position.
  ;   #PB_TrackBar_PageLength  ; Changes the PageLength value.
  
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ TrackBar element functions
Procedure DrawTrackBarElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height
  
  With *CreateElement\This()
    
    If ListSize(\Items())
      X = \InnerCoordinate\X
      Y = (\FrameCoordinate\Y+\bSize)
      
      PushListPosition(\Items())
      ForEach \Items()
        If \IsVertical
          ; скролл бар
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\X = 5
            \Items()\FrameCoordinate\Y = 5
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - 10
            \Items()\FrameCoordinate\Width = 4
            
            ; Ползунок на скролл баре
          ElseIf ListIndex(\Items()) = 1
            \Items()\FrameCoordinate\X = 1
            \Items()\FrameCoordinate\Y = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Height = \Scroll\ThumbSize
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - 5
          EndIf
        Else
          
          ; скролл бар
          If ListIndex(\Items()) = 0 
            \Items()\FrameCoordinate\Y = 5
            \Items()\FrameCoordinate\X = 5
            \Items()\FrameCoordinate\Height = 4
            \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - 10
            
            ; Ползунок на скролл баре
          ElseIf ListIndex(\Items()) = 1
            \Items()\FrameCoordinate\Y = 1
            \Items()\FrameCoordinate\X = \Scroll\ThumbPos
            \Items()\FrameCoordinate\Width = \Scroll\ThumbSize
            \Items()\FrameCoordinate\Height = \InnerCoordinate\Height - 5
          EndIf
        EndIf
        
        DrawContent(\Items(), X,Y)
      Next
      PopListPosition(\Items())
    EndIf
    
  EndWith
EndProcedure

Procedure.q SetTrackBarElementFlag(Flag.q)
  Protected Result.q = Flag
  ProcedureReturn Result
EndProcedure

Procedure.q GetTrackBarElementFlag(Flag.q)
  Protected Result.q = Flag
  ProcedureReturn Result
EndProcedure

;- PRIVATE
Procedure SetTrackStep(List This.S_CREATE_ELEMENT(), TrackStep)
  This()\Scroll\ScrollStep = TrackStep 
EndProcedure

Procedure UpdateTrackPos(List This.S_CREATE_ELEMENT(), ThumbPos)
  Protected Result
  
  With This()
    Result = Round((ThumbPos - \Scroll\ButtonSize - \bSize) / (\Scroll\Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest)
    
    If (\IsVertical And \Type = #_Type_TrackBar)
      Result = ((\Scroll\Max-\Scroll\Min)-Result)
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure UpdateTrackThumbSize(List This.S_CREATE_ELEMENT(), Area)
  Protected Result 
  
  Result = Round(Area - (Area / (This()\Scroll\Max-This()\Scroll\Min))*((This()\Scroll\Max-This()\Scroll\Min) - This()\Scroll\PageLength), #PB_Round_Nearest)
  If (Result < 8);This()\Scroll\ButtonSize) 
    Result = 8;This()\Scroll\ButtonSize 
  EndIf
  
 ProcedureReturn Result
EndProcedure

Procedure UpdateTrackThumbPos(List This.S_CREATE_ELEMENT(), TrackPos, Area)
  Protected Result 
  
  With This()
    Result = (\Scroll\ButtonSize + Round(TrackPos * (Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest))
    
    If \IsVertical
      If (Result+\Scroll\ThumbSize) > (\InnerCoordinate\Height-\Scroll\ButtonSize)
        Result = \InnerCoordinate\Height - \Scroll\ButtonSize - \Scroll\ThumbSize
      EndIf
    Else
      If (Result+\Scroll\ThumbSize) > (\InnerCoordinate\Width-\Scroll\ButtonSize)
        Result = \InnerCoordinate\Width - \Scroll\ButtonSize - \Scroll\ThumbSize
      EndIf
    EndIf
  EndWith

  ProcedureReturn Result
EndProcedure

Procedure UpdateTrackCoordinate(List This.S_CREATE_ELEMENT())
  Protected Result 
  
  With This()
    If \IsVertical
      \Scroll\Area = \InnerCoordinate\Height - \Scroll\ButtonSize*2 
    Else
      \Scroll\Area = \InnerCoordinate\Width - \Scroll\ButtonSize*2 
    EndIf
    
    \Scroll\ThumbSize = UpdateTrackThumbSize(This(), \Scroll\Area)
    \Scroll\ThumbPos = UpdateTrackThumbPos(This(), \Scroll\Pos, \Scroll\Area)
  EndWith
  
EndProcedure

Procedure SetTrackState(List This.S_CREATE_ELEMENT(), State)
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
      
      If \Scroll\Pos <> State : \Scroll\Pos = State
        UpdateTrackCoordinate(This())
      Else
        Result = 0
      EndIf                
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;-


;- PUBLIC
Procedure SetTrackBarElementState(State)
  Protected PostEvent.q
  
  With *CreateElement
      State = SetTrackState(\This(), State)
      
      Select State 
        Case   1 : PostEvent = #_Event_Up
        Case - 1 : PostEvent = #_Event_Down 
      EndSelect
      
      If PostEvent
        PostEventElement(PostEvent, \This()\Element, \This()\Items()\Element)
        
        ElementDrawCallBack(\This()\Event, \This()\Element)
      EndIf 
  EndWith
EndProcedure

Procedure GetTrackBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
  Protected Result
  
  With This()
    Select Attribute
      Case #PB_TrackBar_Minimum    : Result = \Scroll\Min
      Case #PB_TrackBar_Maximum    : Result = \Scroll\Max
    EndSelect
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetTrackBarElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)
  Protected Update 
  
  With This()
    
    Select Attribute
      Case #PB_TrackBar_Minimum
        If \Scroll\Min <> Value
          \Scroll\Min = Value
          Update = #True
        EndIf
        
      Case #PB_TrackBar_Maximum
        If \Scroll\Max <> Value
          If \Scroll\Min > Value
            \Scroll\Max = (\Scroll\Min + 1)
          Else
            \Scroll\Max = Value
          EndIf
          Update = #True
        EndIf
       
    EndSelect
    
    If Update
;       If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
;         \Scroll\Pos = ((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
;       EndIf
;       ;SetTrackState(This(), Value)
      UpdateTrackCoordinate(This())
    EndIf
    
  EndWith
  
EndProcedure

Procedure TrackBarElementCallBack(Event.q, EventElement, EventElementItem)
  Protected State
  Static LastX, LastY
  
  With *CreateElement 
    
    Select Event
      Case #_Event_LeftButtonDown, #_Event_LeftButtonUp  
        LastX = \MouseX - \This()\Scroll\ThumbPos
        LastY = \MouseY - \This()\Scroll\ThumbPos
        
        Select EventElementItem
          Case 0 
            If \This()\IsVertical
              State = (\MouseY-\This()\FrameCoordinate\Y)
            Else
              State = (\MouseX-\This()\FrameCoordinate\X)
            EndIf
            
            If \This()\Scroll\ScrollStep 
              If (\This()\Scroll\ThumbPos > State)
                SetElementState(EventElement, \This()\Scroll\Pos-\This()\Scroll\ScrollStep)
              Else 
                SetElementState(EventElement, \This()\Scroll\Pos+\This()\Scroll\ScrollStep)
              EndIf
            EndIf
           
        EndSelect
        
      Case #_Event_MouseMove
        If \Buttons
          If \This()\IsVertical
            SetElementState(EventElement, Steps(UpdateTrackPos(\This(), ((\MouseY-LastY))),\This()\Scroll\ScrollStep))
          Else
            SetElementState(EventElement, Steps(UpdateTrackPos(\This(), (\MouseX-LastX)),\This()\Scroll\ScrollStep))
          EndIf
        EndIf
        
    EndSelect  
    
  EndWith
EndProcedure


Procedure TrackBarElement( Element, X,Y,Width,Height, Min, Max, Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  Protected ScrollStep = 1
  
  Element = CreateElement( #_Type_TrackBar, Element, X,Y,Width,Height,"", Min, Max, ScrollStep, Flag);|#_Flag_Transparent)
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    
    SetTrackBarElementAttribute(\This(), #PB_ScrollBar_Minimum, Min)
    SetTrackBarElementAttribute(\This(), #PB_ScrollBar_Maximum, Max)
    
    If Flag = #PB_TrackBar_Ticks
      \This()\Scroll\ScrollStep = 1
    EndIf
    
    If Radius
      \This()\Radius = Radius
    EndIf
    PopListPosition(\This())         
  EndWith
  
   AddElementItem(Element, 0, "", -1, #_Flag_Image_Center|#_Flag_Border)
   AddElementItem(Element, 1, "", -1, #_Flag_Image_Center|#_Flag_Border)
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; TrackBar element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Procedure TrackBarGadgetEvent()
;     Select EventType()
;       Case #PB_EventType_Down
;         Debug Str(EventGadget())+" - Down"
;       Case #PB_EventType_Up
;         Debug Str(EventGadget())+" - Up"
;       Case #PB_EventType_Change
    Debug Str(GetGadgetState(EventGadget()))+" - Track gadget change"
    If EventGadget() = 10
      SetElementState(10, GetGadgetState(EventGadget()))
    Else
      SetElementState(15, GetGadgetState(EventGadget()))
    EndIf
    ;     EndSelect
  EndProcedure
  
  Define i = OpenWindow(1, 10,10, 320, 200, "TrackBarGadget", #PB_Window_SystemMenu)
    SetWindowColor(1, $8C9C65)
    TrackBarGadget(2, 10,  40, 250, 20, 0, 10000)
    SetGadgetState(2, 5000)
    
    TrackBarGadget(3, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
    SetGadgetState(3, 3000)
    
    TrackBarGadget(10, 270, 10, 20, 170, 0, 10000, #PB_TrackBar_Vertical)
    SetGadgetState(10, 8000)
    
    Define g = 10
  BindGadgetEvent(g, @TrackBarGadgetEvent());, #PB_EventType_LeftClick)
  
  
  Procedure TrackBarElementEvent(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement()))+" - Track element change"
    EndSelect
    
    If EventElement() = 10
      SetGadgetState(10, GetElementState(EventElement()))
      
      ;CurrentElement(20)
      ;SetTrackBarElementState(GetElementState(EventElement()))
    Else
      SetGadgetState(15, GetElementState(EventElement()))
    EndIf
    
  EndProcedure
  
  Define i = OpenWindowElement(1, 20,10,320,200, "BorderLess", #_Flag_SizeGadget|#_Flag_MoveGadget|#_Flag_BorderLess) ; |#PB_Window_MoveGadget
  SetWindowElementColor(1, $8C9C65)
  
  TrackBarElement(2, 10,  40, 250, 20, 0, 10000)
    SetElementState(2, 5000)
    
    TrackBarElement(3, 10, 120, 250, 20, 0, 30, #PB_TrackBar_Ticks)
    SetElementState(3, 3000)
    
    Define e = TrackBarElement(10, 270, 10, 20, 170, 0, 10000, #_Flag_Vertical)
    SetElementState(10, 8000)
    
  BindGadgetElementEvent(e, @TrackBarElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  WaitWindowEventClose(Window)
CompilerEndIf

