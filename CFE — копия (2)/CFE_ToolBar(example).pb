CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  ; ToolBar functions
  Declare ToolBarElement()
  Declare.b IsToolBarElement(ToolBarElement)
  Declare ToolBarElementToolTip(ToolBarElement, ButtonID, Text$)
  Declare ToolBarElementButtonText(ToolBarElement, ButtonID, Text$)
  Declare CreateToolbarElement(ToolBarElement = #PB_Any, Parent = #PB_Default, Flag.q = 0)
  Declare ToolBarElementImageButton(ButtonID, Image, Mode = #PB_ToolBar_Normal, Text$ = "")
  Declare ToolBarElementStandardButton(ButtonID, ButtonIcon, Mode = #PB_ToolBar_Normal, Text$ = "")
  Declare DisableToolBarElementButton(ToolBarElement, ButtonID, State.b)
  Declare SetToolBarElementItemState(ToolBarElement, ButtonID, State.b)
  Declare GetToolBarElementItemState(ToolBarElement, ButtonID)
  Declare ToolBarElementHeight(ToolBarElement = #PB_Default)
  Declare FreeToolBarElement(ToolBarElement)
  Declare ToolBarElementID(ToolBarElement)
  Declare ToolBarElementSeparator()
  
  ; ToolBar events
  Declare EventToolBarElement()
  Declare BindToolBarElementEvent(ToolBarElement, ButtonID, *CallBack) 
  Declare UnbindToolBarElementEvent(ToolBarElement, ButtonID, *CallBack) 
  
  Declare EventElement()
  Declare EventElementItem()
  
  XIncludeFile "CFE.pbi"
CompilerEndIf


;{ - ToolBarElement
;-
Macro ToolBarElement() : *CreateElement\CreateToolBarElement : EndMacro

Procedure AddToolBarElementItem(ToolBarElement, ToolBarItem, Text$, Image=-1, Flag.q=0)
  Protected ImageWidth, ImageHeight, TextWidth, TextHeight
  
  With *CreateElement
    
    If IsToolBarElement(ToolBarElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(ToolBarElement))
      
      If ((\This()\Flag & #_Flag_Large) = #_Flag_Large)
        ImageHeight = 24
        If IsImage(Image) : ResizeImage(Image, ImageHeight,ImageHeight) : EndIf
      Else
        ImageHeight = 16
      EndIf
      
      ToolBarItem = AddElementItem(ToolBarElement, ToolBarItem, Text$, Image, Flag)
      
      ;\This()\Items()\bSize = 2
      If IsElementItem(ToolBarItem)
        PushListPosition(\This()\Items()) 
        ChangeCurrentElement(\This()\Items(), ItemID(ToolBarItem))
        
        \This()\Items()\Flag = Flag
        \This()\Items()\FrameCoordinate\X = 0
        \This()\Items()\FrameCoordinate\Y = 0
        \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
        \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height
        
        \This()\Item\X + \This()\Item\Width
        
        \This()\Items()\BackColor = \This()\BackColor
        \This()\Items()\FontColor = \This()\FontColor
        \This()\Items()\FrameColor = \This()\FrameColor
        
        
        If Text$ 
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID 
              DrawingFont(\This()\FontID) 
            Else 
              DrawingFont(GetGadgetFont(#PB_Default)) 
            EndIf
            
            If Text$ 
              TextWidth = TextWidth(Text$) 
            EndIf
            If ((\This()\Flag & #_Flag_InlineText) = #_Flag_InlineText)
              TextWidth + 10 
            EndIf
            
            TextHeight = TextHeight("A")  
          EndIf
          StopDrawing()
        EndIf
        
        If ((\This()\Flag & #_Flag_InlineText) <> #_Flag_InlineText)
          If TextWidth
            \This()\Text\String$ = " "
            ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, ImageHeight+10+TextHeight, #PB_Ignore)
          EndIf
        EndIf
        
        ; Если расположить по горизонтали
        If \This()\Item\IsVertical = 0
          If ((\This()\Flag & #_Flag_InlineText) = #_Flag_InlineText)
            \This()\Item\Width = TextWidth 
            
            If IsImage(Image)
              \This()\Item\Width + ImageHeight + 6 ; \This()\InnerCoordinate\Height 
            EndIf
            
          Else
            If TextWidth
              \This()\Item\Width = TextWidth + 14
            Else
              \This()\Item\Width = ImageHeight + 6 
            EndIf
          EndIf
        EndIf
        
        ; Это значит бар
        If Not IsImage(Image) And TextWidth = 0 
          \This()\Item\IsBar + 1 ; 
          \This()\Items()\Item\IsBar = 1
          
          ;DeleteMapElement(\iIndex(), Str(ToolBarItem))
          
          If \This()\Item\IsVertical = 0 
            \This()\Item\Width = 2 + 1 
          EndIf
        EndIf
        
        ; 
        If \This()\Item\IsVertical = 0 
          \This()\Items()\FrameCoordinate\X = \This()\Item\X
          \This()\Items()\FrameCoordinate\Width = \This()\Item\Width ; - (1 to ...)
        EndIf
        
        ;           
        PopListPosition(\This()\Items()) 
      EndIf
      
      ResizeElement(\This()\Element, #PB_Ignore, #PB_Ignore, \This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width+\This()\bSize*2, #PB_Ignore, #PB_Ignore)
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn ToolBarItem
EndProcedure

Procedure ToolBarElementToolTip(ToolBarElement, ButtonID, Text$)
  
  With *CreateElement
    If Text$ And IsToolBarElement(ToolBarElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(ToolBarElement))
      
      If IsElementItem(ButtonID)
        ChangeCurrentElement(\This()\Items(), ItemID(ButtonID))
        \This()\Items()\ToolTip\String$ = Text$
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
EndProcedure

Procedure ToolBarElementButtonText(ToolBarElement, ButtonID, Text$)
  Protected X,Y, TextWidth, TextHeight, Size = 10
  
  If Text$
    With *CreateElement
      If IsToolbarElement(ToolBarElement)
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(ToolBarElement))
        
        If IsElementItem(ButtonID)
          PushListPosition(\This()\Items()) 
          ChangeCurrentElement(\This()\Items(), ItemID(ButtonID))
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID
              DrawingFont(\This()\FontID)
            Else
              DrawingFont(GetGadgetFont(#PB_Default)) ; Шрифт по умолчанию
            EndIf
            
            If \This()\Item\IsVertical
              TextHeight = (TextHeight(Text$) - TextHeight(\This()\Items()\Text\String$)) + Size        
            Else
              TextWidth = (TextWidth(Text$) - TextWidth(\This()\Items()\Text\String$)) + Size          
            EndIf
            StopDrawing()
          EndIf
          
          \This()\Items()\Text\String$ = Text$
          
          X = (\This()\Items()\FrameCoordinate\X+
               \This()\Items()\FrameCoordinate\Width)
          
          Y = (\This()\Items()\FrameCoordinate\Y+
               \This()\Items()\FrameCoordinate\Height)
          
          \This()\Items()\FrameCoordinate\Width + TextWidth
          \This()\Items()\FrameCoordinate\Height + TextHeight
          
          While NextElement(\This()\Items())
            If (\This()\Items()\FrameCoordinate\X >= X)
              \This()\Items()\FrameCoordinate\X + TextWidth
            EndIf
            
            If (\This()\Items()\FrameCoordinate\Y >= Y)
              \This()\Items()\FrameCoordinate\Y + TextHeight
            EndIf
          Wend
          PopListPosition(\This()\Items()) 
        EndIf
        
        ChangeCurrentElement(\This(), ElementID(ToolBarElement))
        LastElement(\This()\Items())
        \This()\Item\X = \This()\Items()\FrameCoordinate\X + TextWidth
        \This()\Item\Y = \This()\Items()\FrameCoordinate\Y + TextHeight
        
        ;
        ResizeElement(\This()\Element, 
                      \This()\FrameCoordinate\X,
                      \This()\FrameCoordinate\Y,
                      \This()\FrameCoordinate\Width + TextWidth,
                      \This()\FrameCoordinate\Height + TextHeight, #PB_Ignore)
        
        
        PopListPosition(\This())
      EndIf
    EndWith
  EndIf
  
EndProcedure

Procedure SetToolBarElementItemState(ToolBarElement, ButtonID, State.b) ; No
  Protected Result
  
  With *CreateElement
    If IsToolBarElement(ToolBarElement)
      PushListPosition(\This()) 
      ChangeCurrentElement(\This(), ElementID(ToolBarElement))
      
      If IsElementItem(ButtonID)
        ChangeCurrentElement(\This()\Items(), ItemID(ButtonID))
        
        Result = \This()\Items()\Toggle
        Select State : Case #PB_ToolBar_Normal,#PB_ToolBar_Toggle : \This()\Items()\Toggle = State : EndSelect
      EndIf
      
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure CreateToolbarElement(ToolBarElement = #PB_Any, Parent = #PB_Default, Flag.q = 0)
  ; 1 - #PB_ToolBar_Small      : Small icon toolbar (Default) 
  ; 2 - #PB_ToolBar_Large      : Large icon toolbar
  ; 8 - #PB_ToolBar_InlineText : Text will be displayed at the right of the button 
  Protected Height, PrevParent =- 1
  
  If Flag = 0
    Flag = #PB_ToolBar_Small|#PB_ToolBar_InlineText
  EndIf
  
  If ((Flag & #PB_ToolBar_Large) = #PB_ToolBar_Large) 
    Height = 32 ; 44
    Flag &~ #PB_ToolBar_Large
    Flag | #_Flag_Large
  EndIf
  If ((Flag & #PB_ToolBar_Small) = #PB_ToolBar_Small) 
    Height = 24 ; 28
    Flag &~ #PB_ToolBar_Small
    Flag | #_Flag_Small
  EndIf
  
  If ((Flag & #PB_ToolBar_InlineText) = #PB_ToolBar_InlineText)
    Flag &~ #PB_ToolBar_InlineText
    Flag | #_Flag_InlineText | #_Flag_Image_Center|#_Flag_Text_Center | #_Flag_Image_Left|#_Flag_Text_Right
  Else
    Flag | #_Flag_Image_Center|#_Flag_Text_Center | #_Flag_Image_Top|#_Flag_Text_Bottom
  EndIf
  
  
  With *CreateElement
    ; Чтобы на одном родителе не создавать больше одного тульбра
    If IsElement(Parent) 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(Parent))
      If \This()\ToolBarHeight
        \CreateToolBarElement =- 1
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
    
    
    
    ToolBarElement = CreateElement(#_Type_ToolBar, ToolBarElement,0,-1,Height,Height, "",#PB_Default,#PB_Default,#PB_Default, Flag)
    
    ;   With *CreateElement
    ;     PushListPosition(\This())
    ;     ChangeCurrentElement(\This(), ElementID(ToolBarElement))
    ;     If StartDrawing(CanvasOutput(\Canvas))
    ;       If \This()\FontID 
    ;         DrawingFont(\This()\FontID) 
    ;       Else 
    ;         DrawingFont(GetGadgetFont(#PB_Default)) 
    ;       EndIf
    ;       
    ;       If \This()\Item\IsVertical = 1
    ;         \This()\Item\Width = TextHeight("A")  
    ;       ElseIf \This()\Item\IsVertical = 0
    ;         \This()\Item\Height = TextHeight("A")  
    ;       EndIf
    ;       
    ;       StopDrawing()
    ;     EndIf
    ;     PopListPosition(\This())
    ;   EndWith
    
    ; Bug
    ; If IsElement(Parent) : SetElementParent(ToolBarElement, Parent) : EndIf
    
    If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  EndWith
  ProcedureReturn ToolBarElement
EndProcedure

Procedure ToolBarElementButton(ButtonID, Image, Toggle = #PB_ToolBar_Normal, ButtonIcon = #PB_Default, Text$ = "", ToolTip$="") 
  Protected Flag.q = #_Flag_Image_Center|#_Flag_Text_Center | #_Flag_Image_Right|#_Flag_Text_Left
  
  Protected ToolBarElement
  If ButtonID =- 1 : ButtonID = 65535 : EndIf
  
  If Not IsImage(Image)
    UsePNGImageDecoder()
    Image = GetButtonIcon(ButtonIcon) 
  EndIf
  
  With *CreateElement
    ToolBarElement = ToolBarElement()
    
    If IsToolBarElement(ToolBarElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(ToolBarElement))
      
      ButtonID = AddToolBarElementItem(ToolBarElement, ButtonID, Text$, Image, \This()\Flag)
      
      If (Toggle = #True Or Toggle = #False)
        SetToolBarElementItemState(ToolBarElement, ButtonID, Toggle)
      EndIf
      
      If ToolTip$ : ToolBarElementToolTip(ToolBarElement, ButtonID, ToolTip$) : EndIf
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn ButtonID
EndProcedure

Procedure ToolBarElementImageButton(ButtonID, Image, Mode = #PB_ToolBar_Normal, Text$ = "")
  ProcedureReturn ToolBarElementButton(ButtonID, Image, Mode, #PB_Default, Text$)
EndProcedure

Procedure ToolBarElementStandardButton(ButtonID, ButtonIcon, Mode = #PB_ToolBar_Normal, Text$ = "")
  ProcedureReturn ToolBarElementButton(ButtonID, #PB_Default, Mode, ButtonIcon, Text$)
EndProcedure

Procedure DisableToolBarElementButton(ToolBarElement, ButtonID, State.b)
  If IsToolBarElement(ToolBarElement)
    If ButtonID = #PB_All
      DisableElement(ToolBarElement, State)
    Else  
      DisableElementItem(ToolBarElement, ButtonID, State)
    EndIf
  EndIf
EndProcedure

Procedure GetToolBarElementItemState(ToolBarElement, ButtonID) ; No
  ProcedureReturn SetToolBarElementItemState(ToolBarElement, ButtonID, #PB_Default)
EndProcedure

Procedure FreeToolBarElement(ToolBarElement)
  If IsToolBarElement(ToolBarElement)
    FreeElement(ToolBarElement)
  EndIf
EndProcedure

Procedure ToolBarElementID(ToolBarElement)
  If IsToolBarElement(ToolBarElement)
    ProcedureReturn ElementID(ToolBarElement)
  EndIf
EndProcedure

Procedure ToolBarElementSeparator()
  ProcedureReturn ToolBarElementButton(#PB_Default, #PB_Default)
EndProcedure

Procedure ToolBarElementHeight(ToolBarElement = #PB_Default)
  Protected Result
  
  With *CreateElement
    If ToolBarElement = #PB_Default 
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(\This()\Element))
      ChangeCurrentElement(\This(), ElementID(\This()\Parent\Element))
      Result = \This()\ToolBarHeight
      PopListPosition(\This())
      
    Else
      If IsElement(ToolBarElement)
        PushListPosition(\This())
        ChangeCurrentElement(\This(), ElementID(ToolBarElement))
        
        Select \This()\Type
          Case #_Type_ToolBar : Result = \This()\FrameCoordinate\Height
          Default : Result = \This()\ToolBarHeight ; 
        EndSelect
        
        PopListPosition(\This())
      EndIf
      
    EndIf
  EndWith
    
  ProcedureReturn Result
EndProcedure
;}



;-
; ToolBar element example
CompilerIf #PB_Compiler_IsMainFile
  ; ToolBar element bind event example
  Procedure ToolBarButtonEvent(Event.q, EventElement)
    Debug "Event element ID: "+EventElement()
    Debug "Event element Item ID: "+EventToolBarElement()
  EndProcedure
  
  Define w = OpenWindowElement(#PB_Any, 0,0, 500,160, "Demo ToolBarElement()") 
  
  Define e = ContainerElement(#PB_Any, 10,10,280,140) : CloseElementList() ; , "", #PB_Container_BorderLess 
  
  If CreateToolbarElement(22, w);, #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
    ToolBarElementStandardButton(1, -1, 0, "Open" )
    ToolBarElementStandardButton(2, -1, 0, "Close" )
    ToolBarElementSeparator()
    
    
    BindMenuElementEvent(ToolBarElement(), 1, @ToolBarButtonEvent())
  EndIf
;   If CreateToolBarElement(22, w);, #PB_ToolBar_Large|#PB_ToolBar_Text|#PB_ToolBar_InlineText)
;     ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
;     ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save)
;     ToolBarElementSeparator()
;     
;     ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
;     ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
;     ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find, 0, "Find")
;     ToolBarElementStandardButton(6, #PB_ToolBarIcon_Help)
;     
;     BindMenuElementEvent(ToolBarElement(), 1, @ToolBarButtonEvent())
;   EndIf
  
  If CreateToolbarElement(33, e, #PB_ToolBar_Large|#PB_ToolBar_InlineText)
    ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarElementStandardButton(10, #PB_ToolBarIcon_Open, 0, "Open" )
    ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save, #PB_ToolBar_Toggle)
    ToolBarElementSeparator()
    
    ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
    ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
    ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find, 0, "Find")
    ToolBarElementStandardButton(6, #PB_ToolBarIcon_Help)
    
  ;  BindEventElement(@ToolBarButtonEvent())
    BindMenuElementEvent(ToolBarElement(), 1, @ToolBarButtonEvent())
  EndIf
  Define b=ButtonElement(#PB_Any, 10,10,100,30,"Button",0,e)
  
  
  ToolBarElementButtonText(ToolBarElement(), 2, "Disabled")
  DisableToolBarElementButton(ToolBarElement(), 2, #True)
  
  ToolBarElementToolTip(ToolBarElement(), 10, "Загрузить")
  SetElementToolTip(b, "Кнопка")
  
  Debug ToolBarElementHeight(ToolBarElement())
  WaitWindowEventClose(w)
CompilerEndIf


