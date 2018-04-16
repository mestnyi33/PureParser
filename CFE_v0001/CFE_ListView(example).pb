CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  XIncludeFile "CFE.pbi"
  
CompilerElse
  Declare UpdateScrollCoordinate(List This.S_CREATE_ELEMENT())
CompilerEndIf

;{ - ListView element functions
;-
Procedure DrawListViewElementItemsContent(List This.S_CREATE_ELEMENT(), ItemElement, X,Y)
  Protected FontColor, Width, Height, Result.b
  
  Protected ScrollWidth = 6
  
  With This()
    If \Item\IsVertical = 0 And \InnerCoordinate\Width
      Result = #True
    ElseIf \Item\IsVertical = 1 And \InnerCoordinate\Height
      Result = #True
    EndIf
    
    X-\Scroll\PosX
    Y-\Scroll\PosY
    
    If Result 
      Protected Y1=1
      
      PushListPosition(\Items())
      ForEach \Items()
        \Items()\FrameCoordinate\X=1
        \Items()\FrameCoordinate\Y=Y1
        
        If \Item\IsVertical = 1
          \Items()\FrameCoordinate\Width = \InnerCoordinate\Width - \Items()\FrameCoordinate\X - ElementWidth(\Scroll\Vert)
        EndIf
        
        If *CreateElement\This() <> This()
          ClipCoordinate(This(), *CreateElement\This()\FrameCoordinate\X,*CreateElement\This()\FrameCoordinate\Y,*CreateElement\This()\FrameCoordinate\Width,*CreateElement\This()\FrameCoordinate\Height);+MenuHeight)
        EndIf
        
        
        ; Для меню итемов 
        If \Items()\Disable = 0
          If \Items()\Element = \Item\Entered\Element
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box((X+\Items()\FrameCoordinate\X)+1, (Y+\Items()\FrameCoordinate\Y)+1, \Items()\FrameCoordinate\Width-2, \Items()\FrameCoordinate\Height-2, \Items()\EnteredBackColor&$FFFFFF|$80<<24)
            
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor&$FFFFFF|$80<<24)
          EndIf
          
          If \Items()\Element = \Item\Selected\Element 
            If \Element = *CreateElement\ActiveElement Or *CreateElement\This()\Type = #_Type_Menu
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\SelectedBackColor&$FFFFFF|$80<<24)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box((X+\Items()\FrameCoordinate\X), (Y+\Items()\FrameCoordinate\Y), \Items()\FrameCoordinate\Width, \Items()\FrameCoordinate\Height, \Items()\FrameColor&$FFFFFF|$80<<24)
            EndIf
          EndIf
        EndIf
        
        DrawContent(\Items(), X, Y )
        
        If Not IsImage(\Items()\Img\Image) And \Items()\Img\Image>0
          Y1+\Items()\FrameCoordinate\Height+3
        Else
          Y1+\Items()\FrameCoordinate\Height
        EndIf
        
        
        
; ;         Protected Min, Max, PageLength, ScrollStep
; ;         If IsElement(\Scroll\Vert)
; ;           PushListPosition(This())
; ;           ;ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
; ;           
; ; ;           Min = \Scroll\Min
; ; ;           Max = \Scroll\Max
; ; ;            PageLength = \InnerCoordinate\Height
; ; ;           ScrollStep = 3 ; \Items()\FrameCoordinate\Height
; ;           
; ;           ChangeCurrentElement(This(), ElementID(\Scroll\Vert))
; ;           
; ; ;           \Scroll\Min = Min
; ; ;           \Scroll\Max = Max
; ; ;           \Scroll\PageLength = PageLength-ElementHeight(\Scroll\Horz)
; ; ;           \Scroll\ScrollStep = ScrollStep
; ;           
; ; ;           UpdateScrollCoordinate(This())
; ;           PopListPosition(This())
; ;         EndIf
        
