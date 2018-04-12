CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  XIncludeFile "CFE.pbi"
  
CompilerElse
  Declare UpdateScrollCoordinate(List This.S_CREATE_ELEMENT())
CompilerEndIf

;{ - ListIcon element functions
;-
Procedure DrawListIconElementContent(List This.S_CREATE_ELEMENT(), X,Y)
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
      Protected X1=1
      
      PushListPosition(\Columns())
      ForEach \Columns()
        If \Columns()\FrameCoordinate\Height=0
          Break
        EndIf
        
        \Columns()\FrameCoordinate\X=X1
        \Columns()\FrameCoordinate\Y=1
        
        If *CreateElement\This() <> This()
          ClipCoordinate(This(), *CreateElement\This()\FrameCoordinate\X,*CreateElement\This()\FrameCoordinate\Y,*CreateElement\This()\FrameCoordinate\Width,*CreateElement\This()\FrameCoordinate\Height);+MenuHeight)
        EndIf
        
        
        ; Для меню итемов 
        If \Columns()\Disable = 0
          If \Columns()\Element = \Column\Entered\Element
            DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
            Box((X+\Columns()\FrameCoordinate\X)+1, (Y+\Columns()\FrameCoordinate\Y)+1, \Columns()\FrameCoordinate\Width-2, \Columns()\FrameCoordinate\Height-2, \Columns()\EnteredBackColor&$FFFFFF|$80<<24)
            
            DrawingMode(#PB_2DDrawing_Outlined|#PB_2DDrawing_AlphaBlend)
            Box((X+\Columns()\FrameCoordinate\X), (Y+\Columns()\FrameCoordinate\Y), \Columns()\FrameCoordinate\Width, \Columns()\FrameCoordinate\Height, \Columns()\SelectedBackColor&$FFFFFF|$80<<24)
          EndIf
          
          If \Columns()\Element = \Column\Selected\Element 
            If \Element = *CreateElement\ActiveElement Or *CreateElement\This()\Type = #_Type_Menu
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box((X+\Columns()\FrameCoordinate\X), (Y+\Columns()\FrameCoordinate\Y), \Columns()\FrameCoordinate\Width, \Columns()\FrameCoordinate\Height, \Columns()\SelectedBackColor&$FFFFFF|$80<<24)
            Else
              DrawingMode(#PB_2DDrawing_Default|#PB_2DDrawing_AlphaBlend)
              Box((X+\Columns()\FrameCoordinate\X), (Y+\Columns()\FrameCoordinate\Y), \Columns()\FrameCoordinate\Width, \Columns()\FrameCoordinate\Height, \Columns()\FrameColor&$FFFFFF|$80<<24)
            EndIf
          EndIf
        EndIf
        
        DrawContent(\Columns(), X, Y )
        
        If Not IsImage(\Columns()\Img\Image) And \Columns()\Img\Image>0
          X1+\Columns()\FrameCoordinate\Width+3
        Else
          X1+\Columns()\FrameCoordinate\Width
        EndIf
        
      Next
      PopListPosition(\Columns())
      
      PushListPosition(\Items())
      ForEach \Items()
        If \Items()\FrameCoordinate\Height=0
          Break
        EndIf
        
        If \Column\Height
          \Items()\FrameCoordinate\Y=Y1+\Column\Height + 1 
        Else
          \Items()\FrameCoordinate\Y=Y1+\Column\Height
        EndIf
        
        \Items()\FrameCoordinate\X=1
        \Items()\FrameCoordinate\Height = 20
        \Items()\FrameCoordinate\Width = \Column\Width
        
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
        
        
        If ((\Flag&#_Flag_CheckBoxes)=#_Flag_CheckBoxes)
          Protected iHeight = \Items()\FrameCoordinate\Height
          ;If ((\Flag & #_Flag_Border) = #_Flag_Border)
            Protected i = 5
          ;EndIf
          DrawingMode(#PB_2DDrawing_Outlined) 
          If (\Radius > 0)
            RoundBox(X+i, (Y+\Items()\FrameCoordinate\Y)+(iHeight-13)/2, 13, 13, \Radius, \Radius, 0)
          Else
            Box(X+i, (Y+\Items()\FrameCoordinate\Y)+(iHeight-13)/2, 13, 13, 0)
          EndIf
          
          If \Items()\Checked
            DrawingMode(#PB_2DDrawing_Default) 
            Protected xx = X+i, yy = (Y+\Items()\FrameCoordinate\Y)+(iHeight-10)/2, inColor = \FrameColor
            Line(xx+2,Yy+4,4,4,0)
            Line(xx+2,Yy+4+1,3,3,0)
            
            Line(xx+5,Yy+6,6,-6,0)
            Line(xx+5,Yy+6+1,6,-6,0)
          ElseIf \Items()\Inbetween
            DrawingMode(#PB_2DDrawing_Default) 
            Box(X+3+i,(Y+\Items()\FrameCoordinate\Y)+(iHeight-7)/2,7,7, 0)
          EndIf  
          
          \Items()\FrameCoordinate\X = \Column\X+13+4+1
          \Item\X = \Items()\FrameCoordinate\X
        EndIf
        
        DrawContent(\Items(), X, Y )
        
        If Not IsImage(\Items()\Img\Image) And \Items()\Img\Image>0
          Y1+\Items()\FrameCoordinate\Height+3
        Else
          Y1+\Items()\FrameCoordinate\Height
        EndIf
        
      Next
      PopListPosition(\Items())
      
      ;ClipOutput(\X,\Y,\Width,\Height)
    EndIf
  EndWith
  
EndProcedure


Procedure AddListIconElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
  Protected ImageWidth, ImageHeight, TextWidth, TextHeight
  
  With *CreateElement
    Image =- 1 ; TODO
    
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
          \This()\Items()\FrameCoordinate\Height = Image
        Else
          If StartDrawing(CanvasOutput(\Canvas))
            If \This()\FontID 
              DrawingFont(\This()\FontID) 
            Else 
              DrawingFont(GetGadgetFont(#PB_Default)) 
            EndIf
            
            TextHeight = TextHeight("A") 
            
            If ImageHeight : TextHeight = ImageHeight + 6 : EndIf
            StopDrawing()
          EndIf
          
          \This()\Items()\FrameCoordinate\Height = TextHeight  ; - (1 to ...)
          
        EndIf
        
        ;           
        PopListPosition(\This()\Items()) 
      EndIf
      
      If \This()\Scroll\Max = 0 : \This()\Scroll\Max = 2 : EndIf
      \This()\Scroll\Max + TextHeight
      ;Debug \This()\Scroll\Max
      ;\This()\Scroll\Max = \This()\Scroll\Max*\This()\Scroll\Max/ListSize(\This()\Items())\This()\Column\Height
      SetElementAttribute(\This()\Scroll\Vert, #PB_ScrollBar_Maximum, \This()\Scroll\Max+\This()\Column\Height+1);+ElementHeight(\This()\Scroll\Horz))
      
      UpdateScrolls(\This())
    
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn GadgetItem
EndProcedure


Procedure AddListIconElementColumn(GadgetElement, GadgetItem, Text$, Width=0, Image =- 1, Flag.q = 0)
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
      
      ; 
      If GadgetItem = #PB_Any
        LastElement(\This()\Columns())
        AddElement(\This()\Columns()) 
        GadgetItem = ListSize(\This()\Columns())
      Else
        If (GadgetItem > (ListSize(\This()\Columns()) - 1))
          LastElement(\This()\Columns())
          AddElement(\This()\Columns()) 
        Else
          SelectElement(\This()\Columns(), GadgetItem)
          InsertElement(\This()\Columns())
        EndIf
      EndIf
      
      \This()\Columns()\Element = GadgetItem
      \This()\cID(Str(@\This()\Columns())) = GadgetItem
      \This()\cHandle(Str(GadgetItem)) = @\This()\Columns()
      
      
      ;\This()\Columns()\bSize = 2
      If IsElementColumn(GadgetItem)
        PushListPosition(\This()\Columns()) 
        ChangeCurrentElement(\This()\Columns(), ColumnID(GadgetItem))
        
        ;Debug \This()\Columns()\Element
        \This()\Columns()\Flag = Flag
        \This()\Columns()\Text\String$ = Text$
        \This()\Columns()\Img\ImgBg =- 1
        \This()\Columns()\Img\Image = Image
        
        \This()\Columns()\SelectedFontColor = $FFFFFF
        \This()\Columns()\SelectedBackColor = $FFBAA0
        \This()\Columns()\EnteredFontColor = $505050
        \This()\Columns()\EnteredBackColor = $FCDFC3
        
        \This()\Columns()\DrawingMode = #PB_2DDrawing_AlphaBlend
        \This()\Columns()\FrameCoordinate\Height = \This()\InnerCoordinate\Height
        
        \This()\Columns()\BackColor = \This()\BackColor
        \This()\Columns()\FontColor = \This()\FontColor
        \This()\Columns()\FrameColor = \This()\FrameColor
        
        \This()\Column\Width + Width
        \This()\Column\Height = 0
        \This()\Columns()\FrameCoordinate\Height = \This()\Column\Height ; \This()\FrameCoordinate\Height
        \This()\Columns()\FrameCoordinate\Width = Width
        
        ;           
        PopListPosition(\This()\Columns()) 
      EndIf
      
      SetElementAttribute(\This()\Scroll\Horz, #PB_ScrollBar_Maximum, \This()\Column\Width)
  
      UpdateScrolls(\This())
    
      PopListPosition(\This())
    EndIf
  EndWith
  
  ProcedureReturn GadgetItem
EndProcedure


Procedure ListIconScrollBarEvent(Event.q, EventElement)
  
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


Procedure ListIconElement( Element, X,Y,Width,Height, FirstColumnTitle$, FirstColumnWidth, Flag.q = 0, Parent =- 1 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_ListIcon, Element, X,Y,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag);|#_Flag_AlignText_Top )
  
  
  ;If FirstColumnTitle$ : AddListIconElementColumn(Element, 0, FirstColumnTitle$, FirstColumnWidth) : EndIf
  
  
  
  
  
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
;   BindGadgetElementEvent(ScrollHeightElement, @ListIconScrollBarEvent(), #_Event_Up|#_Event_Down)
  
    ScrollWidthElement = ScrollBarElement(#PB_Any, dbs+X,Y+Height-ScrollBarSize-dbs,Width-ScrollBarSize-dbs*2,ScrollBarSize, 0, 0, Width,#_Flag_BorderLess);|#_Flag_DockBottom)
;   SetElementData(ScrollWidthElement, Element)
;   BindGadgetElementEvent(ScrollWidthElement, @ListIconScrollBarEvent(), #_Event_Up|#_Event_Down)
  
  
  With *CreateElement
    PushListPosition(\This())
    ChangeCurrentElement(\This(), ElementID(Element))
    Type = \This()\Type
    
     \This()\Column\Width = Width-17
;     \This()\Column\Height = 30
    
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
; ListIcon element example
CompilerIf #PB_Compiler_IsMainFile
  Steps = 0
  
  Procedure ListIconElementEvent(Event.q, EventElement)
    ; Debug EventClass(ElementEvent())
  EndProcedure
  
  Define i
  Define w = OpenWindowElement(#PB_Any, 0,0, 530,460, "Demo ListIconElement()") 
  
  Define  t = GetElementAttribute(w, #_Attribute_CaptionHeight)
  
  ;Define g = ListIconGadget(#PB_Any,10+1,10+t+1,190,100,"",100, #PB_ListIcon_AlwaysShowSelection|#PB_ListIcon_HeaderDragDrop) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  Define g = ListIconGadget(#PB_Any,10+1,10+t+1,290,200, "Column_0",160, #PB_ListIcon_CheckBoxes) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  
    Debug AddGadgetItem(g, -1, "ListIcon_133333333333333333333333333333333", ImageID(GetButtonIcon(#PB_ToolBarIcon_Copy)) )
    Debug AddGadgetItem(g, -1, "ListIcon_2") 
    Debug AddGadgetItem(g, -1, "ListIcon_3", ImageID(GetButtonIcon(#PB_ToolBarIcon_Cut)) )
    Debug AddGadgetItem(g, 0, "ListIcon_0", ImageID(GetButtonIcon(#PB_ToolBarIcon_Open)) )
    
    AddGadgetColumn(g, 1,"Column_2",100)
                    
    For i=4 To 10
      Debug AddGadgetItem(g, -1, Chr(10)+"ListIcon_"+Str(i)) 
    Next
    ;Debug "#_Flag_CheckBoxes "+#_Flag_CheckBoxes
    Define e = ListIconElement(#PB_Any,10-3,220-3,290+6,200+6, "Column_0",160,#_Flag_CheckBoxes|#_Flag_SizeGadget) ; : LoadGadgetImage(IDE_Elements, #PB_Compiler_Home+"Themes/")                                                               ;
  
  Debug AddListIconElementItem(e, -1, "ListIcon_133333333333333333333333333333", GetButtonIcon(#PB_ToolBarIcon_Copy))
  Debug AddListIconElementItem(e, -1, "ListIcon_2") 
  Debug AddListIconElementItem(e, -1, "ListIcon_3", GetButtonIcon(#PB_ToolBarIcon_Cut))
  Debug AddListIconElementItem(e, 0, "ListIcon_0", GetButtonIcon(#PB_ToolBarIcon_Open) )
  
  AddListIconElementColumn(e, 1,"Column_2",100)
  
  For i=4 To 20
    Debug AddListIconElementItem(e, -1, "ListIcon_"+Str(i)) 
  Next
  ;SetElementState(e, 0)
  
  With *CreateElement
    ChangeCurrentElement(\This(), ElementID(e))
    If ListSize(\This()\Columns())
      PushListPosition(\This()\Columns()) 
      ForEach \This()\Columns() 
        
        Debug "Index "+ListIndex(\This()\Columns())+" List "+\This()\Columns()\Element+" "+\This()\Columns()\text\string$+" "+Str(\This()\Columns()\FrameCoordinate\Y)
        
      Next
      PopListPosition(\This()\Columns()) 
    EndIf
  EndWith
  ;BindGadgetElementEvent(e, @ListIconElementEvent());, #_Event_Focus)
  WaitWindowEventClose(w)
CompilerEndIf

