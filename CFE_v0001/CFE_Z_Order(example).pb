CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  Declare ParentLastElement(Element)
  Declare PrevPosition(Element)
  Declare NextPosition(Element)
  Declare FirstPosition(Element)
  Declare LastPosition(Element)
  Declare GetElementPosition(Element, Position=#PB_Default)
  Declare SetElementPosition(Element, Position, Element2 =- 1)
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


; Получить последный элемент у родителя
Procedure ParentLastElement(Parent)
  Protected LastElement =- 1
  
  With *CreateElement
      If IsElement(Parent)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Parent))
;       Debug \This()\Items()\Text\String$
;       Debug ElementID(Parent);
     
      While NextElement(\This()) 
        If IsChildElement(\This()\Element, Parent)
          LastElement = \This()\Element
        EndIf
      Wend
      
      If LastElement =- 1 : LastElement = Parent : EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  ;Debug LastElement
  ProcedureReturn LastElement
EndProcedure

; Получить предыдущий элемент
Procedure PrevPosition(Element) ; Ok
  Protected Item =- 1
  Protected Parent =- 1
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      Item = \This()\Item\Parent
      Parent = \This()\Parent\Element 
      
      While PreviousElement(\This())
        If \This()\Parent\Element = Parent And Item = \This()\Item\Parent     And \This()\Hide = #False  ; TODO
          Result = \This()\Element
          If Parent = Result
            Result =- 1
          EndIf
          Break
        EndIf
      Wend
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить следующий элемент
Procedure NextPosition(Element) ; Ok
  Protected Item =- 1
  Protected Parent =- 1
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      Item = \This()\Item\Parent
      Parent = \This()\Parent\Element
      
      While NextElement(\This())
        If \This()\Parent\Element = Parent And Item = \This()\Item\Parent      And \This()\Hide = #False ; TODO
          Result = \This()\Element
          Break
        EndIf
      Wend
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить первый элемент
Procedure FirstPosition(Element) ; Ok
  Protected Item =- 1
  Protected Parent =- 1
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      Item = \This()\Item\Parent
      Parent = \This()\Parent\Element
      ChangeCurrentElement(\This(), ElementID(Parent))
      
      While NextElement(\This()) 
        If \This()\Parent\Element = Parent And Item = \This()\Item\Parent     And \This()\Hide = #False ; TODO
          Result = \This()\Element 
          Break
        EndIf
      Wend 
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

; Получить последный элемент
Procedure LastPosition(Element) ; Ok
  Protected Item =- 1
  Protected Parent =- 1
  Protected Result =- 1
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element)) 
      Item = \This()\Item\Parent
      Parent = \This()\Parent\Element
      
      ; LastElement
      While NextElement(\This()) 
        If IsChildElement(\This()\Element, Parent) = #False And \This()\Hide = #False
          Break
        EndIf
      Wend
      
      While PreviousElement(\This()) 
        If \This()\Parent\Element = Parent And Item = \This()\Item\Parent And \This()\Hide = #False
          Break
        EndIf
      Wend
      
      Result = \This()\Element 
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

