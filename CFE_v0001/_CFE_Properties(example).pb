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

Global dbs = 0

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


;- PRIVATE
Procedure PropertiesScrollEvent(Event.q, EventElement)
  Protected IsVertical, Bs, Vb,Hb,X,Y,Width, Height, ElementWidth, ElementHeight
  
  Select ElementEvent()
    Case #_Event_Size
      With *CreateElement\This()
        Bs = \bSize*2
        X=\InnerCoordinate\X
        Y=\InnerCoordinate\Y
        Width=\InnerCoordinate\Width
        Height=\InnerCoordinate\Height
        
        PushListPosition(*CreateElement\This())
        If IsElement(\Scroll\Element)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Scroll\Element))
          ElementHeight = \FrameCoordinate\Height
          ElementWidth = \FrameCoordinate\Width
          
          If ElementWidth<Width : Hb = 0 : Else : Hb = 17 : EndIf
          If ElementHeight<Height : Vb = 0 : Else : Vb = 17 : EndIf
        EndIf
        
        If IsElement(\Parent\Element)
          ChangeCurrentElement(*CreateElement\This(), ElementID(\Parent\Element))
          \FrameCoordinate\Height = Height-Hb
          \FrameCoordinate\Width = Width-Vb
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
          \FrameCoordinate\X = (X+Width-\FrameCoordinate\Width)
          ResizeElementX(*CreateElement\This(), \FrameCoordinate\X)
          \FrameCoordinate\Height = (Height-Hb)
          ResizeElementY(*CreateElement\This())
          
          SetScrollBarElementAttribute(*CreateElement\This(), #PB_ScrollBar_PageLength, Height+Bs)
          If Vb
            \Hide=0
          Else
            \Hide=1
          EndIf
        EndIf
        
        
        
        PopListPosition(*CreateElement\This())    
        
        ;ResizeElement(ScrollAreaElement, X,Y,Width,Height)
      EndWith
      
    Case #_Event_Up, #_Event_Down
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
  Debug 666666666
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
      ;Debug X
      ResizeElement(\Linked\Element, X,Y,Width,Height)
    EndIf
  EndWith
  
EndProcedure

Procedure SetPropertiesComboBoxText(Element, Text$)
  Protected II, Includes.S=Text$, Include.S
  
  ClearElementItems(Element)
  
  For II = (1) To CountString( Includes.S, "|" ) + (1)
    Include.S = Trim( StringField( Includes.S, II, "|" ))
    If Include.S 
      AddGadgetElementItem(Element, II-1, Include.S)
    EndIf
  Next
  
EndProcedure

Procedure AddPropertiesElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag = 0)
  Static Count 
  Protected ScrollAreaElement, OpenElementList, X, Y, Width, Height, Title$, Text1$
  Protected iX=70, iWidth, iHeight=19, z=1, iY=z
  
  With *CreateElement
    If IsElement(GadgetElement)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(GadgetElement))
      ScrollAreaElement=\This()\Scroll\Element
      
      ChangeCurrentElement(\This(), ElementID(ScrollAreaElement))
      
      \This()\Splitter\Size = 4
      \This()\Splitter\Pos = 70 ;TextWidth(\This()\Items()\Title);\This()\Item\Width-\This()\InnerCoordinate\Width
      
      X = \This()\FrameCoordinate\X 
      Y = \This()\FrameCoordinate\Y 
      Width = \This()\FrameCoordinate\Width 
      Height = \This()\FrameCoordinate\Height 
      
      
      
      Text1$ = Trim(StringField(Text$, 2, " "))
      Title$ = Trim(StringField(Text1$, 1, ":"))+":"
      Text1$ = Trim(StringField(Text1$, 2, ":"))
      
      If Text1$ = ""
        Text1$ = " "
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  
  OpenElementList = OpenElementList(ScrollAreaElement)
  
  
  If Count
    iY = ((CountElement(GadgetElement)/2)*(iHeight+1))+z
  EndIf
  
  TextElement(#PB_Any,0,iY,iX,iHeight,Title$, #_Flag_Text_Right) 
  
  Select Trim(StringField(Text$, 1, " "))
    Case "Button"   : GadgetItem = ButtonElement(GadgetItem,iX,iY,Width-iX,iHeight,Text1$)
    Case "String"   : GadgetItem = StringElement(GadgetItem,iX,iY,Width-iX,iHeight,Text1$)
    Case "Spin"     : GadgetItem = SpinElement(GadgetItem,iX,iY,Width-iX,iHeight,-1000,1000, #_Flag_Numeric);|#_Flag_AlignRight)
    Case "ComboBox" : GadgetItem = ComboBoxElement(GadgetItem,iX,iY,Width-iX,iHeight)
      
      Protected II, Includes.S=Text1$, Include.S
      
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
      
    Default
      
  EndSelect
  
  Count+1
  
  CloseElementList()
  
  OpenElementList(OpenElementList)
  
  SetElementAttribute(GadgetElement, #PB_ScrollArea_InnerHeight, (iY+iHeight)+z)
  ProcedureReturn GadgetItem
EndProcedure

Procedure PropertiesElement( Element, X,Y,Width,Height, Flag.q = #_Flag_Double, Parent =- 1 )
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
  
  
  
  Protected Container = ContainerElement(#PB_Any,0,0,iWidth-dbs,iHeight-dbs, #_Flag_BorderLess) 
  ScrollAreaElement = ContainerElement(#PB_Any,0,0,iWidth-dbs,iHeight-dbs, #_Flag_BorderLess) : CloseElementList() 
  CloseElementList()
  
  ScrollHeightElement = ScrollBarElement(#PB_Any, iWidth-dbs,0,ScrollBarSize,iHeight-dbs, 0, Height+dbs, Height,#_Flag_Vertical|#_Flag_BorderLess);|#_Flag_DockRight)
  SetElementData(ScrollHeightElement, Element)
  BindGadgetElementEvent(ScrollHeightElement, @PropertiesScrollEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Type = \This()\Type
    
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\Vert = ScrollHeightElement
    
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Container))
    \This()\Scroll\Element = ScrollAreaElement
    \This()\Scroll\Vert = ScrollHeightElement
    
    ChangeCurrentElement(\This(), ElementID(ScrollAreaElement))
    \This()\Scroll\Element = Element
    \This()\Scroll\Vert = ScrollHeightElement
    
    
    ChangeCurrentElement(\This(), ElementID(ScrollHeightElement))
    \This()\Scroll\Element = Container
    \This()\Scroll\ScrollStep = ScrollStep
    
    \This()\Hide = 1
    
    PopListPosition(\This())
    
    PopListPosition(\This())         
    
  EndWith
  
  CloseElementList()
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  Time = ElapsedMilliseconds()
  
  Define  h = GetElementAttribute(Window, #_Element_CaptionHeight)
  
  OpenWindowElement(1, 20,10,400+8,490+8, "BorderLess", #_Flag_SizeGadget|#_Flag_MoveGadget|#_Flag_BorderLess) ; |#PB_Window_MoveGadget
                                                                                                               ;SetWindowElementColor(1, $8C9C65)
  
  Procedure PropertiesElementEvent(Event.q, EventElement)
    Select ElementEvent()
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
        
        
    EndSelect
    ;Debug GetElementState(EventElementItem())
    
  EndProcedure
  
  ;Define e=ButtonElement  (11, 10,10,272+dbs,162+dbs,"Button 1",#_Flag_MoveGadget|#_Flag_SizeGadget)
  
  If dbs
    Define Flag = #_Flag_SizeGadget
  EndIf
  
  Define e=PropertiesElement(10,10-dbs/2,10-dbs/2,280+dbs,150+dbs, Flag|#PB_ScrollArea_Flat);|#_Flag_MoveGadget)
  
  ;   Define Button = ButtonElement(#PB_Any,10,1,170,20,"Button")      ;,#_Flag_AlignFull)
  ;   Button = ButtonElement(#PB_Any,10,CountElement(e)*21+1,170,20,"Button");,#_Flag_AlignFull)
  ;   Button = ButtonElement(#PB_Any,10,CountElement(e)*21+1,170,20,"Button");,#_Flag_AlignFull)
  ;   Button = ButtonElement(#PB_Any,10,CountElement(e)*21+1,170,20,"Button");,#_Flag_AlignFull)
  ;   Button = ButtonElement(#PB_Any,10,CountElement(e)*21+1,170,20,"Button");,#_Flag_AlignFull)
  ;   Define Button
  ;   For i=10 To 20
  ;     Button = AddPropertiesElementItem(e, -1, "Button_"+Str(i))
  ;   Next
  
  
  AddPropertiesElementItem(e, -1, "ComboBox Elements:")
  AddPropertiesElementItem(e, -1, "String Text$:Element")
  AddPropertiesElementItem(e, -1, "Spin X:0|100")
  AddPropertiesElementItem(e, -1, "Spin Y:0|200")
  AddPropertiesElementItem(e, -1, "Spin Width:0|100")
  AddPropertiesElementItem(e, -1, "Spin Height:0|200")
  
  AddPropertiesElementItem(e, -1, "-Поведение-")
  AddPropertiesElementItem(e, -1, "Button Puch:C:\as\Img\Image.png")
  AddPropertiesElementItem(e, -1, "ComboBox Disable:True|False")
  AddPropertiesElementItem(e, -1, "ComboBox Flag:#_Event_Close|#_Event_Size|#_Event_Move")
  
  ButtonElement  (315, 180, 30, 130, 10,"Button 3"+Str(i))
  ;   CloseElementList()
  ;   CloseElementList()
  
  ;   SetElementAttribute(10, #PB_ScrollArea_X, 100)
  ;   SetElementAttribute(10, #PB_ScrollArea_Y, 100)
  
   SetElementAttribute(e, #PB_ScrollArea_Y, 15)
  ;SetElementAttribute(e, #PB_ScrollArea_InnerWidth, 135)
  
  
  BindEventElement(@PropertiesElementEvent(), #_Event_Change|#_Event_Up|#_Event_Down)
  
  Time = (ElapsedMilliseconds() - Time)
  If Time 
    Debug "Time "+Str(Time)
  EndIf
  WaitWindowEventClose(Window)
CompilerEndIf



