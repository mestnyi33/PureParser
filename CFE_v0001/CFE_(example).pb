CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf

;-
; Panel element example
CompilerIf #PB_Compiler_IsMainFile
  Procedure PanelElementEvent()
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
  ;ButtonElement(#PB_Any,10,10,50,35, "1_Butt")                                                                ;
  ContainerElement(#PB_Any,10,10,150,55,#PB_Container_Flat) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
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
  
  ;BindGadgetElementEvent(e, @PanelElementEvent());, #_Event_Focus)
  WaitWindowEventClose(w)
CompilerEndIf

