Enumeration #PB_EventType_FirstCustomValue
  #PB_Splitter_Separator_Circle
EndEnumeration

CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Splitter element functions
Procedure DrawSplitterElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected IsVertical,Pos, Size, X,Y,Width,Height, fColor = $686868, Color = $686868
  
  With *CreateElement
    If ListSize(\This()\Items())
      IsVertical = Bool((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
      X = \This()\FrameCoordinate\X
      Y = \This()\FrameCoordinate\Y
      Width = \This()\FrameCoordinate\Width 
      Height = \This()\FrameCoordinate\Height
      
      ; Позиция сплиттера 
      Size = \This()\Splitter\Size - 1
      Pos = \This()\Splitter\Pos+\This()\bSize
      
      ;       If IsVertical
      ;         If (Pos<Width/2) : Pos+1 : EndIf
      ;       Else
      ;         If (Pos<Height/2) : Pos+1 : EndIf
      ;       EndIf
      
      Protected Radius.d = 2.0 ; Size/2
      DrawingMode(#PB_2DDrawing_Outlined) 
      ;Box(X,Y,Width,Height,Color)
      
      If ((\This()\Items()\Flag & #_Flag_Border) = #_Flag_Border)
        If IsVertical
          Box(X,Y,Pos-1,Height,fColor) : Box(X+(Pos+Size+1), Y,(Width-(Pos+Size))-1,Height,fColor)
        Else
          Box(X,Y,Width,Pos-1,fColor) : Box( X,Y+(Pos+Size+1),Width,(Height-(Pos+Size))-1,fColor)
        EndIf
      EndIf
      
      If ((\This()\Flag & #_Flag_Separator_Circle) = #_Flag_Separator_Circle)
        
        DrawingMode(#PB_2DDrawing_Outlined) 
        If IsVertical
          Circle(X+Pos+Size/2,Y+((Height-Radius)/2-((Radius*2+2)*2+2)),Radius,Color)
          Circle(X+Pos+Size/2,Y+((Height-Radius)/2-(Radius*2+2)),Radius,Color)
          Circle(X+Pos+Size/2,Y+((Height-Radius)/2),Radius,Color)
          Circle(X+Pos+Size/2,Y+((Height-Radius)/2+(Radius*2+2)),Radius,Color)
          Circle(X+Pos+Size/2,Y+((Height-Radius)/2+((Radius*2+2)*2+2)),Radius,Color)
        Else
          Circle(X+((Width-Radius)/2-((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
          Circle(X+((Width-Radius)/2-(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
          Circle(X+((Width-Radius)/2),Y+Pos+Size/2,Radius,Color)
          Circle(X+((Width-Radius)/2+(Radius*2+2)),Y+Pos+Size/2,Radius,Color)
          Circle(X+((Width-Radius)/2+((Radius*2+2)*2+2)),Y+Pos+Size/2,Radius,Color)
        EndIf
        
      ElseIf ((\This()\Flag & #_Flag_Separator) = #_Flag_Separator)
        DrawingMode(#PB_2DDrawing_Outlined) 
        If IsVertical
          ;Box(X+Pos,Y,Size,Height,Color)
          Line((X+Pos)+Size/2,Y,1,Height,Color)
        Else
          ;Box(X,(Y+Pos),Width,Size,Color)
          Line(X,(Y+Pos)+Size/2,Width,1,Color)
        EndIf
      EndIf
      
    EndIf
    
  EndWith
EndProcedure

Procedure.q SetSplitterElementFlag(Flag.q)
  Protected Result.q
  ; 1 - #PB_Splitter_Vertical    ; The Gadget is split vertically (instead of horizontally which is the Default).
  ; 2 - #PB_Splitter_Separator   ; A 3D-looking separator is drawn in the splitter.
  ; 4 - #PB_Splitter_FirstFixed  ; When the splitter Gadget is resized, the first Gadget will keep its Size
  ; 8 - #PB_Splitter_SecondFixed ; When the splitter Gadget is resized, the second Gadget will keep its Size
  
  If ((Flag & #PB_Splitter_Vertical) = #PB_Splitter_Vertical) 
    Result | #_Flag_Vertical
  EndIf
  If ((Flag & #PB_Splitter_Separator) = #PB_Splitter_Separator) 
    Result | #_Flag_Separator
  EndIf
  If ((Flag & #PB_Splitter_Separator_Circle) = #PB_Splitter_Separator_Circle) 
    Result | #_Flag_Separator_Circle
  EndIf
  
  If ((Flag & #PB_Splitter_FirstFixed) = #PB_Splitter_FirstFixed) 
    Result | #_Flag_FirstFixed
  ElseIf ((Flag & #PB_Splitter_SecondFixed) = #PB_Splitter_SecondFixed) 
    Result | #_Flag_SecondFixed
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetSplitterElementFlag(Flag.q)
  Protected Result.q
  
  If ((Flag & #_Flag_Vertical) = #_Flag_Vertical)
    Result | #PB_Splitter_Vertical
  EndIf
  If ((Flag & #_Flag_Separator) = #_Flag_Separator)
    Result | #PB_Splitter_Separator
  EndIf
  If ((Flag & #_Flag_Separator_Circle) = #_Flag_Separator_Circle)
    Result = #PB_Splitter_Separator_Circle
  EndIf
  
  If ((Flag & #_Flag_FirstFixed) = #_Flag_FirstFixed)
    Result | #PB_Splitter_FirstFixed
  ElseIf ((Flag & #_Flag_SecondFixed) = #_Flag_SecondFixed)
    Result | #PB_Splitter_SecondFixed
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure SetSplitterElementState(List This.S_CREATE_ELEMENT(), State)
  Protected Parent =- 1, IsVertical, Max
  Protected PostEvent.q
  Protected Result, iX,iY,iWidth,iHeight, Value
  
  With This()
    
    Select \Type
      Case #_Type_Splitter
;         SetElementState(\Parent\Element,\Item\State)
;         SetElementState(\Parent\Element,0)
;         Protected i, iState
;         
;         PushListPosition(\This()) 
;         If IsElement(\Parent\Element)
;           ChangeCurrentElement(\This(), ElementID(\Parent\Element))
;           
;         EndIf
;         PopListPosition(\This())
;         
;         If IsElement(Element1) 
;           iState = GetElementState(Element1)
;           For i=0 To (CountElementItems(Element1)-1)
;             SetElementState(Element1,i)
;           Next
;           SetElementState(Element1,iState)
;         EndIf
;         
        iWidth = \InnerCoordinate\Width
        iHeight = \InnerCoordinate\Height
        IsVertical = Bool((\Flag & #_Flag_Vertical) = #_Flag_Vertical)
        If IsVertical : Max = iWidth : Else : Max = iHeight : EndIf
        
        ; Минимальная позиция сплиттера
        If State < \Splitter\FirstMinimumSize
          State = \Splitter\FirstMinimumSize
        EndIf
        
        ; Мксимальная позиция сплиттера
        If Max
          If State > Max-\Splitter\Size-\Splitter\SecondMinimumSize 
            If \Splitter\Pos > \Splitter\FirstMinimumSize
              State = Max-\Splitter\Size-\Splitter\SecondMinimumSize 
            Else ; Если высота элемента меньше суммы первого и второго мин размера
              State = \Splitter\Pos
            EndIf
          EndIf
        EndIf
        
        Result = \Splitter\Pos
        Value = (State+\Splitter\Size)
        \Splitter\Pos = State
        
        If IsVertical
          ResizeElement(\Splitter\FirstElement, 0, 0, State, iHeight)
          ResizeElement(\Splitter\SecondElement, Value, 0, (iWidth-Value), iHeight)
        Else
          ResizeElement(\Splitter\FirstElement, 0, 0, iWidth, State)
          ResizeElement(\Splitter\SecondElement, 0, Value, iWidth, (iHeight-Value))
        EndIf
        
;         If \Splitter\FirstFixed 
;           \Splitter\StatePercent = State
;         ElseIf \Splitter\SecondFixed 
;           ;If State > \Splitter\FirstMinimumSize
;           \Splitter\StatePercent = (Max-State)
;         Else
;           \Splitter\StatePercent = (Max/2-State)
;         EndIf
        
         
    EndSelect
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure GetSplitterElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
  Protected Result
  
  With This()
    
    Select Attribute
      Case #PB_Splitter_FirstGadget : Result = \Splitter\FirstElement
      Case #PB_Splitter_SecondGadget : Result = \Splitter\SecondElement
      Case #PB_Splitter_FirstMinimumSize : Result = \Splitter\FirstMinimumSize
      Case #PB_Splitter_SecondMinimumSize : Result = \Splitter\SecondMinimumSize
    EndSelect
    
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetSplitterElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)
  Protected Result, X,Y,Width,Height, SplitterPos, SplitterWidth, SplitterHeight
  Static Splitter =- 1
  
  With This()
    Protected Flag = \Flag
    Height = \FrameCoordinate\Height
    
    ; 
    If IsGadgetElement(Value)
      PushListPosition(This())
      ChangeCurrentElement(This(), ElementID(Value))
      
      Select \Type
        Case #_Type_Splitter
          If Splitter =-1 : Splitter = \Element
            SplitterPos = \Splitter\Pos
            SplitterWidth = \FrameCoordinate\Width
            SplitterHeight = \FrameCoordinate\Height
          EndIf
      EndSelect
      PopListPosition(This())
    EndIf
    
    Select \Type
      Case #_Type_Splitter
        Select Attribute
          Case #PB_Splitter_FirstGadget : \Splitter\FirstElement = Value
          Case #PB_Splitter_SecondGadget : \Splitter\SecondElement = Value
          Case #PB_Splitter_FirstMinimumSize : \Splitter\FirstMinimumSize = Value
          Case #PB_Splitter_SecondMinimumSize : \Splitter\SecondMinimumSize = Value
        EndSelect
        
        SetElementParent(Value, \Element, #PB_Default)
        
        If ((\Flag & #_Flag_Vertical) = #_Flag_Vertical)
          SetSplitterElementState(This(), (\InnerCoordinate\Width /2))
        Else
          SetSplitterElementState(This(), (\InnerCoordinate\Height /2))
        EndIf
        
        If IsGadgetElement(Value)
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(Value))
          
          Select \Type
            Case #_Type_Splitter
              If ((\Flag & #_Flag_Vertical) = #_Flag_Vertical)
                If (SplitterPos = SplitterWidth/2)
                  SetElementState(This(), (Width/2))
                Else
                  If (SplitterPos < SplitterWidth/2)
                    SetSplitterElementState(This(), SplitterPos)
                  Else
                    SetElementState(This(), (Width-(SplitterWidth-SplitterPos+\Splitter\Size)) )
                  EndIf
                EndIf
              Else
                If (SplitterPos = SplitterHeight/2)
                  SetElementState(This(), (Height/2))
                Else
                  If (SplitterPos < SplitterHeight/2)
                    SetSplitterElementState(This(), SplitterPos)
                  Else
                    SetElementState(This(), (Height-(SplitterHeight-SplitterPos+\Splitter\Size)) )
                  EndIf
                EndIf
              EndIf
              
          EndSelect
          
          PopListPosition(This())
        EndIf
        
    EndSelect
  EndWith
  
EndProcedure

Procedure SplitterElementCallBack1(Event.q)
  ; Это для сплиттера
  ; Если находимся на сеператоре
  Static SplitterCheck
  Protected *ParentID, MousePos, Cursor
  
  With *CreateElement
    PushListPosition(\This())
    If \This()\Hide = 0 
      If Not Bool(\This()\Type = #_Type_Properties Or \This()\Type = #_Type_Splitter) 
        *ParentID = ElementID(\This()\Parent\Element) 
        If *ParentID
          ChangeCurrentElement(\This(), *ParentID)
        EndIf
      EndIf
      
      If Bool(\This()\Type = #_Type_Properties Or \This()\Type = #_Type_Splitter) 
        If ((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
          Cursor = #PB_Cursor_LeftRight
          MousePos = \MouseX-\This()\InnerCoordinate\X
        Else
          Cursor = #PB_Cursor_UpDown
          MousePos = \MouseY-\This()\InnerCoordinate\Y
        EndIf
      EndIf
      
      If MousePos >= (\This()\Splitter\Pos-1) And 
         MousePos < ((\This()\Splitter\Pos+\This()\Splitter\Size)+1)
        
        If Cursor = GetElementCursor()
         SplitterCheck = \Buttons
        ElseIf \Buttons = 0 And Cursor
         SetCursorElement(Cursor)
        EndIf
      ElseIf \Buttons = 0 
        If SplitterCheck
          SplitterCheck = 0 
          SetCursorElement(#PB_Cursor_Default)
        EndIf
      EndIf
      
      ; Event Splitter
      If SplitterCheck
        SetElementState(\This()\Element, MousePos)
        
        ProcedureReturn 1
      EndIf
    Else
      SplitterCheck = 0
    EndIf
    PopListPosition(\This())
  EndWith
  
EndProcedure
Procedure SplitterElementCallBack(Event.q)
  Static Buttons 
  
  With *CreateElement
    Select Event 
      Case #_Event_MouseEnter
        If \This()\Type = #_Type_Splitter
          If ((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
            SetCursorElement(#PB_Cursor_LeftRight)
          Else
            SetCursorElement(#PB_Cursor_UpDown)
          EndIf
        EndIf
        
      Case #_Event_MouseLeave, #_Event_LeftButtonUp
        If \This()\Type = #_Type_Splitter
          SetCursorElement(#PB_Cursor_Default)
          Buttons = 0
        EndIf
        
      Case #_Event_LeftButtonDown
        If \This()\Type = #_Type_Splitter
          Buttons = 1
        EndIf
        
      Case #_Event_MouseMove
        If \This()\Type = #_Type_Splitter
          If Buttons
            If ((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
              SetSplitterElementState(\This(), (\MouseX-\This()\InnerCoordinate\X)-\This()\Splitter\Size/2)
            Else
              SetSplitterElementState(\This(), (\MouseY-\This()\InnerCoordinate\Y)-\This()\Splitter\Size/2)
            EndIf
          EndIf
        EndIf
    EndSelect
    
  EndWith
  
  ProcedureReturn Buttons
EndProcedure
Procedure SplitterElementCallBack22(Event.q)
  ; Это для сплиттера
  ; Если находимся на сеператоре
  Protected MousePos, Cursor
  Static SetCursor.b, DefaultCursor, SplitterCheck, SplitterPosition
  
  With *CreateElement
    ;Debug GetElementPosition(\This()\Parent\Element)
    
    If \This()\Hide = 0 And (\This()\Type = #_Type_Properties Or \This()\Type = #_Type_Splitter Or ElementType(\This()\Parent\Element) = #_Type_Splitter)
      If ((\This()\Flag & #_Flag_Vertical) = #_Flag_Vertical)
        Cursor = #PB_Cursor_LeftRight
        MousePos = \This()\MouseX
      Else
        Cursor = #PB_Cursor_UpDown
        MousePos = \This()\MouseY
      EndIf
      
      If MousePos >= (\This()\Splitter\Pos-1) And MousePos =< ((\This()\Splitter\Pos+\This()\Splitter\Size)+1)
        SplitterCheck = \Buttons
        If SetCursor = 0 : SetCursor = 1 : SetCursorElement(Cursor) : EndIf
      Else
        If \Buttons = 0 
          SplitterCheck = 0 
          If SetCursor = 1 : SetCursor = 0 : SetCursorElement(#PB_Cursor_Default) : EndIf
        EndIf
      EndIf
      
      
      ; Event Splitter
      If SplitterCheck
        If \This()\Flag & #_Flag_Vertical = #_Flag_Vertical
          SetElementState(\This()\Element, ((\MouseX-\This()\FrameCoordinate\X)-\This()\Splitter\Size /2))
        Else
          SetElementState(\This()\Element, ((\MouseY-\This()\FrameCoordinate\Y)-\This()\Splitter\Size /2))
        EndIf
        
        ProcedureReturn 1
      EndIf
    Else
      SplitterCheck = 0
    EndIf
  EndWith
  
EndProcedure


Procedure SplitterElement( Element, X,Y,Width,Height, Element1, Element2, Flag.q = 0, Parent =- 1, Radius = 0 )
  ; 1 - #_Flag_Vertical    ; The Gadget is split vertically (instead of horizontally which is the Default).
  ; 2 - #_Flag_Separator   ; A 3D-looking separator is drawn in the splitter.
  ; 4 - #_Flag_FirstFixed  ; When the splitter Gadget is resized, the first Gadget will keep its Size
  ; 8 - #_Flag_SecondFixed ; When the splitter Gadget is resized, the second Gadget will keep its Size
  
  ; GetElementState() ; Get the current splitter Position, in pixels. 
  ; SetElementState() ; Change the current splitter Position, in pixels. 
  ; GetElementAttribute() ; With one of the following attribute ; 
  ; #_Attribute_FirstMinimumSize  ; Gets the minimum Size (in pixels) than the first Gadget can have.
  ; #_Attribute_SecondMinimumSize ; Gets the minimum Size (in pixels) than the second Gadget can have.
  ; #_Attribute_FirstGadget       ; Gets the Gadget number of the first Gadget.
  ; #_Attribute_SecondGadget      ; Gets the Gadget number of the second Gadget.
  
  ; SetElementAttribute() ; With one of the following attribute ; 
  ; #_Attribute_FirstMinimumSize  ; Sets the minimum Size (in pixels) than the first Gadget can have.
  ; #_Attribute_SecondMinimumSize ; Sets the minimum Size (in pixels) than the second Gadget can have.
  ; #_Attribute_FirstGadget       ; Replaces the first Gadget With a new one.
  ; #_Attribute_SecondGadget      ; Replaces the second Gadget With a new one.
  
  
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  ;Flag = SetSplitterElementFlag(Flag)
  Element = CreateElement(#_Type_Splitter, Element, X,Y,Width,Height,"",Element1,Element2, #PB_Default, Flag|#_Flag_BorderLess)
  
  Protected i, State
  
  If IsElement(Element1) 
    State = GetElementState(Element1)
    For i=0 To (CountElementItems(Element1)-1)
      SetElementState(Element1,i)
    Next
    SetElementState(Element1,State)
  EndIf
  
  If IsElement(Element2)
    State = GetElementState(Element2)
    For i=0 To (CountElementItems(Element2)-1)
      SetElementState(Element2,i)
    Next
    SetElementState(Element2,State)
  EndIf

  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure
;}

;-
; Splitter element example
CompilerIf #PB_Compiler_IsMainFile
  Procedure SplitterElementEvent(Event.q, EventElement)
    Debug EventClass(ElementEvent())
  EndProcedure
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65, "Demo SplitterElement()") 
  Define  t = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  ;   ;{ example_0
  ;   
  ;   Define g1 = ButtonGadget(#PB_Any, 10,10,163,55, "ButtonElement")
  ;   Define g2 = ButtonGadget(#PB_Any, 10,70,163,25, "ButtonElement")
  ;   Define g = SplitterGadget(#PB_Any, 10+1,10+t+1,163,55, g1,g2)
  ;   SetGadgetState(g,55-20)
  ;   Debug "g "+GadgetHeight(g2)
  ;   
  ;   
  ;   Define e1 = ButtonElement(#PB_Any, 10,10,163,55, "ButtonElement", 0,-1,15)
  ;   Define e2 = ButtonElement(#PB_Any, 10,70,163,25, "ButtonElement", 0,-1,15)
  ;   Define e = SplitterElement(#PB_Any, 210,10,163,55, #PB_Any,#PB_Any)
  ;   
  ;   SetElementAttribute(e, #_Element_FirstGadget, e1)
  ;   SetElementAttribute(e, #_Element_SecondGadget, e2)
  ;   SetElementState(e,55-20)
  ;   Debug "e1 "+ElementHeight(e1)
  ;   Debug "e2 "+ElementHeight(e2)
  ;   ;}
  
  ;   ;{ example_1
  ;   Define g1 = ButtonGadget(#PB_Any, 10,10,163,55, "ButtonElement")
  ;   Define g2 = ButtonGadget(#PB_Any, 10,70,163,25, "ButtonElement")
  ;   Define g = SplitterGadget(#PB_Any, 10+1,10+t+1,163,55, g1,g2)
  ;   SetGadgetState(g,20)
  ;   Debug "g "+GadgetHeight(g1)
  ;   
  ;   Define e1 = ButtonElement(#PB_Any, 10,10,163,55, "ButtonElement", 0,-1,15)
  ;   Define e2 = ButtonElement(#PB_Any, 10,70,163,25, "ButtonElement", 0,-1,15)
  ;   Define e = SplitterElement(#PB_Any, 210,10,163,55, e1,e2);, #_Flag_Vertical)
  ;   SetElementState(e,20)
  ;   Debug "e "+ElementHeight(e1)
  ;   ;}
  
  ;   ;} example_2
  ;   Define tt = 100
  ;   Define g1 = ButtonGadget(#PB_Any, 10,10,163,55, "ButtonElement")
  ;   Define g2 = ButtonGadget(#PB_Any, 10,70,163,25, "ButtonElement")
  ;   Define g3 = SplitterGadget(#PB_Any, 10+1,10+t+1+tt,183,55, g1,g2)
  ;   ;SetGadgetState(g3,40)
  ;   Define g4 = ButtonGadget(#PB_Any, 10,70,163,25, "ButtonElement")
  ;   Define g = SplitterGadget(#PB_Any, 10+1,10+t+1+tt,183,255, g3,g4, #PB_Splitter_Vertical|#PB_Splitter_Separator)
  ;   SetGadgetState(g3,255-40)
  ;   SetGadgetState(g,183-50)
  ;   
  ;   Define e1 = ButtonElement(2, 10,10,163,55, "ButtonElement")
  ;   Define e2 = ButtonElement(3, 10,70,163,25, "ButtonElement")
  ;   Define e3 = SplitterElement(4, 10+1,10+tt,183,55, e1,e2, #PB_Splitter_Separator)
  ;   ;SetElementState(e3,40)
  ;   Define e4 = ButtonElement(5, 10,70,163,25, "ButtonElement");,0,-1,15)
  ;   Define e = SplitterElement(6, 210+1,10+tt,183,255, e3,e4, #PB_Splitter_Vertical|#PB_Splitter_Separator)
  ;   SetElementState(e3,255-40)
  ;   SetElementState(e,183-50)
  ;   ;}
  
  ;{ example_3
  Define tt = 120
  Define g31 = ButtonGadget(#PB_Any, 10,10,163,55, "31ButtonElement")
  Define g32 = ButtonGadget(#PB_Any, 10,70,163,25, "32ButtonElement")
  Define g3 = SplitterGadget(#PB_Any, 10+1,10+t+1+tt,183,55, g31,g32)
  
  Define g41 = ButtonGadget(#PB_Any, 10,10,163,55, "41ButtonElement")
  Define g42 = ButtonGadget(#PB_Any, 10,70,163,25, "42ButtonElement")
  Define g4 = SplitterGadget(#PB_Any, 10+1,10+t+1+tt,183,55, g41,g42)
  ;   SetGadgetState(g4,27)
  
  Define g = SplitterGadget(#PB_Any, 10+1,10+t+1+tt,183,255, g3,g4, #PB_Splitter_Vertical|#PB_Splitter_Separator)
  SetGadgetState(g3,255-40)
  SetGadgetState(g4,255-40)
  SetGadgetState(g,183-50)
  
  
  
  ;   Define b1=ButtonGadget(#PB_Any,10,10,50,35, "?1_Butt")                                                                ;
  ;   Define b2=ButtonGadget(#PB_Any,10,30,50,35, "?2_Butt")                                                                ;
  
  Define e31 = ButtonElement(#PB_Any, 10,10,163,55, "31ButtonElement")
  Define e32 = ButtonElement(#PB_Any, 10,70,163,25, "32ButtonElement")
  Define e3 = SplitterElement(#PB_Any, 210+1,10+tt,183,55, e31,e32);, #_Flag_Separator_Circle)
  
  Define e41 = ButtonElement(#PB_Any, 10,10,163,55, "41ButtonElement")
  Define e42 = ButtonElement(#PB_Any, 10,70,163,25, "42ButtonElement")
  Define e4 = SplitterElement(#PB_Any, 210+1,10+tt,183,55, e41,e42);, #_Flag_Separator_Circle)
  
  ;   SetElementState(e3,55-20) ; 
  ;   SetElementState(e4,55-20) ; 
  
  Define e = SplitterElement(#PB_Any, 210+1,10+tt,183,255, e3,e4, #_Flag_Vertical|#_Flag_Separator)
  SetElementState(e3,255-40)
  SetElementState(e4,255-40)
  SetElementState(e,183-50)
  
;   Debug "e31 "+ElementHeight(e31)
;   Debug "e32 "+ElementHeight(e32)
;   ;   Debug "e4 "+ElementHeight(e4)
  ;   
; ;     Debug GetGadgetState(g3)
; ;     Debug GetElementState(e3)
  
  
  Define e = SplitterElement(#PB_Any, 10+1,270+tt,184,105, -1,-1, #_Flag_Border);|#_Flag_Separator)
  Define e = SplitterElement(#PB_Any, 210+1,270+tt,184,105, -1,-1, #_Flag_Border|#_Flag_Vertical|#_Flag_Separator|#_Flag_Anchors|#_Flag_SizeGadget|#_Flag_SecondFixed);First
  
  Define b1=ButtonElement(#PB_Any,10,10,50,35, "?1_Butt")                                                                ;
  Define b2=ButtonElement(#PB_Any,10,30,50,35, "?2_Butt")                                                                ;
  
  SetElementAttribute(e, #PB_Splitter_FirstGadget, b1)
  SetElementAttribute(e, #PB_Splitter_SecondGadget, b2)
  
  SetElementAttribute(e, #PB_Splitter_FirstMinimumSize, 10)
  SetElementAttribute(e, #PB_Splitter_SecondMinimumSize, 10)
  
  Debug "b1 "+ElementWidth(b1)
  Debug "b2 "+ElementWidth(b2)

  ;}
  ;   
  
  Define e = PanelElement(#PB_Any,210,10,190,100)                                                               ;
  AddPanelElementItem(e, -1, "Panel_1", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ButtonElement(#PB_Any,30,30,50,35, "1_Butt")                                                                ;
  
  AddPanelElementItem(e, -1, "Panel_2") 
  Define b1=ButtonElement(#PB_Any,10,10,50,35, "12_Butt")                                                                ;
  Define b2=ButtonElement(#PB_Any,10,30,50,35, "22_Butt")                                                                ;
  Define s=SplitterElement(#PB_Any,10,10,50,55, b1,b2, #_Flag_Separator_Circle)
  ;   Define s=SplitterElement(#PB_Any,10,10,50,55, -1,-1, #PB_Splitter_Separator_Circle) 
  ; SetElementAttribute(s, #_Element_FirstGadget, b1) : SetElementAttribute(s, #_Element_SecondGadget, b2)
  
  Define s=ContainerElement(#PB_Any,70,10,50,55, #_Flag_Vertical)
  Define b11=ButtonElement(#PB_Any,10,10,50,35, "12_Butt")                                                                ;
  Define b12=ButtonElement(#PB_Any,10,30,50,35, "22_Butt")            
  CloseElementList()                                                     ;
  
  ;   SetElementParent(b1,s)
  ;   SetElementParent(b2,s)
  
  AddPanelElementItem(e, -1, "Panel_3_long")
  ContainerElement(#PB_Any,10,10,150,55) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
  AddPanelElementItem(e, -1, "Panel_4", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
  ButtonElement(#PB_Any,110,30,50,35, "3_Butt")                                                               ;
  
  AddPanelElementItem(e, -1, "Panel_5")
  AddPanelElementItem(e, -1, "Panel_6")
  CloseElementList()
  
  SetElementState(e,1)
  ;Debug CountElement(s)
  
  ;BindGadgetElementEvent(e, @SplitterElementEvent(), #_Event_Change)
  WaitWindowEventClose(Window)
CompilerEndIf


;-
; Splitter element example
CompilerIf #PB_Compiler_IsMainFile
  Define Window = OpenWindowElement(#PB_Any, 0,0, 800,600);, "Demo SplitterElement()") 
  Define  t = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Define w = OpenWindowElement(#PB_Any, 30,30, 500,400, "Demo SplitterElement()")
  
  Define e31 = ButtonElement(#PB_Any, 0,0,0,0, "31ButtonElement")
  Define e32 = ButtonElement(#PB_Any, 0,0,0,0, "32ButtonElement")
  Define e3 = SplitterElement(#PB_Any, 0,0,500/2,400, e31,e32, #_Flag_Separator_Circle)
  
  Define e41 = ButtonElement(#PB_Any, 0,0,0,0, "41ButtonElement")
  Define e42 = ButtonElement(#PB_Any, 0,0,0,0, "42ButtonElement")
  Define e4 = SplitterElement(#PB_Any, 500/2,0,500/2,400, e41,e42, #_Flag_Separator_Circle)
  
  Define e = SplitterElement(#PB_Any, 0,0,500,400, e3,e4, #_Flag_Vertical|#_Flag_Separator_Circle)
  SetElementState(e3,ElementHeight(e)-40)
  SetElementState(e4,ElementHeight(e)-40)
  SetElementState(e,ElementWidth(e)-150)
  
  WaitWindowEventClose(Window)
CompilerEndIf


;-
; Splitter element example
CompilerIf #PB_Compiler_IsMainFile
  Define ww = 800
  Define wh = 500
  Procedure Properties_Size_Events(Event.q, EventElement)
    Protected iWidth = ElementWidth(EventElement)
    Protected iHeight = ElementHeight(EventElement)
    Protected Element = GetElementItemData(EventElement, GetElementState(EventElement))
    
    If Element
      Select Event 
          ;       Case #_Event_Create
          ;          Define i
          ; ;         For i=0 To CountElementItems(EventElement) - 1
          ;            Debug "count "+GetElementItemData(EventElement, i)
          ; ;           ResizeElement(GetElementItemData(EventElement, i), #PB_Ignore, #PB_Ignore, iWidth, iHeight)
          ; ;         Next
          ;         Debug EventElement
          ;         ResizeElement(EventElement, #PB_Ignore, #PB_Ignore, ElementWidth(GetElementParent(EventElement)), ElementHeight(GetElementParent(EventElement)))
          
        Case #_Event_Change, #_Event_Size
          ResizeElement(Element, #PB_Ignore, #PB_Ignore, iWidth, iHeight)
      EndSelect
    EndIf
  
  EndProcedure
  Procedure Form_Events(Event.q, EventElement)
    Protected iWidth = ElementWidth(EventElement)
    Protected iHeight = ElementHeight(EventElement)
    Protected Parent = GetElementData(EventElement);, GetElementState(EventElement))
    
    Select Event 
;       Case #_Event_Create
;          Define i
; ;         For i=0 To CountElementItems(EventElement) - 1
;            Debug "count "+GetElementItemData(EventElement, i)
; ;           ResizeElement(GetElementItemData(EventElement, i), #PB_Ignore, #PB_Ignore, iWidth, iHeight)
; ;         Next
;         Debug EventElement
;         ResizeElement(EventElement, #PB_Ignore, #PB_Ignore, ElementWidth(GetElementParent(EventElement)), ElementHeight(GetElementParent(EventElement)))
      
      Case #_Event_Move, #_Event_Size
;         SetElementAttribute(Parent, #PB_ScrollArea_InnerWidth, 50)
;         SetElementAttribute(Parent, #PB_ScrollArea_InnerHeight, 50)
        
        ;  ResizeElement(Element, #PB_Ignore, #PB_Ignore, iWidth, iHeight)
    EndSelect
    
  EndProcedure
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 900,600);, "Demo SplitterElement()") 
  Define  t = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  Define w = OpenWindowElement(#PB_Any, 30,30, ww,wh, "Demo SplitterElement()")
  
  
  Define e31 = PanelElement(#PB_Any,0,0,0,0, #_Flag_Transparent)                                                               ;
  Define ei=AddPanelElementItem(e31, #PB_Any, "Form", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
;   Define e311 = ScrollAreaElement(#PB_Any,0,0,0,0,200,100,1, #_Flag_AlignFull)
  Define f=OpenWindowElement(#PB_Any, 30,30, 200,100, "Window_0", #_Flag_AnchorsGadget, e31) : CloseElementList()
;   SetElementData(f, e311)
;   CloseElementList()
;   SetElementItemData(e31, ei, e311)
;   
;   BindGadgetElementEvent(f, @Form_Events())
  Define ei=AddPanelElementItem(e31, #PB_Any, "Code", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Paste.png")) 
  
  BindGadgetElementEvent(e31, @Properties_Size_Events(), #_Event_Size|#_Event_Change);|#_Event_Create)
  CloseElementList()
  
  Define e32 = ButtonElement(#PB_Any, 0,0,0,0, "32ButtonElement")
  Define e3 = SplitterElement(#PB_Any, 0,0,0,0, e31,e32, #_Flag_Separator_Circle)
  
  Define e4 = PanelElement(#PB_Any,0,0,0,0, #_Flag_Transparent) 
  ;
  Define ei=AddPanelElementItem(e4, #PB_Any, "Elements", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e51=PropertiesElement(#PB_Any, 0,0,0,0, #_Flag_Flat)
  AddPropertiesElementItem(e51, -1, "ComboBox Elements")
  AddPropertiesElementItem(e51, -1, "String Text Element")
  AddPropertiesElementItem(e51, -1, "Spin X 0|100")
  AddPropertiesElementItem(e51, -1, "Spin Y 0|200")
  ;Define e51 = ButtonElement(#PB_Any, 0,0,0,0, "51ButtonElement")
  Define e52 = ButtonElement(#PB_Any, 0,0,0,0, "52ButtonElement")
  Global e5 = SplitterElement(#PB_Any, 0,0,0,0, e51,e52, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e5)
  
  Define ei=AddPanelElementItem(e4, #PB_Any, "Properties", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e61=PropertiesElement(#PB_Any, 0,0,0,0, #_Flag_Flat)
  AddPropertiesElementItem(e61, -1, "ComboBox Elements")
  AddPropertiesElementItem(e61, -1, "String Text Element")
  AddPropertiesElementItem(e61, -1, "Spin X 0|100")
  AddPropertiesElementItem(e61, -1, "Spin Y 0|200")
  ;Define e61 = ButtonElement(#PB_Any, 0,0,0,0, "61ButtonElement")
  Define e62 = ButtonElement(#PB_Any, 0,0,0,0, "62ButtonElement")
  Global e6 = SplitterElement(#PB_Any, 0,0,0,0, e61,e62, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e6)
  
  Define ei=AddPanelElementItem(e4, #PB_Any, "Events", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e71 = ButtonElement(#PB_Any, 0,0,0,0, "71ButtonElement")
  Define e72 = ButtonElement(#PB_Any, 0,0,0,0, "72ButtonElement")
  Global e7 = SplitterElement(#PB_Any, 0,0,0,0, e71,e72, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e7)
  
  BindGadgetElementEvent(e4, @Properties_Size_Events(), #_Event_Size|#_Event_Change);|#_Event_Create)
  CloseElementList()
  
  Define e = SplitterElement(#PB_Any, 0,0,ww,wh, e3,e4, #_Flag_Vertical|#_Flag_Separator_Circle)
  
;    SetElementState(e4,2)
;    SetElementState(e4,1)
;    SetElementState(e4,0)
   
   
   SetElementState(e3,ElementHeight(e)-40)
   SetElementState(e5,ElementHeight(GetElementParent(e5))-40)
   SetElementState(e6,ElementHeight(GetElementParent(e6))-40)
   SetElementState(e7,ElementHeight(GetElementParent(e7))-40)
   SetElementState(e,ElementWidth(e)-240)
  
  WaitWindowEventClose(Window)
CompilerEndIf


