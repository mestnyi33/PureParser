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
  Declare SetPropertiesComboBoxText(Element, Text$)
  XIncludeFile "CFE.pbi"
CompilerEndIf

Global dbs = 8

;{ Window element functions
Procedure DrawPropertiesElementItemsContent(List This.S_CREATE_ELEMENT())
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

Procedure.q SetPropertiesElementFlag(Flag.q)
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

Procedure.q GetPropertiesElementFlag(Flag.q)
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


Procedure ResizePropertiesScrollVert(List This.S_CREATE_ELEMENT(), Height, bSize)
  
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

Procedure ResizePropertiesScrollHorz(List This.S_CREATE_ELEMENT(), Width, bSize)
  
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

Procedure PropertiesSizeEvent(Event.q, EventElement)
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
        
        If IsElement(\Scroll\Vert)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Vert))
          
          ResizeElement(\Element, (X+iWidth)-\FrameCoordinate\Width, #PB_Ignore, #PB_Ignore, iHeight, #PB_Ignore)
          
          If \Scroll\Max =< Height
            \HideState = 1
            \Hide = 1
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, iWidth-1, #PB_Ignore);, #PB_Ignore)
          Else 
            \HideState = 0
            \Hide = 0
            ResizeElement(\Scroll\Element, #PB_Ignore, #PB_Ignore, (iWidth-\FrameCoordinate\Width), #PB_Ignore);, #PB_Ignore)
          EndIf
          
          SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Height)
          
        EndIf
        
        PopListPosition(*CreateElement\This())    
        
        
      EndWith
  EndSelect
  
  ProcedureReturn #True
EndProcedure


;- PRIVATE
Procedure PropertiesScrollEvent(Event.q, EventElement)
  Protected IsVertical, Bs, Vb,Hb,X,Y,Width, Height, ElementWidth, ElementHeight
  
  Select ElementEvent()
    Case #_Event_Size
       PropertiesSizeEvent(Event.q, EventElement)
      
    Case #_Event_Up, #_Event_Down;, #_Event_Change
      With *CreateElement
        IsVertical = Bool((\This()\Flag&#_Flag_Vertical)=#_Flag_Vertical) 
        
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
      
    ProcedureReturn #True
EndSelect
  
  
EndProcedure


;- PUBLIC
Procedure GetPropertiesElementAttribute(List This.S_CREATE_ELEMENT(), Attribute)
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

Procedure SetPropertiesElementAttribute(List This.S_CREATE_ELEMENT(), Attribute, Value)
  Protected iX,iY,iWidth,iHeight
  Protected Update, X=#PB_Ignore,Y=#PB_Ignore,Width=#PB_Ignore,Height=#PB_Ignore 
  
  With This()
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    Select Attribute
      Case #PB_ScrollArea_X
        If \Linked\Area\X <> Value : \Linked\Area\X = Value
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
          If Value<\Scroll\Min : Value=\Scroll\Min : EndIf
          If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) 
            Value=((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
          EndIf
          \Scroll\Pos = Value
          \Scroll\ThumbPos = (\Scroll\ButtonSize + Round(\Scroll\Pos * (\Scroll\Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest))
          PopListPosition(This())
          Update = #True
          X=-Value
        EndIf
        
      Case #PB_ScrollArea_Y
        If \Linked\Area\Y <> Value : \Linked\Area\Y = Value
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
          If Value<\Scroll\Min : Value=\Scroll\Min : EndIf
          If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) 
            Value=((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength)
          EndIf
          \Scroll\Pos = Value
          \Scroll\ThumbPos = (\Scroll\ButtonSize + Round(\Scroll\Pos * (\Scroll\Area / (\Scroll\Max-\Scroll\Min)), #PB_Round_Nearest))
          PopListPosition(This())
          Update = #True
          Y=-Value
        EndIf
        
      Case #PB_ScrollArea_InnerWidth
        If \Linked\Area\Width <> Value : \Linked\Area\Width = Value
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
          If Value < \Scroll\PageLength
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, \Scroll\PageLength)
            ;             If \Scroll\Max < iWidth
            ;               ResizeElement(\Linked\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\Y+\FrameCoordinate\Height), #PB_Ignore)
            ;               ResizeElement(\Scroll\Vert, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\Y-\FrameCoordinate\Height), #PB_Ignore)
            ;             EndIf
            \Hide = 1
          Else
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, Value+17)
            ;             If \Scroll\Max < iWidth
            ;               ResizeElement(\Linked\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\Y), #PB_Ignore)
            ;               ResizeElement(\Scroll\Vert, #PB_Ignore, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\Y-\FrameCoordinate\Height*2), #PB_Ignore)
            ;             EndIf
            \Hide = 0
          EndIf
          If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) : X =- ((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) : EndIf
          PopListPosition(This())
          Update = #True
          Width=Value
        EndIf
        
      Case #PB_ScrollArea_InnerHeight
        If \Linked\Area\Height <> Value : \Linked\Area\Height = Value
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
          
          If Value < \Scroll\PageLength
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, \Scroll\PageLength)
            ;             If \Scroll\Max < iHeight
            ResizeElement(\Linked\Element, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\X+\FrameCoordinate\Width), #PB_Ignore, #PB_Ignore)
            ;               ResizeElement(\Scroll\Horz, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\X-\FrameCoordinate\Width), #PB_Ignore, #PB_Ignore)
            ;             EndIf
            \Hide = 1
          Else
            SetScrollBarElementAttribute(This(), #PB_ScrollBar_Maximum, Value+17)
            ;             If \Scroll\Max < iHeight
            ResizeElement(\Linked\Element, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\X), #PB_Ignore, #PB_Ignore)
            ;               ResizeElement(\Scroll\Horz, #PB_Ignore, #PB_Ignore, (\FrameCoordinate\X-\FrameCoordinate\Width*2), #PB_Ignore, #PB_Ignore)
            ;             EndIf
            \Hide = 0
          EndIf
          
          If Value>((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) : Y =- ((\Scroll\Max-\Scroll\Min)-\Scroll\PageLength) : EndIf
          PopListPosition(This())
          Update = #True
          Height=Value
        EndIf
        
      Case #PB_ScrollArea_ScrollStep
        If \Scroll\ScrollStep <> Value : \Scroll\ScrollStep = Value
          PushListPosition(This())
          ChangeCurrentElement(This(), ElementID(\Scroll\Vert)) : \Scroll\ScrollStep = Value
          ChangeCurrentElement(This(), ElementID(\Scroll\Horz))  : \Scroll\ScrollStep = Value
          PopListPosition(This())
        EndIf
        
    EndSelect
    
    If Update
      ResizeElement(\Linked\Element, X,Y,Width,Height)
    EndIf
  EndWith
  
EndProcedure

Procedure SetPropertiesComboBoxText(Element, Text$)
  Protected j, Buffer$
  
  ClearElementItems(Element)
  
  For j = (1) To CountString(Text$, "|" ) + (1)
    Buffer$ = Trim( StringField(Text$, j, "|" ))
    If Buffer$ 
      AddGadgetElementItem(Element, j-1, Buffer$)
    EndIf
  Next
  
EndProcedure

Procedure.S GetPropertiesComboBoxCheckedText(Element)
  Protected j, Buffer$
  
  For j=0 To CountElementItems(Element)-1
    If GetElementItemState(Element, j)
      Buffer$ +"|"+ GetElementItemText(Element, j)
    EndIf
  Next
  
  ProcedureReturn Trim(Buffer$)
EndProcedure

Procedure PropertiesInfoEvent(Event.q, EventElement)
  ;ProcedureReturn 
  Protected Element = GetElementItemData(EventElement, EventElementItem())
  If GetActiveElement() <> Element
    SetActiveElement(Element)
  EndIf
  
  ProcedureReturn #True
EndProcedure

Procedure PropertiesEvent(Event.q, EventElement)
  ;ProcedureReturn 
    With *CreateElement
      Protected Item = GetElementData(EventElement)
      
      Select Event
        Case #_Event_MouseEnter
          If GetActiveElement() <> EventElement
            SetActiveElement(EventElement)
          EndIf
        Default
          PushListPosition(\This()) 
          ChangeCurrentElement(\This(), ElementID(GetElementParent(EventElement)))
          ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
          
          If IsElement(\This()\Splitter\FirstElement)
            ChangeCurrentElement(\This(), ElementID(\This()\Splitter\FirstElement))
            ;Debug ElementClass(\This()\Type) ; GetElementParent(EventElement)
            SetElementState(\This()\Element, Item)
          EndIf
          PopListPosition(\This())
      EndSelect
    EndWith
   
  ProcedureReturn #True
EndProcedure

Procedure AddPropertiesElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
  Static Count, Gadget : If Gadget <> GadgetElement : Gadget = GadgetElement : Count = 0 : EndIf
    
  Protected ScrollHeightElement, ScrollAreaElement, OpenElementList, ElementHeight, Type$, Info$, Title$
  Protected z=1, iX, iY=z, iWidth, iHeight=19,FirstElement=-1, SecondElement=-1
  
  With *CreateElement
    If IsElement(GadgetElement)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(GadgetElement))
      ScrollAreaElement=\This()\Scroll\Element
      
      ScrollHeightElement=\This()\Scroll\Vert
      ElementHeight = \This()\FrameCoordinate\Height
      
;       PushListPosition(\This()) 
      If IsElement(ScrollAreaElement)
        ChangeCurrentElement(\This(), ElementID(ScrollAreaElement))
        iX = \This()\Splitter\Pos
        FirstElement=\This()\Splitter\FirstElement
        SecondElement=\This()\Splitter\SecondElement
        
        If IsElement(SecondElement)
          ChangeCurrentElement(\This(), ElementID(SecondElement))
          iWidth = \This()\InnerCoordinate\Width 
        EndIf
      EndIf
;       PopListPosition(\This())
    
      Type$ = Trim(StringField(Text$, 1, " "))
      Info$ = Trim(StringField(Text$, 2, " ")) : If Info$ : Info$+":" : EndIf
      Title$ = Trim(StringField(Text$, 3, " "))
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  
  If Count
    ;  iY = ((CountElement(SecondElement))*(iHeight+1))+z
    iY = (Count*(iHeight+z))+z
  EndIf
  
  
  AddListViewElementItem(FirstElement, Count, Info$, iHeight-2, #_Flag_Text_Right)
  
  OpenElementList = OpenElementList(SecondElement)
  
  Select Type$
    Case "Splitter"   
      Define g1=-1, g2=-1
      GadgetItem = SplitterElement(GadgetItem,0,iY,iWidth,iHeight,g1,g2,#_Flag_Vertical|#_Flag_BorderLess)
      g1 = ComboBoxElement(#PB_Any,0,0,0,0)
      g2 = ComboBoxElement(#PB_Any,0,0,0,0)
      SetElementData(g1, Count)
      SetElementData(g2, Count)
      SetElementAttribute(GadgetItem, #PB_Splitter_FirstGadget, g1)
      SetElementAttribute(GadgetItem, #PB_Splitter_SecondGadget, g2)
      
    Case "StringButton"   
      Protected StringButton = StringElement(#PB_Any,0,iY,iWidth,iHeight,Title$)  
      GadgetItem = ButtonElement(GadgetItem,iWidth-iHeight+2,iY+1,iHeight-2,iHeight-2,"...");,0,GadgetItem)
      SetElementData(StringButton, GadgetItem)
      
      ;SetElementData(g2, Count)
      
    Case "Button"   : GadgetItem = ButtonElement(GadgetItem,0,iY,iWidth,iHeight,Title$, #_Flag_Text_Left)
    Case "String"   : GadgetItem = StringElement(GadgetItem,0,iY,iWidth,iHeight,Title$)
    Case "Spin"     : GadgetItem = SpinElement(GadgetItem,0,iY,iWidth,iHeight,-1000,1000, #_Flag_Numeric);|#_Flag_AlignRight)
    Case "ComboBox" 
        Debug Flag
      If ((Flag&#_Flag_CheckBoxes)=#_Flag_CheckBoxes)
        GadgetItem = ComboBoxElement(GadgetItem,0,iY,iWidth,iHeight, #_Flag_CheckBoxes)
      ElseIf ((Flag&#PB_ComboBox_Editable)=#PB_ComboBox_Editable)
        GadgetItem = ComboBoxElement(GadgetItem,0,iY,iWidth,iHeight, #_Flag_Editable)
      Else
        GadgetItem = ComboBoxElement(GadgetItem,0,iY,iWidth,iHeight)
      EndIf
      
      Protected II, Includes.S=Title$, Include.S
      
      For II = (1) To CountString( Includes.S, "|" ) + (1)
        Include.S = Trim( StringField( Includes.S, II, "|" ))
        If Include.S 
          AddGadgetElementItem(GadgetItem, II-1, Include.S)
        EndIf
      Next
      
      If Include.S = "False"
        SetElementState(GadgetItem, 1)
      Else
        SetElementState(GadgetItem, 0)
      EndIf
      
  EndSelect
  
  
  CloseElementList()
  
  OpenElementList(OpenElementList)
  SetElementItemData(FirstElement, Count, GadgetItem)
  SetElementData(GadgetItem, Count)
  BindGadgetElementEvent(GadgetItem, @PropertiesEvent(), #_Event_LeftClick|#_Event_MouseEnter)
  
  Count+1
  
  SetElementAttribute(GadgetElement, #PB_ScrollArea_InnerHeight, (iY+iHeight)+z)
  SetElementAttribute(ScrollHeightElement, #PB_ScrollBar_PageLength, ElementHeight)
  
;   SetElementFont(FirstElement, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
;   SetElementFont(GadgetItem, FontID(LoadFont(#PB_Any, "Anonymous Pro Minus", 19*0.5, #PB_Font_HighQuality)))
  
  ProcedureReturn GadgetItem
EndProcedure

Procedure PropertiesElement( Element, X,Y,Width,Height, Flag.q = #_Flag_Double, Parent =- 1, SplitterPos = 80 )
  Protected ScrollBarSize = 17 , Type, iWidth = Width-ScrollBarSize, iHeight = Height 
  Protected ScrollAreaElement, ScrollHeightElement, ScrollWidthElement
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  Protected ScrollStep
  
  Flag = SetPropertiesElementFlag(Flag)
  
  ; Border type then draw
  If ((Flag & #_Flag_Flat) = #_Flag_Flat)
    dbs+2
  EndIf
  If (((Flag & #_Flag_Double) = #_Flag_Double) Or
      ((Flag & #_Flag_Raised) = #_Flag_Raised))
    dbs+4
  EndIf
  If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
    dbs+8
  EndIf
  
  Element = CreateElement( #_Type_ScrollArea, Element, X,Y,Width,Height,"", -1, -1, -1, Flag)
  BindGadgetElementEvent(Element, @PropertiesScrollEvent(), #_Event_Size)
  
  
  
  ScrollAreaElement = SplitterElement(#PB_Any,0,0,Width-ScrollBarSize,0, #PB_Any,#PB_Any, #_Flag_Vertical|#_Flag_Separator|#_Flag_FirstFixed)
  Protected Info = ListViewElement(#PB_Any,0,0,100,100,"", #_Flag_Transparent|#_Flag_BorderLess)
  Protected Container = ContainerElement(#PB_Any,0,0,0,0, #_Flag_Transparent|#_Flag_BorderLess) : CloseElementList() ;
  ;Container = ButtonElement(#PB_Any,0,0,0,0,"ButtonElement")
  
  ;SetElementAttribute(ScrollAreaElement, #PB_Gadget_BackColor, $7198F8)
  SetElementAttribute(ScrollAreaElement, #PB_Splitter_FirstGadget, Info)
  SetElementAttribute(ScrollAreaElement, #PB_Splitter_SecondGadget, Container)
;   Protected Info = ListViewElement(#PB_Any,0,0,100,100,"", #_Flag_Transparent|#_Flag_BorderLess)
;   Protected Container; = ContainerElement(#PB_Any,0,0,0,0, #_Flag_Transparent|#_Flag_BorderLess) : CloseElementList() ;
;   
;   
;   Container = ButtonElement(#PB_Any,0,0,0,0,"ButtonElement")
;   ScrollAreaElement = SplitterElement(#PB_Any,0,0,Width-ScrollBarSize*2,130, Info,Container, #_Flag_Vertical|#_Flag_Separator|#_Flag_FirstFixed)
;   ;SetElementAttribute(ScrollAreaElement, #PB_Gadget_BackColor, $7198F8)
  
  ScrollHeightElement = ScrollBarElement(#PB_Any, iWidth-dbs,0,ScrollBarSize,iHeight-dbs/2, 0,0,Height, #_Flag_Vertical|#_Flag_BorderLess);|#_Flag_DockRight)
  SetElementData(ScrollHeightElement, Element)
  BindGadgetElementEvent(ScrollHeightElement, @PropertiesScrollEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  
  BindGadgetElementEvent(Info, @PropertiesInfoEvent(), #_Event_MouseMove);Enter|#_Event_MouseLeave)
  
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Type = \This()\Type
    
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\Vert = ScrollHeightElement
    
    PushListPosition(\This())
;     ChangeCurrentElement(\This(), ElementID(Container))
;     \This()\Scroll\Element = ScrollAreaElement
;     \This()\Scroll\Vert = ScrollHeightElement
    
    ChangeCurrentElement(\This(), ElementID(ScrollAreaElement))
    \This()\Scroll\Element = Container
    \This()\Scroll\Vert = ScrollHeightElement
    
    
    ChangeCurrentElement(\This(), ElementID(ScrollHeightElement))
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\ScrollStep = ScrollStep
    
    \This()\Hide = 1
    
    PopListPosition(\This())
    
    PopListPosition(\This())         
    
  EndWith
  
  CloseElementList()
  
;   SetElementAttribute(Element, #PB_ScrollArea_InnerWidth, Width)
;   SetElementAttribute(Element, #PB_ScrollArea_InnerHeight, Height)
;   SetElementAttribute(ScrollHeightElement,#PB_ScrollBar_Maximum, Height)
;   SetElementAttribute(ScrollHeightElement,#PB_ScrollBar_PageLength,Height) ;: SetElementState(10, 0) 
  
  SetElementState(ScrollAreaElement, SplitterPos)
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  Define i
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  Time = ElapsedMilliseconds()
  
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  OpenWindowElement(1, 20,10,400+8,490+8, "BorderLess", #_Flag_SizeGadget|#_Flag_MoveGadget|#_Flag_BorderLess) ; |#PB_Window_MoveGadget
                                                                                                               ;SetWindowElementColor(1, $8C9C65)
  
  Procedure PropertiesElementEvent(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_LeftClick
        
      Case #_Event_Up
        Debug Str(EventElement())+" - up"
        
      Case #_Event_Down
        Debug Str(EventElement())+" - down"
        
      Case #_Event_Change
        ;Debug Str(EventElementItem())+" - item change"
        ;Debug Str(GetElementAttribute(EventElement, #PB_ScrollArea_X))+" - scroll element change"
        ;SetGadgetAttribute(10, #PB_ScrollArea_X, GetElementState(EventElementItem()))
        
        
    EndSelect
    ;Debug GetElementState(EventElementItem())
    
  EndProcedure
  
  ;Define e=ButtonElement  (11, 10,10,272+dbs,162+dbs,"Button 1",#_Flag_MoveGadget|#_Flag_SizeGadget)
  
  If dbs
     Define.q Flag = #_Flag_SizeGadget|#_Flag_Anchors
  EndIf
  
  Define e=PropertiesElement(10,10-dbs/2,10-dbs/2,280+dbs,150+dbs, Flag|#PB_ScrollArea_Flat);|#_Flag_MoveGadget)
  AddPropertiesElementItem(e, -1, "ComboBox Elements")
  AddPropertiesElementItem(e, -1, "String Text Element")
  AddPropertiesElementItem(e, -1, "StringButton Puch")
  AddPropertiesElementItem(e, -1, "Spin X 0|100")
  AddPropertiesElementItem(e, -1, "Splitter ")
  AddPropertiesElementItem(e, -1, "Spin Y 0|200")
  AddPropertiesElementItem(e, -1, "Spin Width 0|100")
  AddPropertiesElementItem(e, -1, "Spin Height 0|200")
  
  AddPropertiesElementItem(e, -1, "-Поведение-")
  
  AddPropertiesElementItem(e, -1, "Button Puch C:\as\Img\Image.png")
  AddPropertiesElementItem(e, -1, "ComboBox Disable True|False")
  AddPropertiesElementItem(e, -1, "ComboBox Flag #_Event_Close|#_Event_Size|#_Event_Move",-1, #PB_ListIcon_CheckBoxes)
  
;   Define e32 = ButtonElement(#PB_Any, 10,70,163,25, "32ButtonElement")
;   Define e3 = SplitterElement(#PB_Any, 10,10,280+dbs,355, e,e32, #_Flag_Separator|Flag)
  
  
  ButtonElement(#PB_Any, 210, 30, 130, 12,"demo close list"+Str(i))
  
  
  
  Global e5,e6,e7
  Procedure Properties_Size_Events(Event.q, EventElement)
    Protected State 
    Protected iWidth = ElementWidth(EventElement)
    Protected iHeight = ElementHeight(EventElement)
    Protected Element = GetElementItemData(EventElement, GetElementState(EventElement))
    
    If Element
      Select Event 
        Case #_Event_Change, #_Event_Size
          ResizeElement(Element, #PB_Ignore, #PB_Ignore, iWidth, iHeight)
          
;           State = GetElementState(Element)
;           If State = 0
;             SetElementState(Element, iHeight/2)
;           Else
;             SetElementState(Element, State+6/2)
;           EndIf
      EndSelect
    EndIf
    
    ProcedureReturn #True
  EndProcedure
  ;Define e4 = ContainerElement(#PB_Any,30,180,280,150, #_Flag_Transparent) 
  Define e4 = PanelElement(#PB_Any,30,220,280,150, #_Flag_Transparent) 
  ;
  Define ei=AddPanelElementItem(e4, #PB_Any, "Elements", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e51=PropertiesElement(#PB_Any, 0,0,0,0, #_Flag_Flat)
  AddPropertiesElementItem(e51, -1, "Splitter ")
  For i=0 To 10
    AddPropertiesElementItem(e51, -1, "Spin "+Str(i))
  Next
  Define e52 = ButtonElement(#PB_Any, 0,0,0,0, "52ButtonElement")
  e5 = SplitterElement(#PB_Any, 0,0,0,0, e51,e52, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e5)
  
  Define ei=AddPanelElementItem(e4, #PB_Any, "Properties", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e61=PropertiesElement(#PB_Any, 0,0,0,0, #_Flag_Flat)
  For i=0 To 10
    AddPropertiesElementItem(e61, -1, "Spin "+Str(i))
  Next
  
  Define e62 = ButtonElement(#PB_Any, 0,0,0,0, "62ButtonElement")
  e6 = SplitterElement(#PB_Any, 0,0,0,0, e61,e62, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e6)
  
  Define ei=AddPanelElementItem(e4, #PB_Any, "Events", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  Define e71 = ButtonElement(#PB_Any, 0,0,0,0, "71ButtonElement")
  Define e72 = ButtonElement(#PB_Any, 0,0,0,0, "72ButtonElement")
  e7 = SplitterElement(#PB_Any, 0,0,0,0, e71,e72, #_Flag_Separator_Circle);|#_Flag_AlignFull)
  
  SetElementItemData(e4, ei, e7)
  
  BindGadgetElementEvent(e4, @Properties_Size_Events(), #_Event_Size|#_Event_Change);|#_Event_Create)
  CloseElementList()
  
;   Debug ElementWidth(e5) ; 278
;   Debug ElementHeight(e5) ; 123
  
;   SetElementState(e4,1)
;   SetElementState(e4,0)
  

;    SetElementState(e5,130-40)
;    SetElementState(e6,130-40)
;    SetElementState(e7,130-40)
   
   SetElementState(e5,ElementHeight(GetElementParent(e5))-40)
   SetElementState(e6,ElementHeight(GetElementParent(e6))-40)
   SetElementState(e7,ElementHeight(GetElementParent(e7))-40)
  
;   SetElementAttribute(e, #PB_ScrollArea_Y, 15)
;   SetElementAttribute(e, #PB_ScrollArea_InnerWidth, 235)
  
;   With *CreateElement
;     PushListPosition(\This())
;     ChangeCurrentElement(\This(), ElementID(e))
;     SetElementState(\This()\Scroll\Element, 50)
;     PopListPosition(\This())
;   EndWith

  BindEventElement(@PropertiesElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  
  WaitWindowEventClose(Window)
CompilerEndIf



