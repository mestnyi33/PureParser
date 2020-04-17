CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
  Declare AddNewElement(Type, Parent, Item, Reset.b)
  XIncludeFile "CFE_(IDE).pb"
  
CompilerEndIf


;{ Window element functions
Procedure DrawOpenWindowElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected ScrollWidth = 6
  Protected Result, DrawingMode, Text$
  Protected X,Y,Width,Height
  Protected iX,iY,iWidth,iHeight
  Protected CiX,CiY,CiWidth,CiHeight
  
  With *CreateElement
    
    If ListSize(\This()\Items())
      Protected Item_X
      X = \This()\InnerCoordinate\X
      Y = (\This()\FrameCoordinate\Y+\This()\bSize)
      
      PushListPosition(\This()\Items())
      ForEach \This()\Items()
        
        If ListIndex(\This()\Items()) = 0 
          \This()\Items()\bSize = 0
          \This()\Items()\FrameCoordinate\Y =- 1
          \This()\Items()\FrameCoordinate\Width = \This()\InnerCoordinate\Width
          
          If \This()\MenuHeight : \This()\Items()\MenuHeight = \This()\MenuHeight : EndIf
          If \This()\ToolBarHeight : \This()\Items()\ToolBarHeight = \This()\ToolBarHeight : EndIf
          If \This()\CaptionHeight : \This()\Items()\CaptionHeight = \This()\CaptionHeight : EndIf
          
          
          If \This()\Disable = 0 And (IsActiveWindowElement(\This()\Element) Or \This()\Element = \CheckedElement)
            \This()\Items()\State = #_State_Entered 
          Else
            \This()\Items()\State = #_State_Default 
          EndIf
          
            
        Else
          Protected otstup = 5
          \This()\Items()\bSize = 0
          \This()\Items()\FrameCoordinate\Y = -1 
          \This()\Items()\FrameCoordinate\Width = 32
          \This()\Items()\FrameCoordinate\Height =  18
          \This()\Items()\Flag | #_Flag_Image_Center 
          \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
          
          If \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
            Protected Color
              Select \This()\Items()\Type
                Case #_Flag_CloseGadget    
                  Color = $5353FF
                Case #_Flag_MinimizeGadget, #_Flag_MaximizeGadget
                  Color = \This()\Items()\EnteredBackColor
              EndSelect
              
            If ListIndex(\This()\Items()) = \This()\Item\Entered\Element And \This()\Items()\Disable = 0
              DrawingMode(#PB_2DDrawing_Default)
              Box((X+\This()\Items()\FrameCoordinate\X)+1, (Y+\This()\Items()\FrameCoordinate\Y)+1,
                  \This()\Items()\FrameCoordinate\Width-2, \This()\Items()\FrameCoordinate\Height-2, Color)
            EndIf
          Else
            \This()\Items()\Flag|#_Flag_Border
          EndIf
          
          Item_X + (\This()\Items()\FrameCoordinate\Width + -1) 
          \This()\Items()\FrameCoordinate\X = ((\This()\InnerCoordinate\Width-Item_X)-otstup)
          \This()\Item\X = \This()\Items()\FrameCoordinate\X
        EndIf
        
        DrawContent(\This()\Items(), X,Y)
      Next
      PopListPosition(\This()\Items())
    EndIf
    
  EndWith
EndProcedure

Procedure.q SetOpenWindowElementFlag(Flag.q)
  Protected Result.q = Flag
  ; 13107200   - #PB_Window_SystemMenu      ; Enables the system menu on the Window Title bar (Default).
  ; 13238272   - #PB_Window_MinimizeGadget  ; Adds the minimize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
  ; 13172736   - #PB_Window_MaximizeGadget  ; Adds the maximize Gadget To the Window Title bar. #PB_Window_SystemMenu is automatically added.
  ; 12845056   - #PB_Window_SizeGadget      ; Adds the sizeable feature To a Window.
  ; 268435456  - #PB_Window_Invisible       ; Creates the Window but don't display.
  ; 12582912   - #PB_Window_TitleBar        ; Creates a Window With a titlebar.
  ; 4          - #PB_Window_Tool            ; Creates a Window With a smaller titlebar And no taskbar entry. 
  ; 2147483648 - #PB_Window_BorderLess      ; Creates a Window without any borders.
  ; 1          - #PB_Window_ScreenCentered  ; Centers the Window in the middle of the screen. X,Y parameters are ignored.
  ; 2          - #PB_Window_WindowCentered  ; Centers the Window in the middle of the Parent Window ('ParentWindowID' must be specified).
  ;                X,Y parameters are ignored.
  ; 16777216   - #PB_Window_Maximize        ; Opens the Window maximized. (Note  ; on Linux, Not all Windowmanagers support this)
  ; 536870912  - #PB_Window_Minimize        ; Opens the Window minimized.
  ; 8          - #PB_Window_NoGadgets       ; Prevents the creation of a GadgetList. UseGadgetList() can be used To do this later.
  ; 33554432   - #PB_Window_NoActivate      ; Don't activate the window after opening.


; ; ;   If ((Flag & #PB_Window_BorderLess) = #PB_Window_BorderLess)
; ; ;     Result = #_Flag_BorderLess
; ; ;   Else
; ; ;     If ((Flag & #PB_Window_Flat) = #PB_Window_Flat)
; ; ;       Result | #_Flag_Flat
; ; ;     ElseIf ((Flag & #PB_Window_Single) = #PB_Window_Single)
; ; ;       Result | #_Flag_Single
; ; ;     ElseIf ((Flag & #PB_Window_Double) = #PB_Window_Double)
; ; ;       Result | #_Flag_Double
; ; ;     ElseIf ((Flag & #PB_Window_Raised) = #PB_Window_Raised)
; ; ;       Result | #_Flag_Raised
; ; ;     EndIf
; ; ;     
; ; ;     If ((Flag & #PB_Window_SystemMenu) = #PB_Window_SystemMenu)
; ; ;       Result | #_Flag_SystemMenu
; ; ;     ElseIf ((Flag & #PB_Window_TitleBar) = #PB_Window_TitleBar)
; ; ;       Result | #_Flag_TitleBar
; ; ;     EndIf
; ; ;     
; ; ;     If ((Flag & #PB_Window_MinimizeGadget) = #PB_Window_MinimizeGadget)
; ; ;       Result | #_Flag_MinimizeGadget
; ; ;     EndIf
; ; ;     If ((Flag & #PB_Window_MaximizeGadget) = #PB_Window_MaximizeGadget)
; ; ;       Result | #_Flag_MaximizeGadget
; ; ;     EndIf
; ; ;     If ((Flag & #PB_Window_CloseGadget) = #PB_Window_CloseGadget)
; ; ;       Result | #_Flag_CloseGadget
; ; ;     EndIf
; ; ;   EndIf
; ; ; 
; ; ;   If ((Flag & #PB_Window_ScreenCentered) = #PB_Window_ScreenCentered)
; ; ;     Result | #_Flag_ScreenCentered
; ; ;   ElseIf ((Flag & #PB_Window_WindowCentered) = #PB_Window_WindowCentered)
; ; ;     Result | #_Flag_WindowCentered
; ; ;   EndIf
; ; ;   
; ; ;   If ((Flag & #PB_Window_SizeGadget) = #PB_Window_SizeGadget)
; ; ;     Result | #_Flag_SizeGadget
; ; ;   EndIf
; ; ;   If ((Flag & #PB_Window_MoveGadget) = #PB_Window_MoveGadget)
; ; ;     Result | #_Flag_MoveGadget
; ; ;   EndIf
; ; ;   If ((Flag & #PB_Window_Invisible) = #PB_Window_Invisible)
; ; ;     Result | #_Flag_Invisible
; ; ;   EndIf
; ; ;   If ((Flag & #PB_Window_Transparent) = #PB_Window_Transparent)
; ; ;     Flag | #_Flag_Transparent
; ; ;   EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure.q GetOpenWindowElementFlag(Flag.q)
  Protected Result.q = Flag
  
; ; ;   If ((Flag & #_Flag_BorderLess) = #_Flag_BorderLess)
; ; ;     Result = #PB_Window_BorderLess
; ; ;   Else
; ; ;     If ((Flag & #_Flag_Flat) = #_Flag_Flat)
; ; ;       Result | #PB_Window_Flat
; ; ;     ElseIf ((Flag & #_Flag_Single) = #_Flag_Single)
; ; ;       Result | #PB_Window_Single
; ; ;     ElseIf ((Flag & #_Flag_Double) = #_Flag_Double)
; ; ;       Result | #PB_Window_Double
; ; ;     ElseIf ((Flag & #_Flag_Raised) = #_Flag_Raised)
; ; ;       Result | #PB_Window_Raised
; ; ;     EndIf
; ; ;     
; ; ;     If ((Flag & #_Flag_TitleBar) = #_Flag_TitleBar)
; ; ;       Result | #PB_Window_TitleBar
; ; ;     ElseIf ((Flag & #_Flag_SystemMenu) = #_Flag_SystemMenu)
; ; ;       Result | #PB_Window_SystemMenu
; ; ;     EndIf
; ; ;     
; ; ;     If ((Flag & #_Flag_MinimizeGadget) = #_Flag_MinimizeGadget)
; ; ;       Result | #PB_Window_MinimizeGadget
; ; ;     EndIf
; ; ;     If ((Flag & #_Flag_MaximizeGadget) = #_Flag_MaximizeGadget)
; ; ;       Result | #PB_Window_MaximizeGadget
; ; ;     EndIf
; ; ;   EndIf
; ; ; 
; ; ;   If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
; ; ;     Result | #PB_Window_ScreenCentered
; ; ;   ElseIf ((Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
; ; ;     Result | #PB_Window_WindowCentered
; ; ;   EndIf
; ; ;   
; ; ;   If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
; ; ;     Result | #PB_Window_SizeGadget
; ; ;   EndIf
; ; ;   If ((Flag & #_Flag_MoveGadget) = #_Flag_MoveGadget)
; ; ;     Result | #PB_Window_MoveGadget
; ; ;   EndIf
; ; ;   If ((Flag & #_Flag_Invisible) = #_Flag_Invisible)
; ; ;     Result | #PB_Window_Invisible
; ; ;   EndIf
; ; ;  
; ; ;   
; ; ;   If ((Flag & #_Flag_Transparent) = #_Flag_Transparent)
; ; ;     Result | #PB_Window_Transparent
; ; ;   EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure OpenWindowElement(Element,X,Y,Width,Height, Title.S="", Flag.q = #_Flag_ScreenCentered|#_Flag_SystemMenu, Parent =- 1)
  If Not *CreateElement : InitializeElements(S_GLOBAL) : EndIf
  Protected CaptionHeight = 29
  
  With *CreateElement
    If ListSize(\This()) 
      While CloseElementList() : Wend 
      If IsElement(Parent) : OpenElementList(Parent) : EndIf
      
      ;;;;Height + 27 + 2
      ;;; If Flag = 0 : Flag = #PB_Window_SystemMenu : EndIf
      Flag = SetOpenWindowElementFlag(Flag)
      If Flag = 0 : Flag = #_Flag_SystemMenu : EndIf
      
      ; AlignmentElement(Element, Flag)
      If ((Flag & #_Flag_ScreenCentered) = #_Flag_ScreenCentered)
        X = (ElementWidth(0)-Width)/2 
        Y = (ElementHeight(0)-Height)/2
        
      ElseIf ((Flag & #_Flag_WindowCentered) = #_Flag_WindowCentered)
        If IsElement(Parent)
          X = (ElementWidth(Parent)-Width)/2 
          Y = (ElementHeight(Parent)-Height)/2
        EndIf
      EndIf
      
      Protected bs
      ; Border type then draw
      If ((Flag & #_Flag_Flat) = #_Flag_Flat)
        bs=1
      EndIf
      If (((Flag & #_Flag_Double) = #_Flag_Double) Or
          ((Flag & #_Flag_Raised) = #_Flag_Raised))
        bs=2
      EndIf
      If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
        bs=4
      EndIf
  
      Element = CreateElement( #_Type_Window, Element, X,Y,Width+bs*2+2,Height+CaptionHeight()+bs*2+2,Title, #PB_Default,#PB_Default,#PB_Default, Flag);|#_Flag_SystemMenu )
      ;SetElementText( Element, Title )
    Else 
      
      
      Element = CanvasDesktop(Element,X,Y,Width,Height, Title, Flag, 0)
    EndIf
  EndWith
  
  ProcedureReturn Element
EndProcedure

;}

;-
; Window element example
CompilerIf #PB_Compiler_IsMainFile
  
  
  Define Window = OpenWindowElement(#PB_Any, 0,0, 432,284+4*65);, "Demo WindowElement()") 
  Define  h = GetElementAttribute(Window, #_Attribute_CaptionHeight)
  
  
;   OpenWindowElement(#PB_Any, 220,10,200,90, "BorderLess", #PB_Window_BorderLess|#PB_Window_SizeGadget) ; |#PB_Window_MoveGadget
;   OpenWindowElement(#PB_Any, 220,65+30+10,200,90, "SizeGadget", #PB_Window_Single|#PB_Window_SizeGadget) 
;   OpenWindowElement(#PB_Any, 220,130+60+10,200,90, "TitleBar", #PB_Window_Double|#PB_Window_SizeGadget)  ; |#PB_Window_Transparent
;   OpenWindowElement(#PB_Any, 220,105+180+10,200,90, "SystemMenu", #PB_Window_Raised|#PB_Window_SizeGadget)
  Procedure ComboBoxElementEvent(Event.q, EventElement)
    Debug ElementEvent()
    Debug EventElementItem()
    ; NewElement(#_Type_Window, 0,0)
  EndProcedure
  
  Procedure ToolBarElementEvent(Event.q, EventElement)
    ButtonElement(#PB_Any, 10,10,180,90, "BorderLess", #_Flag_MoveGadget|#_Flag_SizeGadget, 0)
  EndProcedure
  
  OpenWindow(#PB_Any, 10,10,200,90, "BorderLess", #PB_Window_BorderLess)
  Define e=OpenWindowElement(#PB_Any, 220,10,200,90, "BorderLess", #_Flag_BorderLess) ; |#_Flag_MoveGadget
  If CreateToolBarElement(33, e, #PB_ToolBar_Small)
    ToolBarElementStandardButton(0, #PB_ToolBarIcon_New)
    ToolBarElementStandardButton(1, #PB_ToolBarIcon_Open, 0, "Open" )
    ToolBarElementStandardButton(2, #PB_ToolBarIcon_Save, #PB_ToolBar_Toggle)
    ToolBarElementSeparator()
    
    ToolBarElementStandardButton(3, #PB_ToolBarIcon_Print)
    ToolBarElementStandardButton(4, #PB_ToolBarIcon_PrintPreview)
    ToolBarElementStandardButton(5, #PB_ToolBarIcon_Find, 0, "Find")
    ToolBarElementStandardButton(6, #PB_ToolBarIcon_Help)
    
    ToolBarElementToolTip(ToolBarElement(), 0, "Создать новую форму")
    BindMenuElementEvent(ToolBarElement(), 0, @ToolBarElementEvent())
  EndIf
  
  
  Define c=ComboBoxElement(#PB_Any, 60,10,80,20)
  Define i
  For i=0 To 29
    AddGadgetElementItem(c, i,Str(i)+"_item")
  Next
  
  SetElementState(c, 3)
  
  Define c=ComboBoxElement(#PB_Any, 60,40,80,20,#_Flag_Editable)
  Define i
  For i=0 To 30
    AddGadgetElementItem(c, i,Str(i)+"_item")
  Next
  BindGadgetElementEvent(c, @ComboBoxElementEvent(), #_Event_Change)
  
  OpenWindow(#PB_Any, 10+1,65+30+10+h+1,200,90, "SizeGadget", #PB_Window_SizeGadget)
  OpenWindowElement(#PB_Any, 20,30,200,90, "SizeGadget", #_Flag_SizeGadget,e) 
  ;OpenWindowElement(#PB_Any, 220,65+30+10,200,90, "SizeGadget", #_Flag_SizeGadget,e) 
  ButtonElement(#PB_Any, 0,0,100,30,"Button")
  
  OpenWindow(#PB_Any, 10+1,130+60+10+h+1,200,90, "TitleBar", #PB_Window_TitleBar) 
  Define e=OpenWindowElement(#PB_Any, 220,130+60+10,200,90, "TitleBar", #_Flag_TitleBar)  ; |#_Flag_Transparent
  If CreateMenuElement(#PB_Any, e)
    MenuElementTitle("menu")
    MenuElementItem(5, "Find")
    MenuElementBar()
    MenuElementItem(6, "Help")
    
    MenuElementTitle("test")
    
    MenuElementTitle("demo")
    MenuElementItem(5, "item")
    MenuElementBar()
    MenuElementItem(6, "iHelp")
  EndIf

  Define g=OpenWindow(#PB_Any, 10+1,105+180+10+h+1,200,90, "SystemMenu", #PB_Window_SystemMenu) 
  Define e=OpenWindowElement(#PB_Any, 220,105+180+10,200,90, "SystemMenu", #_Flag_SystemMenu)
  DisableElement(e,1)
  
  Define g=OpenWindow(#PB_Any, 10+1,200+180+10+h+1,200,90, "", #PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_MinimizeGadget|#PB_Window_SizeGadget)
  Define e=OpenWindowElement(#PB_Any, 220,200+180+10,200,90, "AllSystemMenu", #_Flag_SystemMenu|#_Flag_MaximizeGadget|#_Flag_MinimizeGadget|#_Flag_SizeGadget)
  SetElementImage(e,0)
  
  e=ButtonElement(#PB_Any, 10,10,50,20,"create")
  
;   DisableGadget(g, #True)
;   DisableElement(e, #True)
;   
;   Debug "element flag: "+GetElementFlag(e)
;   Debug "gadget element flag: "+GetGadgetElementFlag(e)
  Define g=ComboBoxGadget(#PB_Any, 10,10,80,20)
  Define i
  For i=0 To 29
    AddGadgetItem(g, i,Str(i)+"_item")
  Next
  
  Define g=ComboBoxGadget(#PB_Any, 10,40,80,20,#PB_ComboBox_Editable)
  Define i
  For i=0 To 30
    AddGadgetItem(g, i,Str(i)+"_item")
  Next
  
  Procedure _ButtonElementEvent(Event.q, EventElement)
    AddNewElement(#_Type_Window, 0,0,1)
  EndProcedure
  
  BindGadgetElementEvent(e, @_ButtonElementEvent(), #_Event_LeftClick)
  WaitWindowEventClose(Window)
CompilerEndIf

