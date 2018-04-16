CompilerIf #PB_Compiler_IsMainFile
;   ; Menu functions
;   Declare MenuElement()
;   Declare MenuElementToolTip(MenuElement, ButtonID, Text$)
;   Declare MenuElementButtonText(MenuElement, ButtonID, Text$)
;   Declare CreateMenuElement(MenuElement = #PB_Any, Parent = #PB_Any, Flag = 0)
;   Declare MenuElementImageButton(ButtonID, Image, Mode = #PB_Menu_Normal, Text$ = "")
;   Declare MenuElementItem(ButtonID, ButtonIcon, Mode = #PB_Menu_Normal, Text$ = "")
;   Declare DisableMenuElementButton(MenuElement, ButtonID, State.b)
;   Declare SetMenuElementItemState(MenuElement, ButtonID, State.b)
;   Declare GetMenuElementItemState(MenuElement, ButtonID)
;   Declare MenuElementHeight(MenuElement)
;   Declare FreeMenuElement(MenuElement)
;   Declare MenuElementID(MenuElement)
;   Declare MenuElementBar()
  
  Declare EventElement()
  Declare EventElementItem()
  
  Declare EventMenuElement()
  Declare BindMenuElementEvent(MenuElement, MenuItem, *CallBack) 
  Declare UnbindMenuElementEvent(MenuElement, MenuItem, *CallBack) 
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ - MenuElement
;-
Procedure DrawPopupMenuElementItemsContent(List This.S_CREATE_ELEMENT(), ItemElement, iX,iY)
  Protected iWidth, iHeight, ImageContentWidth = *CreateElement\MenuHeight
  
  ; Draw on element
  With This()
    iWidth = \InnerCoordinate\Width
    iHeight = \InnerCoordinate\Height
    
    If (\Item\Type <> #_Type_ComboBox)
      DrawingMode(#PB_2DDrawing_Default) 
      Box(iX+1,iY+1,ImageContentWidth,iHeight-2,$ECECEC)
      Line(iX+ImageContentWidth,iY+1,1,iHeight-2,\FrameColor)
      Line(iX+ImageContentWidth+1,iY+1,1,iHeight-2,$FFFFFF)
    EndIf 
    
;     If ((\Flag&#_Flag_CheckBoxes)=#_Flag_CheckBoxes)
;       iHeight = \Items()\FrameCoordinate\Height
;       ;If ((\Flag & #_Flag_Border) = #_Flag_Border)
;       Protected i = 5
;       ;EndIf
;       DrawingMode(#PB_2DDrawing_Outlined) 
;       If (\Radius > 0)
;         RoundBox(iX+i, (iY+\Items()\FrameCoordinate\Y)+(iHeight-13)/2, 13, 13, \Radius, \Radius, 0)
;       Else
;         Box(iX+i, (iY+\Items()\FrameCoordinate\Y)+(iHeight-13)/2, 13, 13, 0)
;       EndIf
;       
;       If \Items()\Checked
;         DrawingMode(#PB_2DDrawing_Default) 
;         Protected xx = iX+i, yy = (iY+\Items()\FrameCoordinate\Y)+(iHeight-10)/2, inColor = \FrameColor
;         Line(xx+2,Yy+4,4,4,0)
;         Line(xx+2,Yy+4+1,3,3,0)
;         
;         Line(xx+5,Yy+6,6,-6,0)
;         Line(xx+5,Yy+6+1,6,-6,0)
;       ElseIf \Items()\Inbetween
;         DrawingMode(#PB_2DDrawing_Default) 
;         Box(iX+3+i,(iY+\Items()\FrameCoordinate\Y)+(iHeight-7)/2,7,7, 0)
;       EndIf  
; 
; ;       \Items()\FrameCoordinate\X = \Column\X+13+4+1
; ;       \Item\X = \Items()\FrameCoordinate\X
;     EndIf
;         
;         
EndWith
  
  ; Draw on element items
  With This()\Items()
    PushListPosition(This()\Items())
    ForEach This()\Items()
      \FrameCoordinate\Width = iWidth - \FrameCoordinate\X*2
      
      
      If \Item\IsBar
        DrawingMode(#PB_2DDrawing_Default)
        Line((iX+\FrameCoordinate\X)+ImageContentWidth+1,(iY+\FrameCoordinate\Y)+(\FrameCoordinate\Height/2),\FrameCoordinate\Width-ImageContentWidth-1,1, \FrameColor)
      Else
        If (\Disable = 0 And \Element = ItemElement)
          DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
          Box((iX+\FrameCoordinate\X)+1, (iY+\FrameCoordinate\Y)+1, \FrameCoordinate\Width-2, \FrameCoordinate\Height-2, \EnteredBackColor | $80000000) ;\EnteredBackColor&$FFFFFF|$80<<24)
          
          DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
          Box((iX+\FrameCoordinate\X), (iY+\FrameCoordinate\Y), \FrameCoordinate\Width, \FrameCoordinate\Height, $DD8C26&$FFFFFF|$80<<24)
        EndIf
      EndIf
      
      If IsImage(\Img\Image1)
        DrawingMode(#PB_2DDrawing_AlphaBlend) 
        DrawAlphaImage(ImageID(\Img\Image1), iX+1+(ImageContentWidth-ImageWidth(\Img\Image1))/2,iY+\FrameCoordinate\Y+1+(\FrameCoordinate\Height-ImageHeight(\Img\Image1))/2)
      EndIf
     
      
     ; Clip draw area element items
;       ClipCoordinate(This()\Items(), iX,iY+\FrameCoordinate\Y,iWidth,iHeight)
      
;       DrawingMode(#PB_2DDrawing_Transparent)
;       DrawText((iX+\FrameCoordinate\X)+ImageContentWidth+5, (iY+\FrameCoordinate\Y)+(\FrameCoordinate\Height-TextHeight("A"))/2, \Text\String$, \FontColor)
      DrawContent(This()\Items(), iX, iY)
    Next
    PopListPosition(This()\Items())
    
  EndWith
  
EndProcedure

Macro MenuElement() : *CreateElement\CreateMenuElement : EndMacro
Macro PopupMenuElement() : *CreateElement\CreatePopupMenuElement : EndMacro

Procedure AddMenuElementItem(MenuElement, MenuItem, Text$, Image =- 1, Flag.q = 0)
  Protected Result
  
;   If IsMenuElement(MenuElement)
;     Flag | #_Flag_Image_Center|#_Flag_Text_Center|#_Flag_Image_Left|#_Flag_Text_Right
;   ElseIf IsPopupMenuElement(MenuElement)
;     Flag |#_Flag_Text_HCenter|#_Flag_Text_Left 
;   EndIf
  
  If MenuItem =- 1 : Result = 1 : EndIf ; Чтобы нулевой итем работал правильно
  Result + AddElementItem(MenuElement, MenuItem, Text$, Image, Flag)
  
  ProcedureReturn Result
EndProcedure

Procedure CreatePopupMenuElement(MenuElement = #PB_Any)
  Protected OpenElementList = OpenElementList(0)
  
  With *CreateElement
    
    MenuElement = CreateElement(#_Type_PopupMenu, MenuElement,0,0,0,0, "",-1,-1,-1, #_Flag_CheckBoxes)
    StickyElement(MenuElement, #True) 
    
    If \Sticky =- 1 : \Sticky = MenuElement : EndIf
    
    CloseElementList()
  EndWith
  
  OpenElementList(OpenElementList)
  
  ProcedureReturn MenuElement
EndProcedure

Procedure CreateMenuElement(MenuElement = #PB_Any, Parent = #PB_Any, Flag.q = 0)
  Protected Height = 22, PrevParent =- 1
  
  With *CreateElement
    If IsElement(Parent) 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Parent))
      If \This()\MenuHeight
        \CreateMenuElement =- 1
        ProcedureReturn 
      EndIf
      PopListPosition(\This())
      
      PrevParent = OpenElementList(Parent) 
      
      PushListPosition(\This())
      ForEach \This()
        If (\This()\Parent\Element = Parent)
          If IsGadgetElement(\This()\Element) 
            ResizeElement(\This()\Element, #PB_Ignore, \This()\FrameCoordinate\Y + Height, #PB_Ignore, #PB_Ignore, #_Element_ScreenCoordinate)
          EndIf
        Else
          If Parent = \This()\Element And \This()\Type = #_Type_Window
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, \This()\FrameCoordinate\Height + Height, 0)
            
            If ((\This()\FrameCoordinate\Height + Height)>ElementHeight(\This()\Parent\Element))
              ResizeElement(\This()\Parent\Element,#PB_Ignore,#PB_Ignore,#PB_Ignore,(Height+\This()\FrameCoordinate\Height+\This()\bSize*2), 0)
            EndIf
          EndIf
        EndIf
      Next
      PopListPosition(\This())
    EndIf
    
    MenuElement = CreateElement(#_Type_Menu, MenuElement,0,-1,Height,Height, "",#PB_Default,#PB_Default,#PB_Default, #_Flag_BorderLess|#_Flag_Image_Center|#_Flag_Text_Center|#_Flag_Image_Left|#_Flag_Text_Right)
      
    ; Bug
    ; If IsElement(Parent) : SetElementParent(MenuElement, Parent) : EndIf
    
    If IsElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      \This()\Item\Parent = MenuElement
      PopListPosition(\This())
    EndIf
    
    If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  EndWith
  ProcedureReturn MenuElement
EndProcedure

Procedure DisplayPopupMenuElement(MenuElement, Parent = #PB_Any, X = #PB_Ignore, Y = #PB_Ignore)
  Protected Y1, Height, *MenuElement = ElementID(MenuElement), Result : If Parent =- 1 : Parent = 0 : EndIf
  
  With *CreateElement
    If *MenuElement
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), *MenuElement)
      
      If (\This()\Type = #_Type_ListIcon)
        MoveElement(\This(), #PB_List_Last)
      EndIf
      
      ;If (\This()\Type = #_Type_PopupMenu) Or (\This()\Type = #_Type_ListIcon) Or (\This()\Type = #_Type_ListView)
        ; Задумано если вызвали не на родителе то выходим
        If \This()\Item\Parent <> Parent
          ;\This()\Item\Type = ElementType(Parent)
          ;  ProcedureReturn 0
        EndIf
        
        \Popup = #True
        \PopupElement = MenuElement
        \This()\Linked\Parent = Parent
        
        If \This()\Hide
          
          If X = #PB_Ignore : X = \MouseX : EndIf
          If Y = #PB_Ignore : Y = \MouseY : EndIf
          
          ;
          If ListSize(\This()\Items())
            FirstElement(\This()\Items())
            Height=1
            ForEach \This()\Items() 
              \This()\Items()\FrameCoordinate\X=1
              \This()\Items()\FrameCoordinate\Y=Height
              
              Height + \This()\Items()\FrameCoordinate\Height 
            Next
            
            Height+3
          EndIf
          
          SetActiveElement(MenuElement)
          ElementItemCallBack(*MenuElement, #_Event_Focus, MenuElement, #PB_Default)
          
          If (Y+Height)>ElementHeight(0)
            ResizeElement(MenuElement, X,Y+1-Height-ElementHeight(Parent),#PB_Ignore,Height, #PB_Ignore)
          Else
            ResizeElement(MenuElement, X,Y+1,#PB_Ignore,Height, #PB_Ignore)
          EndIf
          
          If Parent
            SetActiveElement(Parent)
            SetForegroundWindowElement(Parent)
          Else
            SetElementPosition(MenuElement, #True)
          EndIf
          
          \This()\Hide = #False
        EndIf
      ;EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure MenuElementItem(MenuItem, Text$, Image =- 1)
  Protected ParentType, Result =- 1
  Protected PopupMenuElement =- 1
  Protected MenuElement = MenuElement()
  Protected Flag.q
  
  With *CreateElement
    If IsElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      ParentType = \This()\Type
      Result = \This()\Linked\Element : \This()\Linked\Element  =- 1
      
      If \This()\Item\Type <> #_Type_ComboBox
        If MenuItem =- 1 : MenuItem =- #PB_Ignore : EndIf
      EndIf
      
      If Result > 0
        Protected CreatePopupMenuElement = \CreatePopupMenuElement
        PopupMenuElement = CreatePopupMenuElement()
        \CreatePopupMenuElement = CreatePopupMenuElement
        
        If IsElementItem(Result - 1)
          PushListPosition(\This()\Items())
          ChangeCurrentElement(\This()\Items(), ItemID(Result - 1))
          \This()\Items()\Linked\Element = PopupMenuElement ; for display then
          PopListPosition(\This()\Items())
        EndIf
        
        If IsElement(PopupMenuElement)
          PushListPosition(\This())
          ChangeCurrentElement(\This(), ElementID(PopupMenuElement))
          \This()\Item\Type = ParentType ; 
          \This()\Item\Parent = MenuElement ; 
          PopListPosition(\This())
          
          PushListPosition(\This())
          ChangeCurrentElement(\This(), ElementID(MenuElement))
          \This()\Item\Child = PopupMenuElement ; 
          If IsMenuElement(MenuElement)
            LastElement(\This()\Items())
            \This()\Items()\Item\Child = PopupMenuElement
          EndIf
          PopListPosition(\This())
        EndIf
        
        MenuElement = PopupMenuElement
      EndIf
      PopListPosition(\This())
      
      If IsMenuElement(MenuElement)
        Flag | #_Flag_Image_Center|#_Flag_Text_Center|#_Flag_Image_Left|#_Flag_Text_Right
      ElseIf IsPopupMenuElement(MenuElement)
        Flag |#_Flag_Text_HCenter|#_Flag_Text_Left 
      EndIf
      
      MenuItem = AddMenuElementItem(MenuElement, MenuItem, Text$, Image, Flag)
    EndIf
  EndWith
  
  ProcedureReturn MenuItem
EndProcedure

Procedure OpenSubMenuElement(Text$, Image =- 1)
  Protected Result =- 1
  Protected MenuElement = MenuElement()
  Protected Flag.q
  
  With *CreateElement
    If IsElement(MenuElement)
      
      If IsMenuElement(MenuElement)
        Flag | #_Flag_Image_Center|#_Flag_Text_Center|#_Flag_Image_Left|#_Flag_Text_Right
      ElseIf IsPopupMenuElement(MenuElement)
        Flag |#_Flag_Text_HCenter|#_Flag_Text_Left 
        Text$ + "    >>"
      EndIf
      
      Result = AddMenuElementItem(MenuElement, #PB_Any , Text$, Image, Flag)
      
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      \This()\Items()\Linked\Element =- 1 ; Что бы на зоголовке не было событие
      \This()\Linked\Element = Result     ; Запоминаем зоголовок для вызова подменю
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CloseSubMenuElement()
  Protected MenuElement = MenuElement()
  
  With *CreateElement
    If IsElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      \CreateMenuElement = \This()\Item\Parent
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn MenuElement
EndProcedure

Procedure MenuElementTitle(Title$)
  Protected Result =- 1
  
  CloseSubMenuElement() 
  Result = OpenSubMenuElement(Title$)
  
  ProcedureReturn Result 
EndProcedure


Procedure DisableMenuElementItem(MenuElement, MenuItem, State.b)
  If IsMenuElement(MenuElement)
    If MenuItem = #PB_All
      DisableElement(MenuElement, State)
    Else  
      DisableElementItem(MenuElement, MenuItem, State)
    EndIf
  EndIf
EndProcedure

Procedure HideMenuElement(MenuElement, State.b)
  With *CreateElement
    If IsMenuElement(MenuElement)
      HideElement(MenuElement, State)
    EndIf
    
    PushListPosition(\This())
    ; ResetList(\This())
    ChangeCurrentElement(\This(), ElementID(MenuElement))
    While NextElement(\This())
      Select \This()\Type
        Case #_Type_PopupMenu : \This()\Hide = #True
      EndSelect
    Wend
    PopListPosition(\This())
    
  EndWith
EndProcedure

Procedure FreeMenuElement(MenuElement)
  If IsMenuElement(MenuElement)
    FreeElement(MenuElement)
  EndIf
EndProcedure

Procedure MenuElementID(MenuElement)
  ProcedureReturn ElementID(MenuElement)
EndProcedure

Procedure MenuElementHeight(MenuElement = #PB_Default)
  Protected Result
  
  With *CreateElement
    If MenuElement = #PB_Default 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(\This()\Element))
      ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
      Result = \This()\MenuHeight
      PopListPosition(\This())
      
    Else
      If IsElement(MenuElement)
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(MenuElement))
        
        Select \This()\Type
          Case #_Type_Menu : Result = \This()\FrameCoordinate\Height
          Default : Result = \This()\MenuHeight
        EndSelect
        
        PopListPosition(\This())
      EndIf
    EndIf
  EndWith
    
  ProcedureReturn Result
EndProcedure

Procedure MenuElementBar()
  AddMenuElementItem(MenuElement(), -#PB_Ignore, "")
EndProcedure


Procedure GetMenuElementItemState(MenuElement, MenuItem)
  Protected Result
  
  With *CreateElement
    If IsPopupMenuElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      ChangeCurrentElement(\This()\Items(), ItemID(MenuItem))
      ;Result = \This()\Items()\State
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure$ GetMenuElementItemText(MenuElement, MenuItem)
  Protected Result$
  
  With *CreateElement
    If IsMenuElement(MenuElement) Or IsPopupMenuElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      ChangeCurrentElement(\This()\Items(), ItemID(MenuItem))
      Result$ = \This()\Items()\Text\String$
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure

Procedure$ GetMenuElementTitleText(MenuElement, Index)
  Protected Result$
  
  With *CreateElement
    If IsMenuElement(MenuElement) Or IsPopupMenuElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      ChangeCurrentElement(\This()\Items(), ItemID(Index))
      Result$ = \This()\Items()\Text\String$
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result$
EndProcedure


Procedure SetMenuElementItemState(MenuElement, MenuItem, State.b)
  Protected Result
  
  With *CreateElement
    If IsPopupMenuElement(MenuElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(MenuElement))
      ChangeCurrentElement(\This()\Items(), ItemID(MenuItem))
      ;Result = \This()\MenuHeight
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure SetMenuElementItemText(MenuElement, MenuItem, Text$)
  Protected X,Y, TextWidth, TextHeight
  
  If Text$
    With *CreateElement
      If IsMenuElement(MenuElement) Or IsPopupMenuElement(MenuElement)
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(MenuElement))
        
        If IsElementItem(MenuItem)
          PushListPosition(\This()\Items()) 
          ChangeCurrentElement(\This()\Items(), ItemID(MenuItem))
          
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID
              DrawingFont(\This()\FontID)
            Else
              DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
            EndIf
            
            TextWidth = (TextWidth(Text$) - TextWidth(\This()\Items()\Text\String$))          
            TextHeight = (TextHeight(Text$) - TextHeight(\This()\Items()\Text\String$))         
            StopDrawing()
          EndIf
          
          \This()\Items()\Text\String$ = Text$
          
          X = (\This()\Items()\FrameCoordinate\X+
               \This()\Items()\FrameCoordinate\Width)
          
          Y = (\This()\Items()\FrameCoordinate\Y+
               \This()\Items()\FrameCoordinate\Height)
          
          \This()\Items()\FrameCoordinate\Width + TextWidth
          \This()\Items()\FrameCoordinate\Height + TextHeight
          
          PushListPosition(\This()\Items()) 
          While NextElement(\This()\Items())
            If (\This()\Items()\FrameCoordinate\X > =  X)
              \This()\Items()\FrameCoordinate\X + TextWidth
            EndIf
            
            If (\This()\Items()\FrameCoordinate\Y > =  Y)
              \This()\Items()\FrameCoordinate\Y + TextHeight
            EndIf
          Wend
          PopListPosition(\This()\Items()) 
          PopListPosition(\This()\Items()) 
        EndIf
        
        ;
        ResizeElement(\This()\Element, 
                      \This()\FrameCoordinate\X,
                      \This()\FrameCoordinate\Y,
                      \This()\FrameCoordinate\Width + TextWidth,
                      \This()\FrameCoordinate\Height, #PB_Ignore)
        
        PopListPosition(\This())
      EndIf
    EndWith
  EndIf
  
EndProcedure

Procedure SetMenuElementTitleText(MenuElement, Index, Text$)
  If IsMenuElement(MenuElement)
    SetMenuElementItemText(MenuElement, Index, Text$)
  EndIf
EndProcedure


Procedure GetMenuPopupElement(Title$)
  Protected Result =- 1
  
  With *CreateElement
    If Title$
      PushListPosition(\This())
      ForEach \This()
        Select \This()\Type
          Case #_Type_Menu, #_Type_PopupMenu
            ForEach \This()\Items()
              If \This()\Items()\Text\String$ = Title$
                Result = \This()\Items()\Linked\Element
               If Result 
                 Break 2
               EndIf
              EndIf
            Next
        EndSelect
      Next
      PopListPosition(\This())
    EndIf
  EndWith
        
  If Result = 0 : Result =- 1 : EndIf
  ProcedureReturn Result
EndProcedure

Procedure GetParentMenuElement(MenuElement)
      
  With *CreateElement
    If IsMenuElement(MenuElement) Or IsPopupMenuElement(MenuElement) Or IsToolBarElement(MenuElement)
      Protected Parent  =  MenuElement
  
      While Parent ; Get parent menu
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(Parent))
        If Parent = \This()\Item\Parent : Break : EndIf
        Parent = \This()\Item\Parent
        PushListPosition(\This())
      Wend
      
      If Not Parent
        Parent  =  MenuElement 
      EndIf
    EndIf
  EndWith
  
  ProcedureReturn Parent
EndProcedure

Procedure BindMenuElementEvent(MenuElement, MenuItem, *CallBack) 
  Protected *Parent, Parent 
  
  With *CreateElement
    If *CallBack
      PushListPosition(\This())
      Parent = GetParentMenuElement(MenuElement)
      
      If Parent
        
        While Parent ; Get parent child menu
          PushListPosition(\This())
          ChangeCurrentElement(\This(), ElementID(Parent))
          *Parent = @\This()
          
          ForEach \This()\Items()
            If Parent 
              PushListPosition(\This())
              ChangeCurrentElement(\This(), ElementID(Parent))
              ; Debug \This()\Items()\Linked\Element
          
               Select \This()\Type
                  Case #_Type_Menu, #_Type_PopupMenu, #_Type_Toolbar
                    \This()\Bind\Window = \This()\Window
                    
                    Debug "Menu "+\This()\Element
                    
                    \This()\Bind\Element = \This()\Element
                    \This()\Bind\Event = \This()\Event|#_Event_Menu
                    \This()\Bind\Item = MenuItem
                    
                    AddElement(\This()\Bind\CallBack()) 
                    \This()\Bind\CallBack() = *CallBack
                EndSelect
              PushListPosition(\This())
            EndIf
            
            ; Get child menu element
            ChangeCurrentElement(\This(), *Parent)
            Parent = \This()\Items()\Item\Child
          Next
        
          Parent = \This()\Item\Child
          PushListPosition(\This())
        Wend
        
      EndIf
      PopListPosition(\This())  
    EndIf
  EndWith
  
EndProcedure

Procedure UnbindMenuElementEvent(MenuElement, MenuItem, *CallBack) 
  ; BindMenuElementEvent(*CallBack, MenuElement = #PB_All, Event.q = #PB_All)
  
  If IsMenuElement(MenuElement)
    ; BindEventElement(*CallBack, #PB_Ignore, MenuElement, Event)
  EndIf
  
EndProcedure
;}


;-
; Menu element bind event example
CompilerIf #PB_Compiler_IsMainFile
  Procedure MenuItemEvent(Event.q, EventElement)
    Debug "Event element ID: "+EventElement()
    Debug "Event element Item ID: "+EventElementItem()
  EndProcedure
  
  Procedure ElementsCallBack(Event.q, EventElement)
    Select ElementEvent()
      Case #_Event_RightClick
        DisplayPopupMenuElement(PopupMenuElement())
        ; DisplayPopupMenuElement(GetMenuPopupElement("File"))
        
    EndSelect
  EndProcedure
CompilerEndIf


;-
; Menu element example
CompilerIf #PB_Compiler_IsMainFile
  Define d = OpenWindowElement(#PB_Any, 0,0, 600,400) 
  Define w = OpenWindowElement(10, 10,120, 300,160, "Demo MenuElement()", #_Flag_SystemMenu) 
  If CreateToolBarElement(22, w);, #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    ToolBarElementStandardButton(1, -1, 0, "Open" )
    ToolBarElementStandardButton(2, -1, 0, "Close" )
    ToolBarElementSeparator()
    
    

  EndIf
  
  ; good
  Define e = ContainerElement(11, 10,10,280,140) : CloseElementList()
  ButtonElement(#PB_Any, 10,10,100,30,"Button",0,e)
  Define i,eCombo=ComboBoxElement(#PB_Any, 120,85,140,23, #_Flag_CheckBoxes,e)
  For i=0 To 15
    AddGadgetElementItem(eCombo, i,Str(i)+"_item_long_very_long")
  Next
  
  
  If CreateMenuElement(5, w)
    MenuElementTitle("File")
    MenuElementItem(0, "New_0")
    MenuElementItem(1, "Open_1")
    MenuElementItem(2, "Save_2")
    
    ; OpenSubMenuElement("SubMenu")
    
    CloseSubMenuElement()
    MenuElementBar()
    MenuElementItem(3, "Print_3")
    MenuElementItem(4, "PrintPreview_4")
    
    MenuElementTitle("Find")
    MenuElementItem(3, "Text_3")
    OpenSubMenuElement("SubMenu")
    MenuElementItem(33, "Text_1_3")
    MenuElementItem(44, "File_1_4")
    
    CloseSubMenuElement()
    MenuElementItem(4, "File_4")
    
    CloseSubMenuElement()
    MenuElementBar()
    MenuElementItem(6, "Help_6")
    
    BindMenuElementEvent(MenuElement(), 1, @MenuItemEvent())
  EndIf
  
  Debug "----"
  
;   ; bug
;   Define e = ContainerElement(#PB_Any, 10,10,280,140) : CloseElementList()
;   ButtonElement(#PB_Any, 10,10,100,30,"Button",0,e)
  
  If CreateMenuElement(15, e)
    MenuElementItem(5, "Find_5")
    MenuElementBar()
    MenuElementItem(6, "Help_6")
    
    BindMenuElementEvent(MenuElement(), 1, @MenuItemEvent())
  EndIf
;      
  Define p = OpenWindowElement(#PB_Any, 10,10, 180,40, "Demo PopupMenuElement()") 
  ButtonElement(#PB_Any, 10,0,100,40,"Button")
  
  ; Bug
  If CreatePopupMenuElement(#PB_Any)
    MenuElementItem(1, "PopupMenuItem_1" )
    MenuElementBar()
    MenuElementItem(6, "PopupMenuItem_6", GetButtonIcon(#PB_ToolBarIcon_Delete))
    
    BindMenuElementEvent(PopupMenuElement(), 1, @MenuItemEvent())
  EndIf
  
 
  BindEventElement(@ElementsCallBack())
  WaitWindowEventClose(d)
CompilerEndIf