;-
; Получить Z-позицию элемента в окне
Procedure GetElementPosition(Element, Position=#PB_Default)
  Protected Result =- 1
  
  Select Position
    Case #_Element_PositionFirst : Result = FirstPosition(Element)
    Case #_Element_PositionPrev  : Result = PrevPosition(Element)
    Case #_Element_PositionNext  : Result = NextPosition(Element)
    Case #_Element_PositionLast  : Result = LastPosition(Element)
    Default                      : Result = Element;(Element)
  EndSelect
  
  ProcedureReturn Result
EndProcedure

; Позиционирование элементов (Positioning This)
Procedure SetElementPosition(Element, Position, Element2 =- 1) ; Ok
  Protected Type
  Protected Result =- 1
  
  If Element = Element2
    ProcedureReturn 0
  EndIf
  
  With *CreateElement
    If IsElement(Element)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(Element))
      Type = \This()\Type
      
      If IsElement(Element2)
        Select Position
          Case #_Element_PositionPrev : MoveElement(\This(), #PB_List_Before, ElementID(Element2))
            While NextElement(\This()) 
              If IsChildElement(\This()\Element, Element) ;And IsChildElement(\This()\Parent\Element, Parent)
                MoveElement(\This(), #PB_List_Before, ElementID(Element2))
              EndIf
            Wend
            
          Case #_Element_PositionNext : MoveElement(\This(), #PB_List_After, ElementID(Element2))
            While PreviousElement(\This()) 
              If IsChildElement(\This()\Element, Element) ; And IsChildElement(\This()\Parent\Element, Parent) 
                MoveElement(\This(), #PB_List_After, ElementID(Element))
              EndIf
            Wend
            
        EndSelect
      Else
        Select Position
          Case #_Element_PositionFirst 
            Protected FirstElement = FirstPosition(Element)
            
            If FirstElement <> Element
              SetElementPosition(Element, #_Element_PositionPrev, FirstElement)
            EndIf
            
          Case #_Element_PositionPrev 
            Protected PrevElement = PrevPosition(Element)
            
            If IsElement(PrevElement)
              SetElementPosition(Element, #_Element_PositionPrev, PrevElement)
            EndIf
            
          Case #_Element_PositionNext 
            Protected NextElement = NextPosition(Element) 
            
            If IsWindowElement(Element)
              NextElement = ParentLastElement(NextElement)
            EndIf
            
            If IsElement(NextElement)
              SetElementPosition(Element, #_Element_PositionNext, NextElement)
            EndIf
            
          Case #_Element_PositionLast 
            Protected LastElement = LastPosition(Element)
            
            If IsWindowElement(Element)
              LastElement = ParentLastElement(LastElement)
            EndIf
            
            If LastElement <> Element
              SetElementPosition(Element, #_Element_PositionNext, LastElement)
            EndIf
            
        EndSelect
      EndIf
      
      If Element2 =- 1
        
        If IsElement(\StickyWindow)
          PushListPosition(\This()) 
          ChangeCurrentElement(\This(), ElementID(\StickyWindow))
          MoveElement(\This(), #PB_List_Last)
          While PreviousElement(\This())
            If IsChildElement(\This()\Element, \StickyWindow) 
              MoveElement(\This(), #PB_List_After, ElementID(\StickyWindow))
            EndIf
          Wend
          PopListPosition(\This()) 
        EndIf
        
        If IsElement(\Sticky) 
          PushListPosition(\This()) 
          ChangeCurrentElement(\This(), ElementID(\Sticky))
          
          ;If \This()\Hide = 0
          MoveElement(\This(), #PB_List_Last)
          While PreviousElement(\This())
            If \This()\Sticky ;;; And \This()\Hide = 0 And \This()\Element <> \Sticky
              MoveElement(\This(), #PB_List_After, ElementID(\Sticky))
            EndIf
          Wend
          PopListPosition(\This()) 
          ;EndIf
        EndIf
        
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure


;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  Global Window_1, Window_2, Window_3, Window_4, Window_3_Panel =- 1
  Global Panel_1_First=-1,Panel_1_Prev=-1,Panel_1_Next=-1,Panel_1_Last=-1
  Global Panel_2_First=-1,Panel_2_Prev=-1,Panel_2_Next=-1,Panel_2_Last=-1
  Global Panel_3_First=-1,Panel_3_Prev=-1,Panel_3_Next=-1,Panel_3_Last=-1
  
  Procedure Window_First_Event(Event.q, EventElement)
    Select Event
      Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionFirst)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Prev_Event(Event.q, EventElement)
    Select Event
      Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionPrev)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Next_Event(Event.q, EventElement)
    Select Event
      Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionNext)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  Procedure Window_Last_Event(Event.q, EventElement)
    Select Event
      Case #_Event_LeftButtonDown : SetElementPosition(EventElement, #_Element_PositionLast)
    EndSelect
    
    ProcedureReturn #True
  EndProcedure
  
  
  Procedure Events(Event.q, EventElement)
    If Event = #_Event_LeftClick
      Debug "e "+EventElement+" p "+GetElementParent(EventElement)
    EndIf
  EndProcedure
  
  
  Define i
  Define w = OpenWindowElement(1, 0,0, 700,350, "Demo Z-Order") 
  
  Window_3 = OpenWindowElement( #PB_Any,200,150,250,150, "Next", 0, w);
  Window_4 = OpenWindowElement( #PB_Any,400,150,250,150, "Last", 0, w);
  Window_2 = OpenWindowElement( #PB_Any,50,150,250,150, "Prev", 0, w) ;
  Window_1 = OpenWindowElement( #PB_Any,10,10,680,150, "First", 0, w) ;
  
  BindWindowElementEvent(Window_1, @Window_First_Event(), #PB_All)
  BindWindowElementEvent(Window_2, @Window_Prev_Event(), #PB_All)
  BindWindowElementEvent(Window_3, @Window_Next_Event(), #PB_All)
  BindWindowElementEvent(Window_4, @Window_Last_Event(), #PB_All)
  
  SetElementData(Window_1, #PB_Ignore)
  SetElementData(Window_2, #PB_Ignore)
  SetElementData(Window_3, #PB_Ignore)
  SetElementData(Window_4, #PB_Ignore)
  
  
  OpenElementList(Window_3)
  Window_3_Panel = PanelElement(#PB_Any,30,10,190,100);, "Panel_0")                                                               ;
  AddElementItem(Window_3_Panel, -1, "Panel_1")
  Panel_1_Last = ButtonElement(#PB_Any,110,30,50,35, "1_Last")                                                               ;
  Panel_1_Next = ButtonElement(#PB_Any,70,30,50,35, "1_Next")                                                                ;
  Panel_1_Prev = ButtonElement(#PB_Any,30,30,50,35, "1_Prev")                                                                ;
  Panel_1_First = ButtonElement(#PB_Any,10,10,170,35, "1_First")                                                             ;
  
  BindGadgetElementEvent(Panel_1_First, @Window_First_Event(), #PB_All)
  BindGadgetElementEvent(Panel_1_Prev, @Window_Prev_Event(), #PB_All)
  BindGadgetElementEvent(Panel_1_Next, @Window_Next_Event(), #PB_All)
  BindGadgetElementEvent(Panel_1_Last, @Window_Last_Event(), #PB_All)
  
  
  AddElementItem(Window_3_Panel, -1, "Panel_2") 
  Panel_2_Last = ButtonElement(#PB_Any,110,30,50,35, "2_Last")                                                               ;
  Panel_2_Next = ButtonElement(#PB_Any,70,30,50,35, "2_Next")                                                                ;
  Panel_2_Prev = ButtonElement(#PB_Any,30,30,50,35, "2_Prev")                                                                ;
  Panel_2_First = ButtonElement(#PB_Any,10,10,170,35, "2_First")                                                             ;
  
  BindGadgetElementEvent(Panel_2_First, @Window_First_Event(), #PB_All)
  BindGadgetElementEvent(Panel_2_Prev, @Window_Prev_Event(), #PB_All)
  BindGadgetElementEvent(Panel_2_Next, @Window_Next_Event(), #PB_All)
  BindGadgetElementEvent(Panel_2_Last, @Window_Last_Event(), #PB_All)
  
  
  AddElementItem(Window_3_Panel, -1, "Panel_3")
  Panel_3_Last = ButtonElement(#PB_Any,110,30,50,35, "3_Last")                                                               ;
  Panel_3_Next = ButtonElement(#PB_Any,70,30,50,35, "3_Next")                                                                ;
  Panel_3_Prev = ButtonElement(#PB_Any,30,30,50,35, "3_Prev")                                                                ;
  Panel_3_First = ButtonElement(#PB_Any,10,10,170,35, "3_First")                                                             ;
  
  BindGadgetElementEvent(Panel_3_First, @Window_First_Event(), #PB_All)
  BindGadgetElementEvent(Panel_3_Prev, @Window_Prev_Event(), #PB_All)
  BindGadgetElementEvent(Panel_3_Next, @Window_Next_Event(), #PB_All)
  BindGadgetElementEvent(Panel_3_Last, @Window_Last_Event(), #PB_All)
  
  
  ;     AddElementItem(Window_3_Panel, -1, "Panel_4_long")
  ;     ; TODO 
  ;     ;CreateElement(#_Type_Container, #PB_Any,10,10,150,55, "cont") 
  ;     ButtonElement(#PB_Any,5,20,150,25, "butt") 
  ;     ;CloseElementList()
  ;     
  ;     AddElementItem(Window_3_Panel, -1, "Panel_5")
  ;     AddElementItem(Window_3_Panel, -1, "Panel_6")
  CloseElementList()
  CloseElementList()
  
  ;}
  
  WaitWindowEventClose(w)
CompilerEndIf

