CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  
  XIncludeFile "CFE.pbi"
CompilerEndIf

;-
; Panel element example
CompilerIf #PB_Compiler_IsMainFile
  Enumeration Elements
    #Desktop
    #Window
    #Select_Type
    #Find
    #SendFind
  EndEnumeration
  
  Procedure Elements_Events()
    Select ElementEvent()
      
    EndSelect
    ;Debug EventClass(ElementEvent())
  EndProcedure
  
 OpenWindowElement(#Window, 0,0, 800,600, "Demo PanelElement()") 
 ContainerElement(#PB_Any, 0,0,0,33,#_Flag_DockTop)
   StringElement(#Find, 5,5, 200,20, "Ведите текст для поиска")
   ButtonElement(#SendFind, 210,5, 40,20, "Найти")
 CloseElementList()
 
  Define e = PanelElement(#Select_Type,210,10,190,550, "", #_Flag_DockClient)                                                               ;
  AddPanelElementItem(e, -1, "Продажа", LoadImage(#PB_Any, #PB_Compiler_Home + "examples/sources/Data/ToolBar/Copy.png"))
  ;ButtonElement(#PB_Any,10,10,50,35, "1_Butt")                                                                ;
  ContainerElement(#PB_Any,10,10,150,55,#PB_Container_Flat) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
  AddPanelElementItem(e, -1, "Покупка") 
  Define b1=ButtonElement(#PB_Any,70,10,50,35, "2_Butt")                                                                ;
  Define b2=ButtonElement(#PB_Any,70,30,50,35, "2_Butt")                                                                ;
  SplitterElement(#PB_Any,10,10,50,55, b1,b2, #PB_Splitter_Separator_Circle)
  
  AddPanelElementItem(e, -1, "Возврать")
  ContainerElement(#PB_Any,10,10,150,55,#PB_Container_Flat) 
  ButtonElement(#PB_Any,10,10,50,35, "butt") 
  CloseElementList()
  
  
  BindElementEvent(@Elements_Events());, #_Event_Focus)
  WaitWindowEventClose(#Window)
CompilerEndIf

