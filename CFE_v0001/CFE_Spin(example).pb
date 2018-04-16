CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ;   - AddGadgetItem()      ; Add an Item. 
  ;   - GetGadgetItemText()  ; Returns the Gadget Item Text. 
  ;   - CountGadgetItems()   ; Count the items in the current Spin. 
  ;   - ClearGadgetItems()   ; Remove all the items. 
  ;   - RemoveGadgetItem()   ; Remove an Item. 
  ;   - SetGadgetItemText()  ; Changes the Gadget Item Text. 
  ;   - SetGadgetItemImage() ; Changes the Gadget Item Image (need To be created With the #PB_Spin_Image Flag). 
  ;   - GetGadgetState()     ; Get the Index (starting from 0) of the current Element, -1 If no Element added Or Not selected. 
  ;   - GetGadgetText()      ; Get the (Text) content of the current Element. 
  ;   - SetGadgetState()     ; Change the selected Element. 
  ;   - SetGadgetText()      ; Set the displayed Text. If the SpinGadget is Not editable, the Text must be in the dropdown List. 
  ;   - GetGadgetItemData()  ; Returns the value that was stored With Item. 
  ;   - SetGadgetItemData()  ; Stores a value With the Item. 
  
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Window element functions
Procedure DrawSpinElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected iX,iY
  
  With This()
    
    If ListSize(\Items())
      iX = \InnerCoordinate\X
      iY = (\FrameCoordinate\Y+\bSize)
      
      ForEach \Items()
        \Items()\FrameCoordinate\Width = (\Item\Width-1) - 2
        \Items()\FrameCoordinate\X = (\InnerCoordinate\Width-\Item\Width) + 2
        \Items()\FrameCoordinate\Height = \InnerCoordinate\Height/2-1
        
        If ListIndex(\Items()) = 0 
          \Items()\FrameCoordinate\Y = 1
          
        ElseIf ListIndex(\Items()) = 1 
          If ((\InnerCoordinate\Height)%2) 
            \Items()\FrameCoordinate\Y = \InnerCoordinate\Height/2+1
          Else
            \Items()\FrameCoordinate\Y = \InnerCoordinate\Height/2
          EndIf
          
        EndIf
        
        DrawContent(\Items(), iX,iY)
      Next
    EndIf
    
  EndWith
EndProcedure

Procedure DrawingSpinElementContent(List This.S_CREATE_ELEMENT())
  Protected iX,iY,iWidth,iHeight
  
  With This()
    iX = \InnerCoordinate\X 
    iY = \InnerCoordinate\Y
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    DrawingMode(#PB_2DDrawing_Default) 
    ; Линия слева для красоты
    Line(iX+(iWidth-\Item\Width),iY,1,iHeight,\FrameColor)
    ;SetOrigin(iX,iY)
    
    ; Draw arrow on the element
    Select ListIndex(This())
      Case 0 : DrawArrow(iX+((3*2))/2,(iY+((iHeight-2)/2)),2,1,$555555)
      Case 1 : DrawArrow(iX+((3*2))/2,(iY+((iHeight-2)/2)),2,3,$555555)
    EndSelect
  EndWith
EndProcedure

Procedure SetSpinElementState(State.f)
  With *CreateElement\This()
    \Spin\Value = State
    \Text\String$ = StrF(State, \Spin\Decimals)
  EndWith
EndProcedure

Procedure.q SetSpinElementFlag(Flag.q)
  Protected Result.q = Flag
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetSpinElementFlag(Flag.q)
  Protected Result.q = Flag
  
  ProcedureReturn Result
EndProcedure


Procedure SpinElementCallBack(Event.q, EventElement, EventElementItem)
  Protected PostEvent.q
        
  With *CreateElement\This() 
    Select Event
      Case #_Event_LeftClick
        \Spin\Value = ValF(\Text\String$)
        
        Select EventElementItem
          Case 0 
            If (\Spin\Value < \Spin\Max) : \Spin\Value+\Spin\Increment 
              PostEvent = #_Event_Up
            EndIf
            
          Case 1 
            If (\Spin\Value > \Spin\Min) : \Spin\Value-\Spin\Increment 
              PostEvent = #_Event_Down
            EndIf
        EndSelect
        
        If PostEvent
          PostEventElement(PostEvent, EventElement, \Items()\Element)
        EndIf
        
        If ((\Flag & #_Flag_Numeric) = #_Flag_Numeric)
          If (\Spin\Value >= \Spin\Min) And (\Spin\Value =< \Spin\Max)
            \Text\String$ = StrF(\Spin\Value,\Spin\Decimals)
            PostEventElement(#_Event_Change, EventElement, \Items()\Element)
          EndIf
        EndIf
        
    EndSelect  
  EndWith
EndProcedure


Procedure SpinElement( Element, X,Y,Width,Height, Min.f, Max.f, Flag.q = 0, Parent =- 1, Increment$="1", Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Spin, Element, X,Y,Width,Height,"", Min, Max, @Increment$, Flag  )
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    
    If Radius
      \This()\Radius = Radius
    EndIf
    PopListPosition(\This())         
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  
  Procedure SpinGadgetEvent()
    Select EventType()
      Case #PB_EventType_Down
        Debug Str(EventGadget())+" - Down"
      Case #PB_EventType_Up
        Debug Str(EventGadget())+" - Up"
      Case #PB_EventType_Change
        Debug Str(GetGadgetState(EventGadget()))+" - item change"
    EndSelect
  EndProcedure
  
  Define i
  OpenWindow(#PB_Any, 10,10,200,90, "BorderLess", #PB_Window_BorderLess)
  
  Define g=SpinGadget(#PB_Any, 10,10,80,25,0,10,#PB_Spin_Numeric)
  SetGadgetState(g,3)
  
  BindGadgetEvent(g, @SpinGadgetEvent());, #PB_EventType_LeftClick)
  
  Define g=SpinGadget(#PB_Any, 10,40,80,25,0,10,#PB_Spin_ReadOnly)
  SetGadgetState(g,2)
  
  BindGadgetEvent(g, @SpinGadgetEvent());, #PB_EventType_LeftClick)
  
  
  
  Define i
  OpenWindowElement(#PB_Any, 220,10,200,90, "BorderLess", #PB_Window_BorderLess) ; |#PB_Window_MoveGadget
  
  Procedure SpinElementEvent(Event.q, EventElement)
    If EventElement = 5
      Select ElementEvent()
        Case #_Event_Up
          SetElementState(EventElement,GetElementState(EventElement))
          SetElementText(EventElement, Str(GetElementState(EventElement)))
          
        Case #_Event_Down
          SetElementState(EventElement,GetElementState(EventElement))
          SetElementText(EventElement, Str(GetElementState(EventElement)))
          
      EndSelect
    EndIf
    
    Select ElementEvent()
      Case #_Event_Up
        Debug Str(EventElement)+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement)+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement))+" - item change"
        Debug GetElementState(EventElement)
    EndSelect
    
  EndProcedure
  
  Define e=SpinElement(#PB_Any, 60,10,80,25+8,0,10, #_Flag_MoveGadget|#_Flag_SizeGadget|#_Flag_Numeric,#PB_Default, "0.23",4)
  SetElementState(e, 3)
  
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  Define e=SpinElement(15, 60,40,80,25+8,0,100, #_Flag_MoveGadget|#_Flag_SizeGadget|#_Flag_Numeric|#_Flag_ReadOnly,#PB_Default,"5")
  ;SetElementState(e, 5) : SetElementText(e, "5")
  
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  WaitWindowEventClose(Window)
CompilerEndIf