;         Protected hMin, hMax, hPageLength, hScrollStep
; ;         If IsElement(\Scroll\Horz)
; ;           PushListPosition(This())
; ;           ;ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
; ;           
; ;           hMin = \Scroll\Min
; ;           hMax = \Item\Width
; ;           hPageLength = \InnerCoordinate\Width
; ;           hScrollStep = 3 ; \Items()\FrameCoordinate\Width
; ;           
; ;           ChangeCurrentElement(This(), ElementID(\Scroll\Horz))
; ;           
; ;           \Scroll\Min = hMin
; ;           \Scroll\Max = hMax
; ;           \Scroll\PageLength = hPageLength - ElementWidth(\Scroll\Vert)
; ;           \Scroll\ScrollStep = hScrollStep
; ;           
; ;           UpdateScrollCoordinate(This())
; ;           PopListPosition(This())
; ;         EndIf
      Next
      PopListPosition(\Items())
      
      ;ClipOutput(\X,\Y,\Width,\Height)
    EndIf
  EndWith
  
EndProcedure

Procedure AddListViewElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
  Protected ImageWidth, ImageHeight, TextWidth, TextHeight
  
  With *CreateElement
    ;Image =- 1 ; TODO
    
    If IsGadgetElement(GadgetElement)
      PushListPosition(\This())
      ChangeCurrentElement(\This(), ElementID(GadgetElement))
      
      If Flag = 0
        Flag  | #_Flag_Text_Center| #_Flag_Text_Left | #_Flag_Image_Center| #_Flag_Image_Left
      EndIf
      
      If IsImage(Image) 
        If ((\This()\Flag & #_Flag_Large) = #_Flag_Large)
          ImageHeight = 24
          ResizeImage(Image, ImageHeight,ImageHeight)
        Else
          ImageHeight = 16
        EndIf 
      EndIf
      
      
      If GadgetItem = #PB_Any
        LastElement(\This()\Items())
        AddElement(\This()\Items()) 
        GadgetItem = ListSize(\This()\Items())
      Else
        If (GadgetItem > (ListSize(\This()\Items()) - 1))
          LastElement(\This()\Items())
          AddElement(\This()\Items()) 
        Else
          SelectElement(\This()\Items(), GadgetItem)
          InsertElement(\This()\Items())
        EndIf
      EndIf
      
      \This()\Items()\Element = GadgetItem
      \This()\iID(Str(@\This()\Items())) = GadgetItem
      \This()\iHandle(Str(GadgetItem)) = @\This()\Items()
      
      ;\This()\Items()\bSize = 2
      If IsElementItem(GadgetItem)
        PushListPosition(\This()\Items()) 
        ChangeCurrentElement(\This()\Items(), ItemID(GadgetItem))
        
        ;Debug \This()\Items()\Element
        \This()\Items()\Flag = Flag
        \This()\Items()\Text\String$ = Text$
        \This()\Items()\Img\ImgBg =- 1
        \This()\Items()\Img\Image = Image
        
        \This()\Items()\SelectedFontColor = $FFFFFF
        \This()\Items()\SelectedBackColor = $FFBAA0
        \This()\Items()\EnteredFontColor = $505050
        \This()\Items()\EnteredBackColor = $FCDFC3
        
        \This()\Items()\DrawingMode = #PB_2DDrawing_AlphaBlend
        \This()\Items()\FrameCoordinate\Height = \This()\InnerCoordinate\Height
        
        \This()\Items()\BackColor = \This()\BackColor
        \This()\Items()\FontColor = \This()\FontColor
        \This()\Items()\FrameColor = \This()\FrameColor
        
        
        If Not IsImage(Image) And Image>0
          If \This()\Item\IsVertical = 1
            \This()\Items()\FrameCoordinate\Height = Image
          Else
            \This()\Items()\FrameCoordinate\Width = Image
          EndIf
        Else
          If Text$ 
            If StartDrawing(CanvasOutput(\Canvas))
              If \This()\FontID 
                DrawingFont(\This()\FontID) 
              Else 
                DrawingFont(GetGadgetFont(#PB_Default)) 
              EndIf
              TextHeight = TextHeight("A") 
              
              If Text$ 
                TextWidth = TextWidth(Text$) 
                If \This()\Item\Width < TextWidth
                  \This()\Item\Width = TextWidth 
                  \This()\Items()\Item\Width = TextWidth 
                EndIf
              EndIf
              
              If ImageHeight 
                TextHeight = ImageHeight + 4
              EndIf
              
              \This()\Items()\Text\Width = TextWidth
            
            EndIf
            StopDrawing()
          EndIf
          
          ; 
          If \This()\Item\IsVertical = 1
            \This()\Items()\FrameCoordinate\Height = TextHeight  ; - (1 to ...)
          Else
            \This()\Items()\FrameCoordinate\Width = TextWidth ; - (1 to ...)
          EndIf
          
        EndIf
        
        ;           
        PopListPosition(\This()\Items()) 
      EndIf
      If \This()\Scroll\Max = 0 : \This()\Scroll\Max = 2 : EndIf
      \This()\Scroll\Max + TextHeight
      
      SetElementAttribute(\This()\Scroll\Vert, #PB_ScrollBar_Maximum, \This()\Scroll\Max);+ElementHeight(\This()\Scroll\Horz))
      SetElementAttribute(\This()\Scroll\Horz, #PB_ScrollBar_Maximum, \This()\Item\Width);+ElementWidth(\This()\Scroll\Vert))
  
      UpdateScrolls(\This())
    
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn GadgetItem
EndProcedure

Procedure ListScrollBarEvent(Event.q, EventElement)
  
  Select Event
    Case #_Event_Up, #_Event_Down
      With *CreateElement
        Protected IsVertical = Bool((\This()\Flag&#_Flag_Vertical)=#_Flag_Vertical) 
        
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
  
  ProcedureReturn #True
EndProcedure


Procedure ListViewElement( Element, X,Y,Width,Height, Title.S = "", Flag.q = 0, Parent =- 1 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ListView, Element, X,Y,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag);|#_Flag_AlignText_Top )
  
  
  If Title : AddListViewElementItem(Element, 0, Title) : EndIf
  
  
  
  
  
  Protected Type, iWidth = Width, iHeight = Height 
  Protected ScrollStep, ScrollAreaElement=-1, ScrollHeightElement=-1, ScrollWidthElement=-1

  Protected dbs, ScrollBarSize = 17
  ; Border type then draw
  If ((Flag & #_Flag_Flat) = #_Flag_Flat)
    dbs=1
  EndIf
  If (((Flag & #_Flag_Double) = #_Flag_Double) Or
      ((Flag & #_Flag_Raised) = #_Flag_Raised))
    dbs=2
  EndIf
  If ((Flag & #_Flag_SizeGadget) = #_Flag_SizeGadget)
    dbs=4
  EndIf
  
  
  ScrollHeightElement = ScrollBarElement(#PB_Any, X+Width-ScrollBarSize-dbs,dbs+Y,ScrollBarSize,Height-ScrollBarSize-dbs*2, 0, 0, Height,#_Flag_Vertical|#_Flag_BorderLess)
;   SetElementData(ScrollHeightElement, Element)
;   BindGadgetElementEvent(ScrollHeightElement, @ListScrollBarEvent(), #_Event_Up|#_Event_Down)
  
    ScrollWidthElement = ScrollBarElement(#PB_Any, dbs+X,Y+Height-ScrollBarSize-dbs,Width-ScrollBarSize-dbs*2,ScrollBarSize, 0, 0, Width,#_Flag_BorderLess);|#_Flag_DockBottom)
;   SetElementData(ScrollWidthElement, Element)
;   BindGadgetElementEvent(ScrollWidthElement, @ListScrollBarEvent(), #_Event_Up|#_Event_Down)
  
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Type = \This()\Type
    
    \This()\Scroll\Element = Element
    \This()\Scroll\Vert = ScrollHeightElement
    \This()\Scroll\Horz = ScrollWidthElement
    
    If IsElement(ScrollWidthElement)
      ChangeCurrentElement(\This(), ElementID(ScrollWidthElement))
      \This()\Scroll\Element = Element
      ;\This()\Scroll\ScrollStep = ScrollStep
      \This()\Scroll\Vert = ScrollHeightElement
    EndIf 
    
    If IsElement(ScrollHeightElement)
      ChangeCurrentElement(\This(), ElementID(ScrollHeightElement))
      \This()\Scroll\Element = Element
      ;\This()\Scroll\ScrollStep = ScrollStep
      \This()\Scroll\Horz = ScrollWidthElement
    EndIf
    
    PopListPosition(\This())         
  EndWith
  
  
  
  
  ;ResizeElement(Element, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure
;}

;-
; ListView element example
CompilerIf #PB_Compiler_IsMainFile
  Steps = 0
  
  Procedure ListViewElementEvent(Event.q, EventElement)
    ; Debug EventClass(ElementEvent())
  EndProcedure
  
  Define i
  Define w = OpenWindowElement(#PB_Any, 0,0, 530,255, "Demo ListViewElement()") 
  
  Define  t = GetElementAttribute(w, #_Attribute_CaptionHeight)
  
  ;Define g = ListIconGadget(#PB_Any,10+1,10+t+1,190,100,"",100, #PB_ListIcon_AlwaysShowSelection|#PB_ListIcon_HeaderDragDrop) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  Define g = ListViewGadget(#PB_Any,10+1,10+t+1,190,100) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  
    Debug AddGadgetItem(g, -1, "ListView_133333333333333333333333333333333", ImageID(GetButtonIcon(#PB_ToolBarIcon_Copy)) )
    Debug AddGadgetItem(g, -1, "ListView_2") 
    Debug AddGadgetItem(g, -1, "ListView_3", ImageID(GetButtonIcon(#PB_ToolBarIcon_Cut)) )
    Debug AddGadgetItem(g, 0, "ListView_0", ImageID(GetButtonIcon(#PB_ToolBarIcon_Open)) )
;   Debug AddGadgetItem(g, 1, "ListView_1", ImageID(GetButtonIcon(#PB_ToolBarIcon_Copy)) )
;   Debug AddGadgetItem(g, 2, "ListView_2") 
;   Debug AddGadgetItem(g, 3, "ListView_3", ImageID(GetButtonIcon(#PB_ToolBarIcon_Cut)) )
;   Debug AddGadgetItem(g, 0, "ListView_0", ImageID(GetButtonIcon(#PB_ToolBarIcon_Open)) )
;   Debug  ""
  For i=4 To 10
    Debug AddGadgetItem(g, -1, "ListView_"+Str(i)) 
  Next
  
  Define e = ListViewElement(#PB_Any,210-3,10-3,190+6,100+6,"",#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  
  Debug AddListViewElementItem(e, -1, "ListView_133333333333333333333333333333", GetButtonIcon(#PB_ToolBarIcon_Copy))
  Debug AddListViewElementItem(e, -1, "ListView_2") 
  Debug AddListViewElementItem(e, -1, "ListView_3", GetButtonIcon(#PB_ToolBarIcon_Cut))
  Debug AddListViewElementItem(e, 0, "ListView_0", GetButtonIcon(#PB_ToolBarIcon_Open) )
  
  For i=4 To 10
    Debug AddListViewElementItem(e, -1, "ListView_"+Str(i)) 
  Next
  SetElementState(e, 0)
  
  With *CreateElement
    ChangeCurrentElement(\This(), ElementID(e))
    If ListSize(\This()\Items())
      PushListPosition(\This()\Items()) 
      ForEach \This()\Items() 
        
        Debug "Index "+ListIndex(\This()\Items())+" List "+\This()\Items()\Element+" "+\This()\Items()\text\string$+" "+Str(\This()\Items()\FrameCoordinate\Y)
        
      Next
      PopListPosition(\This()\Items()) 
    EndIf
  EndWith
  ;BindGadgetElementEvent(e, @ListViewElementEvent());, #_Event_Focus)
  WaitWindowEventClose(w)
CompilerEndIf

