CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf

;{ Panel element functions
Procedure DrawPanelElementItemsContent(List This.S_CREATE_ELEMENT())
  Protected ScrollWidth = 6
  Protected Result, DrawingMode, Text$
  Protected X,Y,Width,Height
  Protected iX,iY,iWidth,iHeight
  Protected CiX,CiY,CiWidth,CiHeight
  
  With *CreateElement
    If ListSize(\This()\Items())
      Protected ItemX,ItemWidth
      Static lX
      X = \This()\InnerCoordinate\X+1
      Y = (\This()\InnerCoordinate\Y-\This()\CaptionHeight)+1
      
      PushListPosition(\This()\Items())
      ForEach \This()\Items() ; Перебираем все итемы панел элемента
        If \This()\Items()\Element = \This()\Item\Selected\Element
          ItemWidth = \This()\Items()\FrameCoordinate\Width
          If ((\This()\Items()\FrameCoordinate\X)+ItemWidth) > \This()\InnerCoordinate\Width
            lX = - (((\This()\Items()\FrameCoordinate\X+ItemWidth) - \This()\InnerCoordinate\Width)) - 2 ; TODO Пока только уменшаем
          Else
            lX = 0
          EndIf
          
          Height = (\This()\Items()\FrameCoordinate\Height)                            
          ;                 DrawContent1(\This()\Items()\DrawingMode, \This()\Items()\Img\Image, 
          ;                              ;lX+(X+\This()\Items()\FrameCoordinate\X), (Y+\This()\Items()\FrameCoordinate\Y), ItemWidth,Height+2,
          ;                              \This()\X,\This()\Y,\This()\Width,\This()\CaptionHeight+2,
          ;                              lX+(X+\This()\Items()\FrameCoordinate\X), (Y+\This()\Items()\FrameCoordinate\Y), ItemWidth,Height+2,
          ;                              \This()\Items()\Text\String$, \This()\Items()\Flag)
          
          ;\This()\Items()\FrameCoordinate\Height = \This()\Items()\FrameCoordinate\Height - 2
          \This()\Items()\BackColor =- 1
          ;\This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
          \This()\Items()\FrameCoordinate\Y = 0
          DrawContent(\This()\Items(), X,Y,0,2)
          
          
          ; ;                 ; Линия между табом и элементом
          ; ;                 DrawingMode(#PB_2DDrawing_Default)
          ; ;                 ;ClipOutput(\This()\X,(Y+\This()\Items()\FrameCoordinate\Y+Height)+1,\This()\Width,1)
          ; ;                 Line(\This()\X,(Y+\This()\Items()\FrameCoordinate\Y+Height)+1, \This()\Items()\FrameCoordinate\X+6, 1,\This()\FrameColor)
          ; ;                 Line((X+\This()\Items()\FrameCoordinate\X)+1,(Y+\This()\Items()\FrameCoordinate\Y+Height)+1, \This()\Items()\FrameCoordinate\Width-2, 1,$E5E5E5);\This()\BackColor)
          ; ;                 Line((X+\This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width),(Y+\This()\Items()\FrameCoordinate\Y+Height)+1, (\This()\Width-\This()\bSize*2)-(\This()\Items()\FrameCoordinate\X+\This()\Items()\FrameCoordinate\Width), 1,\This()\FrameColor)
        Else
          ItemX = \This()\Items()\FrameCoordinate\X
          ItemWidth = \This()\Items()\FrameCoordinate\Width
          
          ; Если ширина итема вишла за предели элемента
          If ((\This()\Items()\FrameCoordinate\X)+ItemWidth) > \This()\InnerCoordinate\Width
            ItemWidth - (((\This()\Items()\FrameCoordinate\X+ItemWidth) - \This()\InnerCoordinate\Width)) - 2 ; TODO Пока только уменшаем
          EndIf
          
          ; Если итем вишел за предели элемента
          If (\This()\Items()\FrameCoordinate\X > \This()\InnerCoordinate\Width)
            ItemWidth = 0
          EndIf
          
          If (lX+ItemX) < 0
            ItemX = 27
            ItemWidth = 19
          EndIf
          
          Height=\This()\Items()\FrameCoordinate\Height-2
          ;                 DrawContent1(\This()\Items()\DrawingMode, \This()\Items()\Img\Image, 
          ;                              lX+(X+ItemX), (Y+\This()\Items()\FrameCoordinate\Y)+2, ItemWidth, Height, ; \This()\X,\This()\Y,\This()\Width,\This()\CaptionHeight+2,
          ;                              lX+(X+ItemX), (Y+\This()\Items()\FrameCoordinate\Y)+2, ItemWidth, Height,
          ;                              \This()\Items()\Text\String$, \This()\Items()\Flag)
          
          ;\This()\Items()\FrameCoordinate\Height = \This()\Items()\FrameCoordinate\Height - 2
          \This()\Items()\BackColor =- 1
          ;\This()\Items()\DrawingMode = #PB_2DDrawing_Gradient
          
          \This()\Items()\FrameCoordinate\Y = 2
          DrawContent(\This()\Items(), X,Y,0,-2)
        EndIf
      Next
      PopListPosition(\This()\Items())
    EndIf
  EndWith
EndProcedure

Procedure SetPanelElementState(List This.S_CREATE_ELEMENT(), State)
  Protected Result, Parent =- 1  
  
  With This()
    Parent = \Element
    
    PushListPosition(This())
    While NextElement(This()) 
      If IsChildElement(\Element, Parent)
        If \Parent\Item = State 
          ;Debug "State "+\Element
          
          Protected ParentElement = \Element
          Protected ElementParent = \Parent\Element
          
          While IsElement(ParentElement)
            PushListPosition(This()) 
            If (ParentElement = ElementParent) : Break : EndIf
            ChangeCurrentElement(This(), ElementID(ParentElement))
            ParentElement = \Parent\Element
            PopListPosition(This())
          Wend
          
          If IsElement(ParentElement)
            PushListPosition(This())
            ChangeCurrentElement(This(), ElementID(ParentElement))
            Result = \HideState
            PopListPosition(This())
          EndIf
          
          If Result = #False  ; : Debug "Element "+\Element
            \Hide = \HideState
          EndIf
        Else
          \Hide = #True
        EndIf
        
      EndIf
    Wend
    PopListPosition(This())
  EndWith
  
  ProcedureReturn Result
EndProcedure

Procedure AddPanelElementItem(GadgetElement, GadgetItem, Text$, Image =- 1, Flag.q = 0)
  ProcedureReturn AddElementItem(GadgetElement, GadgetItem, Text$, Image, Flag)
EndProcedure

Procedure PanelElement( Element, X,Y,Width,Height, Flag.q = 0, Parent =- 1 )
  Protected PrevParent =- 1 : If IsElement(Parent) : PrevParent = OpenElementList(Parent) : EndIf
  
  Element = CreateElement( #_Type_Panel, Element, X,Y,Width,Height,"", #PB_Default,#PB_Default,#PB_Default, Flag);|#_Flag_AlignText_Top )
  
  ;If Title : AddPanelElementItem(Element, 0, Title) : EndIf
  
  If IsElement(PrevParent) : OpenElementList(PrevParent) : EndIf
  ProcedureReturn Element
EndProcedure

;}

;-
; Panel element example
CompilerIf #PB_Compiler_IsMainFile
  Procedure PanelElementEvent(Event.q, EventElement)
    Debug EventClass(ElementEvent())
  EndProcedure
  
  Define w = OpenWindowElement(#PB_Any, 0,0, 430,255, "Demo PanelElement()") 
  
  Define  t = GetElementAttribute(w, #_Attribute_CaptionHeight)
  
  Define g = PanelGadget(#PB_Any,10+1,10+t+1,190,100)                                                               ;
    AddGadgetItem(g, -1, "Panel_1", ImageID(LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png")))
    ButtonGadget(#PB_Any,30,30,50,35, "1_Butt")                                                                ;
    
    AddGadgetItem(g, -1, "Panel_2") 
    ButtonGadget(#PB_Any,70,30,50,35, "2_Butt")                                                                ;
    
    AddGadgetItem(g, -1, "Panel_3_long")
    ContainerGadget(#PB_Any,10,10,150,55) 
      ButtonGadget(#PB_Any,10,10,50,35, "butt") 
    CloseGadgetList()
    
    AddGadgetItem(g, -1, "Panel_4", ImageID(LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png")))
    ButtonGadget(#PB_Any,110,30,50,35, "3_Butt")                                                               ;
    
    AddGadgetItem(g, -1, "Panel_5")
    AddGadgetItem(g, -1, "Panel_6")
  CloseGadgetList()
  
  
  
  Define e = PanelElement(#PB_Any,210,10,190,100)                                                               ;
  AddPanelElementItem(e, -1, "Panel_1", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ButtonElement(#PB_Any,30,30,50,35, "1_Butt")                                                                ;
  
  AddPanelElementItem(e, -1, "Panel_2") 
  Define b1=ButtonElement(#PB_Any,70,10,50,35, "2_Butt")                                                                ;
  Define b2=ButtonElement(#PB_Any,70,30,50,35, "2_Butt")                                                                ;
  SplitterElement(#PB_Any,10,10,50,55, b1,b2, #PB_Splitter_Separator_Circle)
  
  AddPanelElementItem(e, -1, "Panel_3_long")
  ContainerElement(#PB_Any,10,10,150,55,#PB_Container_Flat) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
  AddPanelElementItem(e, -1, "Panel_4", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Cut.png"))
  ButtonElement(#PB_Any,110,30,50,35, "3_Butt")                                                               ;
  
  AddPanelElementItem(e, -1, "Panel_5")
  AddPanelElementItem(e, -1, "Panel_6")
  CloseElementList()
  
  ;SetElementState(e,1)
  
  ;BindGadgetElementEvent(e, @PanelElementEvent());, #_Event_Focus)
  WaitWindowEventClose(w)
CompilerEndIf

