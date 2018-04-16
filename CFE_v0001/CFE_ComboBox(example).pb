CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
;   - AddGadgetItem()      ; Add an Item. 
;   - GetGadgetItemText()  ; Returns the Gadget Item Text. 
;   - CountGadgetItems()   ; Count the items in the current combobox. 
;   - ClearGadgetItems()   ; Remove all the items. 
;   - RemoveGadgetItem()   ; Remove an Item. 
;   - SetGadgetItemText()  ; Changes the Gadget Item Text. 
;   - SetGadgetItemImage() ; Changes the Gadget Item Image (need To be created With the #PB_ComboBox_Image Flag). 
;   - GetGadgetState()     ; Get the Index (starting from 0) of the current Element, -1 If no Element added Or Not selected. 
;   - GetGadgetText()      ; Get the (Text) content of the current Element. 
;   - SetGadgetState()     ; Change the selected Element. 
;   - SetGadgetText()      ; Set the displayed Text. If the ComboBoxGadget is Not editable, the Text must be in the dropdown List. 
;   - GetGadgetItemData()  ; Returns the value that was stored With Item. 
;   - SetGadgetItemData()  ; Stores a value With the Item. 


  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ Window element functions
Procedure DrawComboBoxElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected X,Y,Width,Height
  
  With *CreateElement\This()
    
    If ListSize(\Items())
      X = \InnerCoordinate\X
      Y = (\FrameCoordinate\Y+\bSize)
      
      PushListPosition(\Items())
      ForEach \Items()
        
        If ListIndex(\Items()) = 0 
          If ((\Flag & #_Flag_Editable) = #_Flag_Editable)
            If ((\Items()\State & #_State_Default) = #_State_Default)
              \Items()\FrameCoordinate\Y = 0
              \Items()\FrameCoordinate\Height = \InnerCoordinate\Height
              \Items()\FrameCoordinate\Width = \Item\Width
              \Items()\FrameCoordinate\X = (\InnerCoordinate\Width-\Item\Width)
              
            ElseIf ((\Items()\State & #_State_Entered) = #_State_Entered)
              \Items()\FrameCoordinate\Y =- 1
              \Items()\FrameCoordinate\Height = \FrameCoordinate\Height-\bSize+1
              \Items()\FrameCoordinate\Width = \Item\Width+1
              \Items()\FrameCoordinate\X = (\InnerCoordinate\Width-\Item\Width)
            EndIf
          Else
            ;\Items()\bSize = 1
            \Items()\FrameCoordinate\Y =- 1
            \Items()\FrameCoordinate\X =- 1
            \Items()\FrameCoordinate\Height = \FrameCoordinate\Height
            \Items()\FrameCoordinate\Width = \FrameCoordinate\Width
          EndIf
        EndIf
        
        DrawContent(\Items(), X,Y)
      Next
      PopListPosition(\Items())
    EndIf
    
  EndWith
EndProcedure

Procedure SetComboBoxElementState(List This.S_CREATE_ELEMENT(), State)
  Protected Text$
  
  With This()
    Protected ElementID = @This()
    
    If IsElement(This()\Linked\Element)
      ChangeCurrentElement(This(), ElementID(This()\Linked\Element))
    EndIf
    
    If IsElementItem(State)
      ChangeCurrentElement(This()\Items(), ItemID(State))
      Text$ = This()\Items()\Text\String$
    EndIf
    
    ChangeCurrentElement(This(), ElementID)
    This()\Text\String$ = Text$
  EndWith
  
EndProcedure

Procedure.q SetComboBoxElementFlag(Flag.q)
  Protected Result.q = Flag
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetComboBoxElementFlag(Flag.q)
  Protected Result.q = Flag
  
  ProcedureReturn Result
EndProcedure

;RemoveGadgetItem(#Gadget, Position)


Procedure AddComboBoxElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
  Protected ImageWidth, ImageHeight, TextWidth, TextHeight
  
  With *CreateElement
    If \This()\Linked\Element
     ; Debug Text$
      GadgetItem = AddGadgetElementItem(\This()\Linked\Element, GadgetItem, Text$, Image, Flag|#_Flag_Text_Center|#_Flag_Text_Left);#_Flag_Image_Center|#_Flag_Text_Center|#_Flag_Image_Left|#_Flag_Text_Right)
    EndIf
  EndWith
  
  ProcedureReturn GadgetItem
EndProcedure

; Procedure ComboBoxLeftButtonDownEvent()
;   
;   With *CreateElement
;     PushListPosition(\This())
;     ChangeCurrentElement(\This(), ElementID(Element))
;     ;\This()\Linked\Element
;     
;   Select Event
;                 Case #_Event_LeftButtonDown
;                   If \This()\Linked\Element > 0 
;                     If \Popup 
;                       \PopupElement = \This()\Linked\Element
;                       
;                       If \PopupElement
;                         iWidth = \This()\InnerCoordinate\Width
;                         DisplayPopupMenuElement(\PopupElement, EventElement, \This()\InnerCoordinate\X-1, 
;                                                 (\This()\InnerCoordinate\Y+\This()\InnerCoordinate\Height))
;                         ResizeElement(\PopupElement, #PB_Ignore, #PB_Ignore, iWidth+2, #PB_Ignore, #PB_Ignore)
;                         
;                         ; Чтобы при раскритии списка,
;                         ; выбранно был,
;                         ; последний выбранный элемент
;                         PushListPosition(\This())
;                         ChangeCurrentElement(\This(), ElementID(\PopupElement))
;                         Protected Active = \This()\Item\Selected\Element 
;                         
;                         PushListPosition(\This())
;                         ChangeCurrentElement(\This(), ElementID(EventElement))
;                         If \This()\Item\Active =- 1 : \This()\Item\Active = Active : EndIf
;                         Active = \This()\Item\Active
;                         PopListPosition(\This())
;                         
;                         \This()\Item\Entered\Element = Active
;                         \This()\Item\Selected\Element =- 1
;                         PopListPosition(\This())
;                       EndIf
;                     Else
;                       If \PopupElement 
;                         HideElement(\PopupElement, #True)
;                       EndIf
;                     EndIf
;                   EndIf
;                   
;               EndSelect
              
            
;     PopListPosition(\This())         
;   EndWith
;   
; EndProcedure

Procedure ComboBoxElement( Element, X,Y,Width,Height, Flag.q = 0, Parent =- 1, Radius = 0 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ComboBox, Element, X,Y,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag  )
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Protected Type = \This()\Type
    Protected ElementItem = AddElementItem( Element, 0, "" )
    
    If ((Flag&#_Flag_CheckBoxes)=#_Flag_CheckBoxes)
      \This()\Linked\Element = ListIconElement( #PB_Any, 0,0,0,0, "", Width, #_Flag_CheckBoxes|#_Flag_Invisible, 0 )
      ;\This()\Linked\Element = ListViewElement( #PB_Any, 0,0,0,0, "", Flag|#_Flag_Invisible, Element )
    Else
      \This()\Linked\Element = CreatePopupMenuElement(#PB_Any) 
      ;\This()\Linked\Element = ListViewElement( #PB_Any, 0,0,0,0, "", #_Flag_Invisible, 0 )
    EndIf
    
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(\This()\Linked\Element))
    \This()\Item\Parent = Element 
    \This()\Item\Type = Type 
    \This()\FrameCoordinate\Width = Width
    \This()\FrameCoordinate\Height = Height
    \This()\BackColor = $FFFFFF
    PopListPosition(\This())
    
    PopListPosition(\This())         
  EndWith
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  Global eCombo, gCombo
  
  ;{
  Procedure ButtonsGadgetsEvents()
    Select EventType()
      Case #PB_EventType_LeftClick
        
        ;ClearGadgetItems(gCombo) : AddGadgetItem(gCombo, 0,Str(0)+"_item_long_very_long")
        RemoveGadgetItem(gCombo, 3)
        
           
  EndSelect
  EndProcedure
  
  Procedure ComboBoxGadgetEvent()
    Select EventType()
      Case #PB_EventType_Focus
        Debug Str(EventGadget())+" - focus"
      Case #PB_EventType_LostFocus
        Debug Str(EventGadget())+" - lost focus"
      Case #PB_EventType_Change
        Debug Str(GetGadgetState(EventGadget()))+" - item change"
    EndSelect
  EndProcedure
  
  If OpenWindow(#PB_Any, 10,10,200,320, "BorderLess", #PB_Window_BorderLess)
    Define i
    
    gCombo=ComboBoxGadget(#PB_Any, 10,10,80,23)
    For i=0 To 10
      AddGadgetItem(gCombo, i,Str(i)+"_item_long_very_long")
    Next
    SetGadgetState(gCombo,3)
    
    BindGadgetEvent(gCombo, @ComboBoxGadgetEvent());, #PB_EventType_LeftClick)
    SpinGadget(#PB_Any, 10,38,80,23, 0,100, #PB_Spin_Numeric)
    
    Define g=ComboBoxGadget(#PB_Any, 10,66,80,23,#PB_ComboBox_Editable)
    For i=0 To 3
      AddGadgetItem(g, i,Str(i)+"_item_long_very_long")
    Next
    SetGadgetState(g,2)
    
    Define e=ButtonGadget(#PB_Any, 100,10,80,23,"Clears")
    BindGadgetEvent(e, @ButtonsGadgetsEvents())
    BindGadgetEvent(g, @ComboBoxGadgetEvent());, #PB_EventType_LeftClick)
  EndIf
  ;}
  
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  
  Procedure ButtonsEvents(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_LeftClick
        
        ;ClearElementItems(eCombo) : AddGadgetElementItem(eCombo, 0,Str(0)+"_item_long_very_long")
        RemoveElementItem(eCombo, 3)
        
       
  EndSelect
  EndProcedure
  
  OpenWindowElement(#PB_Any, 220,10,200,320, "BorderLess", #PB_Window_BorderLess) ; |#PB_Window_MoveGadget
  Define i
  
  Procedure ComboBoxElementEvent(Event.q, EventElement)
    
    Select ElementEvent()
      Case #_Event_Focus
        Debug Str(EventElement())+" - focus"
      Case #_Event_LostFocus
        Debug Str(EventElement())+" - lost focus"
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement()))+" - item change"
    EndSelect
    
  EndProcedure
  
  eCombo=ComboBoxElement(#PB_Any, 10,10,80,23)
  For i=0 To 10
    AddGadgetElementItem(eCombo, i,Str(i)+"_item_long_very_long")
  Next
  SetElementState(eCombo, 3)
  
  BindGadgetElementEvent(eCombo, @ComboBoxElementEvent(), #_Event_Change)
  
  Procedure SpinElementEvent(Event.q, EventElement)
    
    Select ElementEvent()
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        Debug Str(GetElementState(EventElement()))+" - item change"
    EndSelect
    
  EndProcedure
  
  Define e=SpinElement(#PB_Any, 10,38,80,23, 0,10, #_Flag_Numeric)
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  Define e=SpinElement(#PB_Any, 10,66,80,23, -10.12,10.35, #_Flag_Numeric|#_Flag_Text_Right,-1, "0.23")
  BindGadgetElementEvent(e, @SpinElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  Define e=ComboBoxElement(#PB_Any, 10,94,80,20,#_Flag_Editable)
  For i=0 To 3
    AddGadgetElementItem(e, i,Str(i)+"_item_long_very_long")
  Next
  SetElementState(e, 0)
  BindGadgetElementEvent(e, @ComboBoxElementEvent(), #_Event_Change|#_Event_Focus|#_Event_LostFocus)
  
  Define e=ButtonElement(#PB_Any, 100,10,80,23,"Clears")
  BindGadgetElementEvent(e, @ButtonsEvents())
  
  eCombo=ComboBoxElement(#PB_Any, 10,150,180,23, #_Flag_CheckBoxes)
  For i=0 To 5
    AddGadgetElementItem(eCombo, i,Str(i)+"_item_long_very_long")
  Next
  
  Procedure Events(Event.q, EventElement)
    Select Event
      Case #_Event_Create
        Debug ElementClass(ElementType(EventElement))
        
      Case #_Event_Change
        Debug ElementClass(ElementType(EventElement))
    EndSelect
    
  EndProcedure
  
  BindEventElement(@Events())
  WaitWindowEventClose(Window)
CompilerEndIf

